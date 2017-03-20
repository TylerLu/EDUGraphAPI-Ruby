class SchoolsController < ApplicationController
	def index
		# 根据access_token 获取登录用户信息
		@me = JSON.parse HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/me?api-version=beta", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body

		session[:current_user] = {
			user_identify: @me["extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType"],
			display_name: @me["displayName"],
			school_number: @me["extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId"],
			photo: get_user_photo_url(@me['objectId'])
		}

		classes = if is_admin?
			[]
		else
		 	JSON.parse(
				HTTParty.get('https://graph.microsoft.com/v1.0/me/memberOf', headers: {
					"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
					"Content-Type" => "application/x-www-form-urlencoded"
				}).body
			)["value"].map{ |_class| _class['displayName'] }
		end

		session[:current_user][:myclasses] = classes

		# 根据access_token 获取schools信息
		all_schools = JSON.parse(HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/administrativeUnits",
			query: {
				"api-version" => "beta"
			},
		  headers: {
				"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
				"Content-Type" => "application/x-www-form-urlencoded"
 			}).body)["value"]
		schools = []
		other_schools = []
		all_schools.reduce(schools) do |res, ele| 
			if ele['extension_fe2174665583431c953114ff7268b7b3_Education_SchoolNumber'] == @me['extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId']
				res << ele 
			else
				other_schools << ele
			end
			res
		end

		@schools = schools.concat other_schools
		
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

		@myclasses = if session[:current_user][:school_number] == school_number 
			JSON.parse(
				HTTParty.get('https://graph.microsoft.com/v1.0/me/memberOf', headers: {
					"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
					"Content-Type" => "application/x-www-form-urlencoded"
				}).body
			)["value"]
		else
			[]
		end
		# p @myclasses

		@mycourseids = @myclasses.map do |myclass| 
			myclass['extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_CourseId']
		end

		res = JSON.parse HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/groups?api-version=beta&$filter=extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType%20eq%20'Section'%20and%20extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId%20eq%20'#{school_number}'", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body

		@allclasses = res['value']
	end

	def class_info
		school_id = params["id"]
		class_id = params["class_id"]

		@class_info = {
			school_id: params[:id],
			school_number: params[:school_number],
			school_name: params[:school_name],
			low_grade: params[:low_grade],
			high_grade: params[:high_grade],
			principal: params[:principal]
		}

		# 获取会话
		@conversations = JSON.parse(HTTParty.get("https://graph.microsoft.com/v1.0/groups/#{class_id}/conversations", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body)["value"] rescue []

		# 获取documents
		@items = JSON.parse(HTTParty.get("https://graph.microsoft.com/beta/groups/#{class_id}/drive/root/children", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gmc_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body)["value"] rescue []

		# p @items

		@myclass = JSON.parse HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/groups/#{class_id}?api-version=beta", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body		

		# p @myclass

		members = JSON.parse HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/groups/#{class_id}/$links/members?api-version=beta", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body

		@student_info = []

		members["value"].each do |member|
			_tmp = JSON.parse HTTParty.get("#{member['url']}?api-version=beta", headers: {
				"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
				"Content-Type" => "application/x-www-form-urlencoded"
			}).body

			@student_info << {
				user_id: _tmp['objectId'], 
				displayName: _tmp['displayName'], 
				object_type: _tmp['extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType'],
				email: _tmp['userPrincipalName'],
				grade: _tmp['extension_fe2174665583431c953114ff7268b7b3_Education_Grade'],
				photo: get_user_photo_url(_tmp['objectId'])
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

		res = JSON.parse(HTTParty.get("https://graph.windows.net/#{Settings.tenant_name}/administrativeUnits/#{@school_id}/members?api-version=beta", headers: {
			"Authorization" => "#{session[:token_type]} #{session[:gwn_access_token]}",
			"Content-Type" => "application/x-www-form-urlencoded"
		}).body)["value"]

		@students = res.select{ |_obj| _obj["extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType"] == "Student" }
		@teachers = res.select{ |_obj| _obj["extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType"] == "Teacher" }
		@all = res
	end
end
