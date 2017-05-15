# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
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

	def classes
		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)
		
		@school = education_service.get_school(params[:id])
		@my_classes = education_service.get_my_sections(@school.school_id)	
		@classes = education_service.get_sections(@school.school_id)
		@classes.value.each do |c| 
			c.custom_data[:is_my] = @my_classes.any?{ |mc| mc.object_id == c.object_id}
		end
	end

	def next_classes
		school_id = params[:school_id]
		skip_token = params[:skip_token]

		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)

		@my_classes = education_service.get_my_sections(school_id)	
		@classes = education_service.get_sections(school_id, skip_token)
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

	def class_info
		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
		ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::MSGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)
		ms_graph_servcie = MSGraphService.new(ms_access_token)

		class_object_id = params[:class_id];
		@school = education_service.get_school(params[:id])
		@class = education_service.get_section(class_object_id)
		@class.members = education_service.get_section_members(class_object_id)

		@conversations = ms_graph_servcie.get_conversations(class_object_id)
		@documents = ms_graph_servcie.get_documents(class_object_id)
		
		seating_position_hash = ClassroomSeatingArrangement
			.where("class_id = ? and position != 0", class_object_id)
			.pluck(:user_id, :position)
			.to_h

		favorite_color_hash = User
			.where('o365_user_id', @class.members.map{ |m| m.object_id } )
			.pluck(:o365_user_id, :favorite_color)
			.to_h
		
		@class.members.each do |m|
			m.custom_data[:position] = seating_position_hash[m.object_id]
			m.custom_data[:favorite_color] = favorite_color_hash[m.object_id]
			if m.is_teacher?
				@teacher_favorite_color = favorite_color_hash[m.object_id]
			end
		end
	end

	def users
		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
		education_service = Education::EducationService.new(current_user.tenant_id, aad_access_token)

		@school = education_service.get_school(params[:id])
		@users = education_service.get_members(@school.object_id)
		@teachers = education_service.get_teachers(@school.school_id)
		@students = education_service.get_students(@school.school_id)
	end

	def next_users
		school_object_id = params[:id]
		school_id = params[:school_id]
		skip_token = params[:skip_token]
		type = params[:type]

		token_service = TokenService.new
		aad_access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
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

	def save_settings
		params[:postions].values.each do |info|
			user_set = ClassroomSeatingArrangement.find_by({class_id: info['ClassId'],user_id: info['O365UserId']})
			if user_set
				user_set.position = info['Position']
				user_set.save
			else
				ClassroomSeatingArrangement.create({
					class_id: info['ClassId'],
					user_id: info['O365UserId'],
					position: info['Position']
				})
			end
		end

		render json: {status: 'success'}
	end

	class << self
		attr_accessor :current_user_course_ids
	end
end