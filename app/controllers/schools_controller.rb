# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController

  before_action :require_login
  before_action :linked_users_only

  def index
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
      
    @me = education_service.get_me
    @schools = education_service.get_all_schools
      .sort_by { |s| ((s.school_id == @me.school_id) ? 'A' : 'Z') + s.display_name }
  end

  def users
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

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

    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

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