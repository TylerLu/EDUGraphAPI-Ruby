# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AccountController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :verify_access_token

	def login
		# cookies[:o365_login_email] = nil
		session[:current_user] = nil
	end

	def jump
		if cookies[:user_local_remember].present?
			redirect_to("#{get_request_schema}/schools")
			return
		end
		redirect_to("#{get_request_schema}/account/login")
	end

	def login_account
		session.clear
		account = Account.find_by_email(params["Email"])

		unless params["RememberMe"].blank?
			cookies[:user_local_account] = params["Email"]
			cookies[:user_local_remember] = true
		else
			cookies[:user_local_account] = nil
			cookies[:user_local_remember] = nil
		end

		if account && account.password == params["Password"]
			session[:current_user] = {
				user_identify: '',
				display_name: params["Email"],
				school_number: '',
				email: params["Email"]
			}

			unless account.o365_email
				redirect_to link_index_path
			else 
				refresh_token = account.token.gwn_refresh_token

				adal = ADAL::AuthenticationContext.new
				client_cred = ADAL::ClientCredential.new(Settings.edu_graph_api.app_id, Settings.edu_graph_api.default_key)

				res = adal.acquire_token_with_refresh_token(refresh_token, client_cred, Constant::Resource::AADGraph)
				res2 = adal.acquire_token_with_refresh_token(refresh_token, client_cred, Constant::Resource::MSGraph)
		
				if res.access_token
					session[:gwn_access_token] = res.access_token
					session[:gmc_access_token] = res2.access_token
					session[:token_type] = res.token_type
					session[:expires_on] = res.expires_on

					cookies[:o365_login_name] = account.username
					cookies[:o365_login_email] = account.o365_email
					redirect_to schools_path
				else
					redirect_to sign_in_path
				end
			end

			cookies[:local_account] = params["Email"]

		else
			redirect_to login_account_index_path, alert: 'Invalid login attempt.'
		end
	end

	def logoff
		has_link = session[:current_user][:surname].present?
		local_account_login = session[:current_user][:email].present?
		session.clear
		session[:logout] = true
		session[:local_login] = local_account_login
		session[:has_link] = has_link
		cookies[:user_local_remember] = nil
		logoff_url = URI.encode "https://login.microsoftonline.com/common/oauth2/logout?post_logout_redirect_uri=#{get_request_schema}/account/login"

		redirect_to logoff_url
	end

	def externalLogin
		redirect_to sign_in_path
	end

	def register
	end

	def o365login
		session[:current_user] = nil
	end

	def register_account
		account = Account.find_by_email(params["Email"])

		if account
			redirect_to register_account_index_path, alert: "email #{params['Email']} is already taken"
		else
			account = Account.new
			account.assign_attributes({
				email: params["Email"],
				password: params["Password"],
				favorite_color: params["FavoriteColor"],
			})
			if account.save
				session.clear
				session[:current_user] = { display_name: params["Email"], email: params["Email"] }
				redirect_to "/link?email=#{params["Email"]}"
			end
		end
	end

	def callback
		authorization_code = params["code"]
		id_token = params["id_token"] 

		if params["admin_consent"] == "True"
			account = Account.find_by_o365_email(cookies[:o365_login_email])
			account.is_consent = true
			account.save
			redirect_to admin_index_path, notice: 'admin consent success'
			return 
		end

		adal = ADAL::AuthenticationContext.new
		client_cred = ADAL::ClientCredential.new(Settings.edu_graph_api.app_id, Settings.edu_graph_api.default_key)

		res = adal.acquire_token_with_authorization_code(authorization_code, "#{get_request_schema}#{Settings.redirect_uri}", client_cred, Constant::Resource::AADGraph)

		session[:token_type] = res.token_type
		session[:expires_on] = res.expires_on

		session[:gwn_refresh_token] = res.refresh_token
		session[:gwn_access_token] = res.access_token

		tmp_res = adal.acquire_token_with_refresh_token(res.refresh_token, client_cred, Constant::Resource::MSGraph)
		session[:gmc_refresh_token] = tmp_res.refresh_token
		session[:gmc_access_token] = tmp_res.access_token

	 	cookies[:o365_login_name] = res.user_info.name
		cookies[:o365_login_email] = res.user_info.unique_name

		# use local account login and link with o365 account
		if session[:current_user] && session[:current_user][:email]
			account = Account.find_by_email(session[:current_user][:email])

			if Account.find_by_o365_email(cookies[:o365_login_email])
				# o365 account has linked
				redirect_to link_index_path, notice: "Failed to link accounts. The Office 365 account '#{cookies[:o365_login_email]}' is already linked to another local account."
				return
			end

			account.o365_email = cookies[:o365_login_email]
			_token = Token.find_by_o365email(account.o365_email)
			unless _token
				_token = Token.new
				_token.assign_attributes({
					gwn_refresh_token: session[:gwn_refresh_token],
					o365email: cookies[:o365_login_email],
					gmc_refresh_token: session[:gmc_refresh_token]
				})
				_token.save
			end

			account.username = cookies[:o365_login_name]
			account.token = _token

			account.save
		else
			# o365 account login, check if linked
			account = Account.find_by_o365_email(cookies[:o365_login_email])
			session[:current_user] = {}
			unless account && account.email
				session[:current_user] = {
					display_name: cookies[:o365_login_name],
					o365_email: cookies[:o365_login_email]
				}
				redirect_to link_index_path and return 
			end
		end

		redirect_to schools_path
	end
end
