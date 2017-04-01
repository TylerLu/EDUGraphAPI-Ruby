# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController
	include BingMapHelper

	def index
		# 根据 access_token 获取登录用户信息
		account = Account.find_by_email(session[:current_user][:email]) || Account.find_by_o365_email(cookies[:o365_login_email])
		if !account || account.o365_email.blank? || account.email.blank?
			redirect_to link_index_path 
			return
		end

		@me = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'me',
			access_token: session[:gwn_access_token]
		})

		session[:current_user] = {
			user_identify: @me[Constant.get(:edu_object_type)],
			display_name: @me[Constant.get(:display_name)],
			school_number: @me[Constant.get(:edu_school_id)],
			photo: get_user_photo_url(@me[Constant.get(:object_id)])
		}

		classes = if is_admin?
			[]
		else
			graph_request({
				host: 'graph.microsoft.com',
				tenant_name: Settings.tenant_name,
				access_token: session[:gmc_access_token]
			}).me.member_of.map do |_class|
				_class.display_name
			end
		end

		session[:current_user][:myclasses] = classes

		all_schools = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'administrativeUnits',
			access_token: session[:gwn_access_token]
		})['value']

		all_schools = all_schools.map do |_school| 
			_school.merge(location: get_longitude_and_latitude_by_address("#{_school[Constant.get(:edu_state)]}/#{_school[Constant.get(:edu_city)]}/#{_school[Constant.get(:edu_address)]}"))
		end

		schools = []
		other_schools = []
		all_schools.reduce(schools) do |res, ele| 
			if ele[Constant.get(:edu_school_number)] == @me[Constant.get(:edu_school_id)]
				res << ele
			else
				other_schools << ele
			end
			res
		end

		@schools = schools.concat other_schools.sort_by{|_| _['displayName'][0] }
		
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

		# https://graph.windows.net/canvizEDU.onmicrosoft.com/users/gmartin@canvizEDU.onmicrosoft.com/memberOf

		@myclasses = if session[:current_user][:school_number] == school_number 
			graph_request({
				host: 'graph.windows.net',
				tenant_name: Settings.tenant_name,
				access_token: session[:gwn_access_token],
				resource_name: "users/#{cookies[:o365_login_email]}/memberOf"
			})['value'].select{|_class| _class['objectType'] == 'Group' }
		else
			[]
		end

		@mycourseids = @myclasses.map do |myclass| 
			myclass[Constant.get(:edu_course_id)]
		end

		self.class.current_user_course_ids = @mycourseids

		res = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'groups',
			access_token: session[:gwn_access_token],
			query: {
				"$top" => 12,
				"$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
			}
		})

		next_link = (res['odata.nextLink'] || "").match(/skiptoken=(.*)$/)

		@skip_token = nil
		@skip_token = next_link[1] if next_link

		# @url_params = URI.encode "school_name=#{@class_info[:school_name]}&low_grade=#{@class_info[:low_grade]}&high_grade=#{@class_info[:high_grade]}&principal=#{@class_info[:principal]}&school_number=#{@class_info[:school_number]}"
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

		res = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			access_token: session[:gwn_access_token],
			resource_name: 'groups',
			query: {
				"$top" => 12,
				"$skiptoken" => "#{skip_token}",
				"$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
			}
		})
		next_link = (res['odata.nextLink'] || "").match(/skiptoken=(.*)$/)

		skip_token = ""
		skip_token = next_link[1] if next_link

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

		@user_info = Account.find_by_o365_email(cookies[:o365_login_email])
		student_setting_info = StudentSetting.where("class_id = ? and position != 0", class_id).order("position asc")

		@student_settings = student_setting_info.group_by{ |_| _.position }
		student_ids = student_setting_info.map{|_| _.user_id }

		graph = graph_request({
			host: 'graph.microsoft.com',
			access_token: session[:gmc_access_token]
		})

		@conversations = graph.groups.find(class_id).conversations rescue []

		@items = graph.groups.find(class_id).drive.root.children rescue []

		@myclass = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: "groups/#{class_id}",
			access_token: session[:gwn_access_token]
		})

		members = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: "groups/#{class_id}/$links/members",
			access_token: session[:gwn_access_token]
		})

		@student_info = []
		@id_name = {}
		@id_color = {}

		members["value"].each do |member|
			_tmp = graph_request({
				host: 'graph.windows.net',
				tenant_name: Settings.tenant_name,
				access_token: session[:gwn_access_token],
				resource_name: member['url'].split("#{Settings.tenant_name}/").last
			})

			@id_name[_tmp[Constant.get(:object_id)]] = _tmp[Constant.get(:display_name)]

			account = Account.find_by_o365_email(_tmp['mail'])
			@id_color[_tmp[Constant.get(:object_id)]] = account.try(:favorite_color)

			@student_info << {
				user_id: _tmp[Constant.get(:object_id)], 
				displayName: _tmp[Constant.get(:display_name)], 
				object_type: _tmp[Constant.get(:edu_object_type)],
				email: _tmp[Constant.get(:principal_name)],
				grade: _tmp[Constant.get(:edu_grade)],
				photo: get_user_photo_url(_tmp[Constant.get(:object_id)]),
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

		res_all = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'users',
			access_token: session[:gwn_access_token],
			query: {
				"$top" => 12,
				"$filter" => "#{Constant.get('edu_school_id')} eq '#{school_number}'"
			}
		})

		@all_next_link = res_all["odata.nextLink"]

		res_teacher = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'users',
			access_token: session[:gwn_access_token],
			query: {
				"$top" => 12,
				"$filter" => "#{Constant.get('edu_object_type')} eq 'Teacher' and #{Constant.get('edu_school_id')} eq '#{school_number}'"
			}
		})

		res_student = graph_request({
			host: 'graph.windows.net',
			tenant_name: Settings.tenant_name,
			resource_name: 'users',
			access_token: session[:gwn_access_token],
			query: {
				"$top" => 12,
				"$filter" => "#{Constant.get('edu_object_type')} eq 'Student' and #{Constant.get('edu_school_id')} eq '#{school_number}'"
			}
		})

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

		if type == 'users'
			res = graph_request({
				host: 'graph.windows.net',
				tenant_name: Settings.tenant_name,
				resource_name: 'users',
				access_token: session[:gwn_access_token],
				query: {
					"$skiptoken" => next_link,
					"$top" => 12,
					"$filter" => "#{Constant.get(:edu_school_id)} eq '#{school_number}'"
				}
			})
		elsif type == 'teachers'
			res = graph_request({
				host: 'graph.windows.net',
				tenant_name: Settings.tenant_name,
				resource_name: 'users',
				access_token: session[:gwn_access_token],
				query: {
					"$skiptoken" => next_link,
					"$top" => 12,
					"$filter" => "#{Constant.get(:edu_object_type)} eq 'Teacher' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
				}
			})
		else
			res = graph_request({
				host: 'graph.windows.net',
				tenant_name: Settings.tenant_name,
				resource_name: 'users',
				access_token: session[:gwn_access_token],
				query: {
					"$skiptoken" => next_link,
					"$top" => 12,
					"$filter" => "#{Constant.get(:edu_object_type)} eq 'Student' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
				}
			})
		end

		if res['odata.error'] && 
			 res['odata.error']['code'] == Constant.get[:errors][:token_expired]
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
			user_set = StudentSetting.find_by({class_id: info['ClassId'],user_id: info['O365UserId']})
			if user_set
				user_set.position = info['Position']
				user_set.save
			else
				StudentSetting.create({
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
