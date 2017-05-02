# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController

	before_action :set_current_user, only: :index

	def index
		redirect_to(link_index_path) && return unless current_user[:is_linked]

		session[:roles] = aad_graph.get_roles # 获取roles 通过数据库

		# school = Service::Education::School.new(aad_graph)
		_token_obj = TokenService.new(cookies[:o365_login_email])
		school = SchoolsService.new(tenant_name, _token_obj, current_user[:school_number])

		@me = current_user
		@schools = school.get_all_schools
	end

	def classes
		@school_id 		= params[:id]
		school_number = params[:school_number]
		@school_name 	= params[:school_name]
		@low_grade 		= params[:low_grade]
		@high_grade		= params[:high_grade]
		@principal 		= params[:principal]

		@class_info = {
			school_id: @school_id,
			school_number: school_number,
			school_name: @school_name,
			low_grade: @low_grade,
			high_grade: @high_grade,
			principal: @principal
		}

		# class_obj = Service::Education::SchoolClass.new(aad_graph, school_number)
		_ts = TokenService.new(cookies[:o365_login_email])
    class_obj = SchoolsService.new(self.tenant_name, _ts, school_number)
		@myclasses = class_obj.get_my_classes_by_school_number(current_user)

		@class_teacher_mapping = class_obj.get_my_cleasses_teacher_mapping
		@mycourseids = @myclasses.map do |myclass| 
			myclass[Constant.get(:edu_course_id)]
		end

		self.class.current_user_course_ids = @mycourseids
		res = class_obj.get_classes_by_school_number
		next_link = (res['odata.nextLink'] || "").match(/skiptoken=(.*)$/)
		@skip_token = next_link ? next_link[1] : nil

		@url_params = URI.encode_www_form({
			school_name: 	 @class_info[:school_name],
			low_grade:  	 @class_info[:low_grade],
			high_grade:    @class_info[:high_grade],
			principal:     @class_info[:principal],
			school_number: @class_info[:school_number]
		})

		@allclasses = res['value']
	end

	def next_class
		school_id = params[:school_id]
		school_number = params[:school_number]
		skip_token = params[:skip_token]
		url_params = params[:url_params]

		# class_obj = Service::Education::SchoolClass.new(aad_graph, school_number)
		_ts = TokenService.new(cookies[:o365_login_email])
    class_obj = SchoolsService.new(self.tenant_name, _ts, school_number)
		res = class_obj.get_classes_by_school_number(skip_token)
		next_link = (res['odata.nextLink'] || "").match(/skiptoken=(.*)$/)
		skip_token = next_link ? next_link[1] : ""

		render json: {
			skip_token: skip_token,
			school_id: school_id,
			url_params: url_params,
			values: res['value'].map do |course|
				{
					is_my_course: self.class.current_user_course_ids.include?(course[Constant.get(:edu_course_id)]) ? true : false,
					class_id: course['id'],
					displayName: course[Constant.get(:display_name)],
					course_subject: course[Constant.get(:edu_course_suject)][0..2].upcase,
					course_number: course[Constant.get(:edu_course_number)],
					course_id: course[Constant.get(:edu_course_id)],
					course_desc: course[Constant.get(:edu_course_desc)],
					teacher_name: course[Constant.get(:edu_term_name)],
					start_time: Date.strptime(course[Constant.get(:edu_term_start_date)], '%m/%d/%Y'),
					end_time: Date.strptime(course[Constant.get(:edu_term_end_date)], '%m/%d/%Y'),
					period: course[Constant.get(:edu_period)],
				}
			end
		}
	end

	def class_info
		school_id = params[:id]
		class_id = params[:class_id]

		@class_info = {
			school_id: params[:id],
			school_number: params[:school_number],
			school_name: params[:school_name],
			low_grade: params[:low_grade],
			high_grade: params[:high_grade],
			principal: params[:principal]
		}

		# class_obj = Service::Education::SchoolClass.new(ms_graph, params[:school_number])
		_ts = TokenService.new(cookies[:o365_login_email])
    class_obj = SchoolsService.new(self.tenant_name, _ts, params[:school_number])
		@user_info = User.find_by_o365_email(cookies[:o365_login_email])
		student_setting_info = ClassroomSeatingArrangement.where("class_id = ? and position != 0", class_id).order("position asc")

		@student_settings = student_setting_info.group_by{ |_| _.position }
		student_ids = student_setting_info.map{|_| _.user_id }

		@conversations = class_obj.get_conversations_by_class_id(class_id)
		@items = class_obj.get_documents_by_class_id(class_id)

		@myclass = class_obj.get_class_info(class_id)
		
		members = class_obj.get_class_members(class_id)
		@student_info = []
		@id_name = {}
		@id_color = {}

		user_obj = UserService.new(aad_graph, ms_graph)
		members["value"].each do |member|
			resource_name = member['url'].split("#{tenant_name}/").last
			_tmp = aad_graph.get_resource(resource_name)

			@id_name[_tmp[Constant.get(:object_id)]] = _tmp[Constant.get(:display_name)]

			account = User.find_by_o365_email(_tmp['mail'])
			@id_color[_tmp[Constant.get(:object_id)]] = account.try(:favorite_color)

			@student_info << {
				user_id: _tmp[Constant.get(:object_id)], 
				displayName: _tmp[Constant.get(:display_name)], 
				object_type: _tmp[Constant.get(:edu_object_type)],
				email: _tmp[Constant.get(:principal_name)],
				grade: _tmp[Constant.get(:edu_grade)],
				photo: user_obj.get_user_photo_url(_tmp[Constant.get(:object_id)]),
				has_seat: student_ids.include?(_tmp[Constant.get(:object_id)]) ? true : false
			}
		end

	end

	def users
		@school_id 		= params[:id]
		school_number = params[:school_number]
		@school_name 	= params[:school_name]
		@low_grade 		= params[:low_grade]
		@high_grade 	= params[:high_grade]
		@principal 		= params[:principal]
		
		@class_info = {
			school_id: @school_id,
			school_number: school_number,
			school_name: @school_name,
			low_grade: @low_grade,
			high_grade: @high_grade,
			principal: @principal
		}

		_ts = TokenService.new(cookies[:o365_login_email])
    class_obj = SchoolsService.new(self.tenant_name, _ts, school_number)
		# user_obj = Service::Education::SchoolUser.new(aad_graph, school_number)
		user_obj = class_obj.edu_section_user
		res_all = user_obj.get_users
		@all_next_link = res_all["odata.nextLink"]
		res_teacher = user_obj.get_teachers
		res_student = user_obj.get_students

		@teacher_next_link = res_teacher['odata.nextLink']
		@student_next_link = res_student['odata.nextLink']

		@teachers = res_teacher['value']
		@students = res_student['value']
		@all = res_all['value']
	end

	def next_users
		school_number = params[:school_number]
		next_link = params[:next_link].match(/skiptoken=(.*)$/)[1]
		type = params[:type]

		# user_obj = Service::Education::SchoolUser.new(aad_graph, school_number)
		_ts = TokenService.new(cookies[:o365_login_email])
    class_obj = SchoolsService.new(self.tenant_name, _ts, school_number)
		user_obj = class_obj.edu_section_user
		if type == 'users'
			res = user_obj.get_users(skiptoken: next_link)
		elsif type == 'teachers'
			res = user_obj.get_teachers(next_link)
		else
			res = user_obj.get_students(next_link)
		end

		if res['odata.error'] && 
			 res['odata.error']['code'] == Constant.get(:errors)[:token_expired]
			render json: {
				expired: true
			}
			return 
		end

		render json: {
			skip_token: res['odata.nextLink'],
			values: res['value'].map do |_user|
				{
					object_type: _user[Constant.get(:edu_object_type)],
					objectId: _user[Constant.get(:object_id)],
					displayName: _user[Constant.get(:display_name)],
					photo: get_user_photo_url(_user[Constant.get(:object_id)])
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
