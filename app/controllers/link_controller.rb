# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class LinkController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if current_user.are_linked?
      @link_info = User.find_by_email(current_user.o365_email)
    elsif current_user.is_o365?      
      @has_local_account = User.exists?(email: current_user.o365_email)
    end
  end

  def create_local_account
  end

  def create_local_account_post
  	local_user = User.find_by_o365_email(cookies[:o365_login_email])
  	if local_user
  	  redirect_to link_index_path, alert: 'already linked' and return 
  	else
  		local_user = User.new
  		local_user.assign_attributes({
  			o365_email: current_user.o365_email,
  			email: current_user.o365_email,
        o365_user_id: current_user.o365_user_id,
  			favorite_color: params["FavoriteColor"],
  			password: Settings.default_password,
        organization: Organization.find_by_tenant_id(current_user.tenant_id)
  		})
  		local_user.save
      session['_local_user_id'] = local_user.id
  		redirect_to schools_path
  	end
  end

  def login_local
    local_user = User.find_by_email(current_user.o365_email)
    if local_user
      local_user.o365_email = current_user.o365_email
      local_user.o365_user_id = current_user.o365_user_id
      local_user.organization = Organization.find_by_tenant_id(current_user.tenant_id)

      byebug


      # TODO Roles  
      local_user.save
      session['_local_user_id'] = local_user.id
      redirect_to schools_path, notice: 'linked'
      return
    end
  end
  
  def link_to_local_account    
    local_user = User.find_by_email(params["Email"])
    if !local_user || local_user.authenticate(params["Password"])
      redirect_to login_local_link_index_path, alert: 'username or password is incorrect' and return
    end
    if local_user.o365_user_id
      redirect_to login_local_link_index_path, alert: 'this account has already been linked by another office account' and return
    end
    
    local_user.username = current_user.o365_email
    local_user.o365_user_id = current_user.o365_user_id
    local_user.o365_email = current_user.o365_email
    local_user.organization = Organization.find_by_tenant_id(current_user.o365_user_id)
    local_user.save
    redirect_to schools_path and return
  end

  def login_O365
    redirect_to sign_in_path(
      :prompt => 'login',
      :callback_path => '/link/azure_oauth2/callback'
    )
  end

  def azure_oauth2_callback
    auth = request.env['omniauth.auth']
    
    byebug
		# cahce tokens
		tokenService = TokenService.new
		tokenService.cache_tokens(auth.info.oid, Constant::Resource::AADGraph, auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)

		token_service = TokenService.new
		token = token_service.get_access_token(auth.info.oid, Constant::Resource::MSGraph)

		ms_graph_service = MSGraphService.new(token)
		tenant = ms_graph_service.get_organization(auth.info.tid)

		org = Organization.find_or_create_by(tenant_id: auth.info.tid)
		org.name = tenant.display_name
		org.save()

		local_user = User.find_by_id(current_user.user_id)
    local_user.assign_attributes({
      o365_user_id: auth.info.oid,
      o365_email: auth.info.email,
      organization: org
    })
    local_user.save();

		cookies[:o365_login_name] = auth.info.email
		cookies[:o365_login_email] =  auth.info.first_name + ' ' + auth.info.last_name

		redirect_to account_index_path
  end


  def login_o365_required
  end


  def relogin_o365
    # redirect_to URI.encode("https://login.microsoftonline.com/common/oauth2/authorize?client_id=#{Settings.edu_graph_api.app_id}&response_type=id_token+code&response_mode=form_post&scope=openid+profile&nonce=luyao&redirect_uri=#{get_request_schema}#{Settings.redirect_uri}&state=12345&login_hint=#{cookies[:o365_login_email]}")
    adal = ADAL::AuthenticationContext.new
    redirect_url = adal.authorization_request_url(Constant::Resource::AADGraph, Settings.edu_graph_api.app_id, "#{get_request_schema}#{Settings.redirect_uri}", {login_hint: "#{cookies[:o365_login_email]}"})
    redirect_to redirect_url.to_s
  end

end
