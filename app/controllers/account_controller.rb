# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AccountController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :verify_access_token
	skip_before_action :get_aad_graph
	skip_before_action :get_ms_graph

	def login
		self.current_user = nil
		session[:logout] = false
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
		account = User.find_by_email(params["Email"])

		unless params["RememberMe"].blank?
			cookies[:user_local_account] = params["Email"]
			cookies[:user_local_remember] = true
		else
			cookies[:user_local_account] = nil
			cookies[:user_local_remember] = nil
		end

		if account && account.authenticate(params["Password"])
			self.current_user = {
				user_identify: '',
				display_name: params["Email"],
				school_number: '',
				email: params["Email"]
			}

			unless account.o365_email
				redirect_to link_index_path
			else 
				_token_obj = account.token
				refresh_token = _token_obj.refresh_token

				adal = ADAL::AuthenticationContext.new
				client_cred = ADAL::ClientCredential.new(Settings.edu_graph_api.app_id, Settings.edu_graph_api.default_key)

				res = adal.acquire_token_with_refresh_token(refresh_token, client_cred, Constant::Resource::AADGraph)
				res2 = adal.acquire_token_with_refresh_token(refresh_token, client_cred, Constant::Resource::MSGraph)

				_access_token = JSON.parse(_token_obj.access_tokens).merge({
					Constant::Resource::AADGraph => {expiresOn: res.expires_on, value: res.access_token},
					Constant::Resource::MSGraph => {expiresOn: res2.expires_on, value: res2.access_token}
				})
		
				if res.access_token
					_token_obj.update_attributes({
						access_tokens: _access_token.to_json
					})

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
		has_link = current_user[:surname].present?
		local_account_login = current_user[:email].present?
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
		self.current_user = nil
		session[:logout] = false
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

	def azure_oauth2_callback
		authorization_code = params["code"]
		id_token = params["id_token"] 

		if params["admin_consent"] == "True"
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
			return 
		end

		adal = ADAL::AuthenticationContext.new
		client_cred = ADAL::ClientCredential.new(Settings.edu_graph_api.app_id, Settings.edu_graph_api.default_key)

		res = adal.acquire_token_with_authorization_code(authorization_code, "#{get_request_schema}#{Settings.redirect_uri}", client_cred, Constant::Resource::AADGraph)

		cookies[:o365_login_name] = res.user_info.name
		cookies[:o365_login_email] = res.user_info.unique_name

		_ts = TokenService.new(cookies[:o365_login_email])
		_ts.set_aad_token(res.access_token, res.expires_on)
		_ts.set_refresh_token(res.refresh_token)
		tmp_res = adal.acquire_token_with_refresh_token(res.refresh_token, client_cred, Constant::Resource::MSGraph)
		_ts.set_ms_token(tmp_res.access_token, tmp_res.expires_on)
		
		if current_user && current_user[:email]
			account = User.find_by_email(current_user[:email])

			if User.find_by_o365_email(cookies[:o365_login_email])
				# o365 account has linked
				redirect_to link_index_path, notice: "Failed to link accounts. The Office 365 account '#{cookies[:o365_login_email]}' is already linked to another local account."
				return
			end

			account.o365_email = cookies[:o365_login_email]
			_token = Token.find_by_o365email(account.o365_email)
			# unless _token
				# _token = Token.new
				# _token.assign_attributes({
				# 	gwn_refresh_token: session[:gwn_refresh_token],
				# 	o365email: cookies[:o365_login_email],
				# 	gmc_refresh_token: session[:gmc_refresh_token]
				# })
				# _token.save
			# end

			account.username = cookies[:o365_login_name]
			account.organization = Organization.find_by_name(cookies[:o365_login_name][/(?<=@).*/])			
			account.token = _token

			account.save
		else
			# o365 account login, check if linked
			account = User.find_by_o365_email(cookies[:o365_login_email])
			self.current_user = {}
			unless account && account.email
				self.current_user = {
					display_name: cookies[:o365_login_name],
					o365_email: cookies[:o365_login_email]
				}
				redirect_to link_index_path and return 
			end
		end

		redirect_to schools_path
	end
end
