# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ClassesController < ApplicationController

  before_action :require_login
  before_action :linked_users_only

  def index
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)

    @school = education_service.get_school(params[:school_id])
    @my_classes = education_service.get_my_classes(@school.id)
    @classes = education_service.get_classes(@school.id, 12)
    @classes.value.each do |c| 
      c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.id == c.id}
    end
  end

  def more
    school_id = params[:school_id]
    skip_token = params[:skip_token]

    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    
    @my_classes = education_service.get_my_classes(school_id)  
    @classes = education_service.get_classes(school_id, 12, skip_token)
    @classes.value.each do |c| 
      c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.id == c.id}
    end

    render json: {
      skip_token: @classes.next_link ? @classes.next_link.skip_token: nil,
      values: @classes.value.map do |c|
        {
          is_my: c.custom_data[:is_my],
          display_name: c.display_name,
          code: c.code,
          teachers: c.teachers.map{ |t| { display_name: t.display_name } },
          description: c.description,
          term_name: c.term.display_name,
          term_start_time: c.term.start_date.to_s,
          term_end_time: c.term.end_date.to_s
        }
      end
    }
  end

  def show
    #aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    ms_graph_servcie = MSGraphService.new(ms_access_token)

    class_object_id = params[:id];
    @school = education_service.get_school(params[:school_id])
    @class = education_service.get_class(class_object_id)
    @class.members = education_service.get_class_members(class_object_id)

    @conversations = ms_graph_servcie.get_conversations(class_object_id)
    @documents = ms_graph_servcie.get_documents(class_object_id)
    @documents_web_url = ms_graph_servcie.get_documents_web_url(class_object_id)
    user_service = UserService.new    
    seating_position_hash = user_service.get_seating_position_hash(class_object_id)
    favorite_color_hash = user_service.get_favorite_color_hash(@class.members.map{ |m| m.id })
    
    @class.members.each do |m|
      m.custom_data[:position] = seating_position_hash[m.id]
      m.custom_data[:favorite_color] = favorite_color_hash[m.id]
      if m.is_teacher?
        @teacher_favorite_color = favorite_color_hash[m.id]
      end
    end

    school_teachers = education_service.get_teachers(@school.number);
    @schoolTeachers = school_teachers.select do |teacher|
      @class.teachers.select{|classteacher| classteacher.id == teacher.id}.length == 0
    end

  end
  def add_coteacher
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
    result = education_service.add_user_to_class_as_member(params[:id], params[:user_id])
    education_service.add_user_to_class_as_owner(params[:id], params[:user_id])
    render json: {status: 'success'}
  end
  def save_seating_positions
    user_service = UserService.new
    user_service.save_seating_positions(params[:id], params['_json'])
    render json: {status: 'success'}
  end

  class << self
    attr_accessor :current_user_course_ids
  end
end