# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class LinkController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :verify_access_token
  skip_before_action :get_aad_graph
  skip_before_action :get_ms_graph

  def index
    if current_user[:is_local_account_login]
      @link_info = User.find_by_email(current_user[:email])
    else
      @link_info = User.find_by_o365_email(cookies[:o365_login_email])
      if @link_info && !@link_info.organization
        redirect_to login_o365_required_link_index_path
        return 
      end
    end

    @has_local_account = true if User.find_by_email(cookies[:o365_login_email]).try(:email) == cookies[:o365_login_email]
  end

  def loginO365
    # authorize_url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=id_token+code&client_id=#{Settings.edu_graph_api.app_id}&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{get_request_schema}#{Settings.redirect_uri}&state=12345&prompt=login"
    adal = ADAL::AuthenticationContext.new
    redirect_url = adal.authorization_request_url(Constant::Resource::AADGraph, Settings.edu_graph_api.app_id, "#{get_request_schema}#{Settings.redirect_uri}", {prompt: 'login'})
    redirect_to redirect_url.to_s

    # redirect_to authorize_url
  end

  def processcode
  end

  def login_local
    if account = User.find_by_email(cookies[:o365_login_email])
      account.o365_email = cookies[:o365_login_email]
      if _org = Organization.find_by_name(cookies[:o365_login_email][/(?<=@).*/])
        account.organization = _org
      end
      account.save
      redirect_to schools_path, notice: 'linked'
      return
    end
  end

  def login_o365_required
  end

  def relogin_o365
    # redirect_to URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{get_request_schema}#{Settings.redirect_uri}&state=12345&login_hint=#{cookies[:o365_login_email]}")
    adal = ADAL::AuthenticationContext.new
    redirect_url = adal.authorization_request_url(Constant::Resource::AADGraph, Settings.edu_graph_api.app_id, "#{get_request_schema}#{Settings.redirect_uri}", {login_hint: "#{cookies[:o365_login_email]}"})
    redirect_to redirect_url.to_s
  end

  def link_to_local_account
    account = User.find_by_email(params["Email"])
    if account && account.authenticate(params["Password"])
      if !account.organization
        _token = Token.find_by_o365_userId(account.o365_user_id)
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

        _org = Organization.find_by_name(cookies[:o365_login_email][/(?<=@).*/])
        account.organization = _org

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

  def create_local_account_post
  	account = User.find_by_o365_email(cookies[:o365_login_email])
  	if account
  	  redirect_to link_index_path, alert: 'already linked'
  	  return 
  	else
  		account = User.new
  		account.assign_attributes({
  			o365_email: cookies[:o365_login_email],
  			email: cookies[:o365_login_email],
        o365_user_id: cookies[:o365_user_id],
  			favorite_color: params["FavoriteColor"],
  			password: Settings.default_password
  		})

  		_token = Token.find_by_o365_userId(cookies[:o365_user_id])
			account.token = _token

      _organization = Organization.find_by_name(cookies[:o365_login_email][/(?<=@).*/])
      unless _organization
        _organization = Organization.new
        _organization.assign_attributes({
          name: cookie[:o365_login_email][/(?<=@).*/],
        })
        _organization.save
      end
      account.organization = _organization
  		account.save

  		redirect_to schools_path
  	end
  end
end
