# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AccountController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :verify_access_token

	def login
		cookies[:o365_login_email] = nil
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
			#判断是否link，没有则跳转到link页
			session[:current_user] = {
				user_identify: '',
				display_name: params["Email"],
				school_number: '',
				email: params["Email"]
			}

			unless account.o365_email
				redirect_to link_index_path
			else 
				# 通过关联的office 账户登录并获取数据，使用 refresh_token 刷新token 登录，
				# 如果refresh_token 过期了 ， 则提示用户重新登录
				refresh_token = account.token.gwn_refresh_token
				res = JSON.parse HTTParty.post('https://login.microsoftonline.com/common/oauth2/token', body: {
					grant_type: 'refresh_token',
					client_id: Settings.edu_graph_api.app_id,
					refresh_token: refresh_token,
					client_secret: Settings.edu_graph_api.default_key,
					resource: 'https://graph.windows.net'
				}).body

				res2 = JSON.parse HTTParty.post('https://login.microsoftonline.com/common/oauth2/token', body: {
					grant_type: 'refresh_token',
					client_id: Settings.edu_graph_api.app_id,
					refresh_token: refresh_token,
					client_secret: Settings.edu_graph_api.default_key,
					resource: 'https://graph.microsoft.com'
				}).body

				if res["access_token"]
					session[:gwn_access_token] = res["access_token"]
					session[:gmc_access_token] = res2["access_token"]
					session[:token_type] = res["token_type"]
					session[:expires_on] = res["expires_on"]

					cookies[:o365_login_name] = account.username
					cookies[:o365_login_email] = account.o365_email
					redirect_to schools_path
				else
					redirect_to URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{request.protocol}#{request.host}:#{request.port}#{Settings.redirect_uri}&state=12345&login_hint=#{account.o365_email}")
				end
			end

			cookies[:local_account] = params["Email"]

		else
			redirect_to login_account_index_path, alert: 'Invalid login attempt.'
		end
	end

	def logoff
		session.clear
		session[:logout] = true
		logoff_url = URI.encode "https://login.microsoftonline.com/common/oauth2/logout?post_logout_redirect_uri=#{request.protocol}#{request.host}:#{request.port}/account/login"

		redirect_to logoff_url
	end

	def externalLogin
		if cookies[:o365_login_name].present?
		# if cookies[:o365_login_email].present?
			authorize_url = URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{request.protocol}#{request.host}:#{request.port}#{Settings.redirect_uri}&state=12345&login_hint=#{cookies[:o365_login_email]}")
		else
			authorize_url = URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{request.protocol}#{request.host}:#{request.port}#{Settings.redirect_uri}&state=12345")
		end
		# authorize_url = "https://login.microsoftonline.com/common/oauth2/authorize?client_id=4e3fa16f-9909-4bf6-9a66-5560e97e7082&response_mode=form_post&response_type=code+id_token&scope=openid+profile&state=OpenIdConnect.AuthenticationProperties%3dFGIkOZJ1POGoP0oT-TN3C1Blh3vzoO4gaudl1Q5Kd6H9AN87Kudcm7JRKqmdkbXCBWNPBnzBa-fwge4lAKyU7lBpK0M8Ff8dpzYf1e3h0eQ5ZHtxCoZn5cUOpWWNik7d14x-Lqh0uIdNRV9ImTZPZA&nonce=636243821732871340.MzA5ZjM3ZWUtMWE2YS00OTE0LThlN2ItYTUzZGZhYzVhMzMzMzgzNTExYjEtOGFlZi00MmI2LWExMTUtYzlmZGI0NTI3MTM2&redirect_uri=https%3a%2f%2fedugraphapidev.azurewebsites.net%2f&post_logout_redirect_uri=https%3a%2f%2fedugraphapidev.azurewebsites.net"
	
		redirect_to authorize_url
	end

	def register

	end

	def o365login

	end

	def register_account
		account = Account.find_by_email(params["Email"])

		if account
			redirect_to register_account_index_path, alert: "email #{params['Email']} is already token"
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
		# 获取windows返回的code和id_token
		authorization_code = params["code"]
		id_token = params["id_token"] 

		if params["admin_consent"] == "True"
			account = Account.find_by_o365_email(cookies[:o365_login_email])
			account.is_consent = true
			account.save
			redirect_to admin_index_path, notice: 'admin consent success'
			return 
		end

		# 利用authorization_code继续请求access_token
		# token_url = URI.encode("https://login.microsoftonline.com/common/oauth2/token?grant_type=authorization_code&client_id=#{Settings.edu_graph_api.app_id}&code=#{authorization_code}&redirect_uri=#{Settings.redirect_uri_token}")
		res = JSON.parse HTTParty.post('https://login.microsoftonline.com/common/oauth2/token', body: {
			grant_type: 'authorization_code',
			client_id: Settings.edu_graph_api.app_id,
			code: authorization_code,
			redirect_uri: "#{request.protocol}#{request.host}:#{request.port}#{Settings.redirect_uri}",
			client_secret: Settings.edu_graph_api.default_key,
			resource: 'https://graph.windows.net'
		}).body

		# p res

		session[:token_type] = res["token_type"]
		session[:expires_on] = res["expires_on"]
		session[:gwn_refresh_token] = res["refresh_token"]
		session[:gwn_access_token] = res["access_token"]

		res = JSON.parse HTTParty.post('https://login.microsoftonline.com/common/oauth2/token', body: {
			grant_type: 'refresh_token',
			client_id: Settings.edu_graph_api.app_id,
			refresh_token: res["refresh_token"],
			client_secret: Settings.edu_graph_api.default_key,
			resource: 'https://graph.microsoft.com'
		}).body

		# session[:gmc_expires_in] = res["expires_in"]
		session[:gmc_refresh_token] = res["refresh_token"]
		session[:gmc_access_token] = res["access_token"]


		if id_token
			id_token = OpenIDConnect::ResponseObject::IdToken.decode(
	      id_token, jwks
	    )

	    cookies[:o365_login_name] = id_token.raw_attributes["name"]
			cookies[:o365_login_email] = id_token.raw_attributes["unique_name"]
	  end

		#用的本地账号登录，关联o365账号
		if session[:current_user] && session[:current_user][:email]
			account = Account.find_by_email(session[:current_user][:email])
			account.o365_email = id_token.raw_attributes["unique_name"]

			_token = Token.find_by_o365email(account.o365_email)
			unless _token
				_token = Token.new
				_token.assign_attributes({
					gwn_refresh_token: session[:gwn_refresh_token],
					o365email: id_token.raw_attributes["unique_name"],
					gmc_refresh_token: session[:gmc_refresh_token]
				})
				_token.save
			end

			account.username = cookies[:o365_login_name]
			account.token = _token

			account.save
		else
			# o365账户登录的话，判断是否关联本地账号，没有则关联
			account = Account.find_by_o365_email(id_token.raw_attributes["unique_name"])
			session[:current_user] = {}
			unless account && account.email
				session[:current_user] = {
					display_name: cookies[:o365_login_name],
					o365_email: id_token.raw_attributes["unique_name"]
				}
				redirect_to link_index_path and return 
			end
		end

		redirect_to '/schools'
	end

	# def callback_token
	# 	p params
	# end

	private
	def jwks
		@jwks ||= JSON::JWK::Set.new(JSON.parse(
      OpenIDConnect.http_client.get(Settings.jwks_uri).body
    ))
	end
end
