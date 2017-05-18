# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ClassesController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resources::AADGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)

		@school = education_service.get_school(params[:school_id])
		@my_classes = education_service.get_my_sections(@school.school_id)	
		@classes = education_service.get_sections(@school.school_id)
		@classes.value.each do |c| 
			c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.object_id == c.object_id}
		end
	end

	def more
		edu_school_id = params[:edu_school_id]
		skip_token = params[:skip_token]

		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resources::AADGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)
		
		@my_classes = education_service.get_my_sections(edu_school_id)	
		@classes = education_service.get_sections(edu_school_id, skip_token)
		@classes.value.each do |c| 
			c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.object_id == c.object_id}
		end

		render json: {
			skip_token: @classes.next_link.skip_token,
			values: @classes.value.map do |c|
				{
					is_my: c.custom_data[:is_my],
					object_id: c.object_id,
					display_name: c.display_name,
					course_name: c.course_name,
					course_id: c.course_id,
					course_description: c.course_description,
					combined_course_number: c.combined_course_number,
					teacher_name: c.term_name,
					term_start_time: Date.strptime(c.term_start_date, '%m/%d/%Y'),
					term_end_time: Date.strptime(c.term_end_date, '%m/%d/%Y'),
					period: c.period,
				}
			end
		}
	end

	def show
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resources::AADGraph)
		ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resources::MSGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)
		ms_graph_servcie = MSGraphService.new(ms_access_token)

		class_object_id = params[:id];
		@school = education_service.get_school(params[:school_id])
		@class = education_service.get_section(class_object_id)
		@class.members = education_service.get_section_members(class_object_id)

		@conversations = ms_graph_servcie.get_conversations(class_object_id)
		@documents = ms_graph_servcie.get_documents(class_object_id)
		
		user_service = UserService.new		
		seating_position_hash = user_service.get_seating_position_hash(class_object_id)
		favorite_color_hash = user_service.get_favorite_color_hash(@class.members.map{ |m| m.object_id })
		
		@class.members.each do |m|
			m.custom_data[:position] = seating_position_hash[m.object_id]
			m.custom_data[:favorite_color] = favorite_color_hash[m.object_id]
			if m.is_teacher?
				@teacher_favorite_color = favorite_color_hash[m.object_id]
			end
		end
	end

	def seatings_post
		user_service = UserService.new
		user_service.save_seating_positions(params[:class_id], params[:postions].values)
		render json: {status: 'success'}
	end

	class << self
		attr_accessor :current_user_course_ids
	end
end