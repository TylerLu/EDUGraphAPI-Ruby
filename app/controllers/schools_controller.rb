# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController

  before_action :require_login
  before_action :link_users_only

  def index
    aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)
      
    @me = education_service.get_me
    @schools = education_service.get_all_schools
      .sort_by { |s| ((s.school_id == @me.school_id) ? 'A' : 'Z') + s.display_name }

    # get locations
    if Settings.BingMapKey
      bing_map_service = BingMapService.new(Settings.BingMapKey)
      @schools.each do |s| 
        if s.address
          s.custom_data[:location] = bing_map_service.get_longitude_and_latitude_by_address(s.address)
        end
      end
    end
  end

  def users
    aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)

    @school = education_service.get_school(params[:id])
    @users = education_service.get_members(@school.object_id)
    @teachers = education_service.get_teachers(@school.school_id)
    @students = education_service.get_students(@school.school_id)
  end

  def users_next
    school_object_id = params[:id]
    school_id = params[:school_id]
    skip_token = params[:skip_token]
    type = params[:type]

    aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)

    if type == 'users'
      users = education_service.get_members(school_object_id, skip_token)
    elsif type == 'teachers'
      users = education_service.get_teachers(school_id, skip_token)
    else
      users = education_service.get_students(school_id, skip_token)
    end

    render json: {
      skip_token: users.next_link ? users.next_link.skip_token : nil,
      values: users.value.map do |user|
        {
          object_type: user.education_object_type,
          object_id: user.object_id,
          display_name: user.display_name
        }
      end
    }
  end

end