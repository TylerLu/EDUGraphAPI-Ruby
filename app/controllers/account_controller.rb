# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AccountController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
		url = ''
		if !current_user.is_authenticated
			url = '/account/login'
		elsif !current_user.are_linked
			url = '/link'
		elsif current_user.is_admin #&& not consented
			url = '/admin'
		else
			url = '/schools'
		end
		redirect_to url #('#{get_request_schema}/#{url}')
	end

	def login
		o365_login = cookies[:o365_login_name].present? && cookies[:o365_login_email].present?
		view = o365_login ? 'o365login' : 'login'
		render view
	end

	def reset
		cookies.delete :o365_login_name
		cookies.delete :o365_login_email
		redirect_to '/account/login'
	end

	def login_o365
	 	redirect_to sign_in_path
	end

	def login_local
		session.clear
		account = User.find_by_email(params["Email"])
		if account && account.authenticate(params["Password"])
			session['_local_user_id'] = account.id
			if account.o365_email
				o365_user = O365User.new
				o365_user.id = account.o365_user_id
				o365_user.email = account.o365_email
				# TODO
				session['_o365_user'] = o365_user
			end	
			redirect_to account_index_path
		else
			redirect_to login_account_index_path, alert: 'Invalid login attempt.'
		end
	end

	def azure_oauth2_callback
		auth = request.env['omniauth.auth']
		# cahce tokens
		tokenService = TokenService.new
		tokenService.cache_tokens(auth.info.oid, Constant::Resource::AADGraph, auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)


		# if params["admin_consent"] == "True"
		# 	redirect_to login_for_admin_consent_account_index_path
		# 	return
		# end

		token_service = TokenService.new
		token = token_service.get_access_token(auth.info.oid, Constant::Resource::MSGraph)

		ms_graph_service = MSGraphService.new(token)
		tenant = ms_graph_service.get_organization(auth.info.tid)

		org = Organization.find_or_create_by(tenant_id: auth.info.tid)
		org.name = tenant.display_name
		org.save()

		o365_user = O365User.new
		o365_user.id = auth.info.oid
		o365_user.email = auth.info.email
		o365_user.first_name = auth.info.first_name
		o365_user.last_name = auth.info.last_name
		o365_user.tenant_id = auth.info.tid
		o365_user.tenant_name = tenant.display_name
		o365_user.roles = ms_graph_service.get_my_roles()
		# TODO
		session['_o365_user'] = o365_user

		cookies[:o365_login_name] = auth.info.email
		cookies[:o365_login_email] =  auth.info.first_name + ' ' + auth.info.last_name
		#cookies[:o365_user_id] = auth.info.oid

		# TODO session local user id

		redirect_to account_index_path
	end


	def register
	end

	def register_account
		account = User.find_by_email(params["Email"])

		if account
			redirect_to register_account_index_path, alert: "email #{params['Email']} is already taken"
		else
			account = User.new
			account.assign_attributes({
				email: params["Email"],
				password: params["Password"],
				favorite_color: params["FavoriteColor"],
			})
			if account.save
				session.clear
				self.current_user = { display_name: params["Email"], email: params["Email"], is_local_account_login: true }
				redirect_to "/link?email=#{params["Email"]}"
			end
		end
	end

	def login_for_admin_consent
		account = User.find_by_o365_email(cookies[:o365_login_email])
		if _organization = account.organization
			account.organization.update_attributes({
				is_admin_consented: true
			})
			account.save
		else
			_organization = Organization.new
			_organization.update_attributes({
				name: cookies[:o365_login_email][/(?<=@).*/],
				is_admin_consented: true
			})
			_organization.save
			account.organization = _organization
			account.save
		end
		
		redirect_to admin_index_path, notice: 'admin consent success'
	end

	def local_account_login
		account = User.find_by_email(current_user[:email])

		if User.find_by_o365_email(cookies[:o365_login_email])
			redirect_to link_index_path, notice: "Failed to link accounts. The Office 365 account '#{cookies[:o365_login_email]}' is already linked to another local account."
			return
		end

		account.o365_email = cookies[:o365_login_email]
		account.o365_user_id = cookies[:o365_user_id]
		_token = Token.find_by_o365_userId(cookies[:o365_user_id])

		account.username = cookies[:o365_login_name]
		account.organization = Organization.find_by_name(cookies[:o365_login_name][/(?<=@).*/])			
		account.token = _token

		account.save
		redirect_to schools_path
	end

	def photo
		token_service = TokenService.new
		access_token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::MSGraph)
		ms_graph_service = MSGraphService.new(access_token)
		

		response = ms_graph_service.get_user_photo(params[:id])
		if response.code == 200
			send_data response.body, type: response.content_type, disposition: 'inline'
		else
			send_file "#{Rails.root}/public/Images/header-default.jpg", disposition: 'inline'
		end
	end
		 


	def logoff
		# has_link = current_user[:surname].present?
		# local_account_login = current_user[:email].present?

		
		# session[:logout] = true
		# session[:local_login] = local_account_login
		# session[:has_link] = has_link
		cookies[:user_local_remember] = nil
		session.clear
		
		logoff_url = URI.encode "https://login.microsoftonline.com/common/oauth2/logout?post_logout_redirect_uri=#{get_request_schema}/account/login"

		redirect_to logoff_url
	end


end
