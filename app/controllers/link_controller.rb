# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class LinkController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # 判断当前用户是否已经link, 如果link了，则展示账号信息
    # p Account.find_by_email(session[:current_user][:email])
    @link_info = Account.find_by_email(session[:current_user][:email]) || Account.find_by_o365_email(cookies[:o365_login_email])

    @has_local_account = true if Account.find_by_email(cookies[:o365_login_email]).try(:email) == cookies[:o365_login_email]

    if !@link_info && (account = Account.find_by_unlink_email(cookies[:o365_login_email]))
      account.unlink_email = ''
      account.save
      redirect_to login_o365_required_link_index_path
      return 
    end
  end

  def loginO365
    authorize_url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=id_token+code&client_id=#{Settings.edu_graph_api.app_id}&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{request.headers['HTTP_X_ARR_SSL'].blank? ? request.protocol : 'https://' }#{request.host}:#{request.port}#{Settings.redirect_uri}&state=12345&prompt=login"

    redirect_to authorize_url
  end

  def processcode
  end

  def login_local
    if account = Account.find_by_email(cookies[:o365_login_email])
      account.o365_email = cookies[:o365_login_email]
      account.save
      redirect_to schools_path, notice: 'linked'
      return
    end
  end

  def login_o365_required
  end

  def relogin_o365
    redirect_to URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{request.headers['HTTP_X_ARR_SSL'].blank? ? request.protocol : 'https://'}#{request.host}:#{request.port}#{Settings.redirect_uri}&state=12345&login_hint=#{cookies[:o365_login_email]}")
  end

  def link_to_local_account
    account = Account.find_by_email(params["Email"])
    if account && account.password == params["Password"]
      if !account.o365_email
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
				account.token = _token
				account.username = cookies[:o365_login_name]

        account.save
        redirect_to schools_path and return
      else
      	redirect_to login_local_link_index_path, alert: 'this account has already been linked by another office account'
      end
    else
      redirect_to login_local_link_index_path, alert: 'username or password is incorrect'
    end
  end

  def create_local_account
  end

  def create
  	account = Account.find_by_o365_email(cookies[:o365_login_email])
  	if account
  	  redirect_to link_index_path, alert: 'already linked'
  	  return 
  	else
  		account = Account.new
  		account.assign_attributes({
  			o365_email: cookies[:o365_login_email],
  			email: cookies[:o365_login_email],
  			favorite_color: params["FavoriteColor"],
  			password: Settings.default_password
  		})

  		_token = Token.find_by_o365email(cookies[:o365_login_email])
			unless _token
				_token = Token.new
				_token.assign_attributes({
					gwn_refresh_token: session[:gwn_refresh_token],
					o365email: cookies[:o365_login_email],
					gmc_refresh_token: session[:gmc_refresh_token]
				})
				_token.save
			end
			account.token = _token

  		account.save
  		redirect_to schools_path
  	end
  end
end
