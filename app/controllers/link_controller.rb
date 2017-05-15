# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class LinkController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if !current_user.are_linked? && current_user.is_o365?
		  user_service = UserService.new
      @local_user = user_service.get_user_by_email(current_user.o365_email)
    end
  end

  def matched_local
    user_service = UserService.new
    user = user_service.get_user_by_email(current_user.o365_email)
    if user.o365_user_id || user.o365_email
      redirect_to link_index_path, alert: 'The local account has already been linked to another Office 365 account.' and return 
  	end

    link_service = LinkService.new()
    o365_user = current_user.o365_user
    link_service.link(user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)
    set_local_user(user)
  end

  def create_local
  end

  def create_local_post
    o365_user = current_user.o365_user
    user_service = UserService.new
    user = user_service.create(o365_user.email, o365_user.first_name, o365_user.last_name, params["FavoriteColor"])

    link_service = LinkService.new()
    link_service.link(user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)

    set_local_user(user)
  	redirect_to schools_path
  end

  def local_login
  end

  def local_login_post       
    user_service = UserService.new 
    user = user_service.authenticate(params["Email"], params["Password"])
    if !user
      redirect_to login_local_link_index_path, alert: 'username or password is incorrect' and return
    end

    if user.o365_user_id || user.o365_email
      redirect_to login_local_link_index_path, alert: 'The local account has already been linked to another Office 365 account.' and return
    end

    link_service = LinkService.new()
    o365_user = current_user.o365_user
    link_service.link(user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)

    redirect_to schools_path and return
  end

  def login_O365
    redirect_to azure_auth_path(
      :prompt => 'login',
      :callback_path => '/link/azure_oauth2/callback'
    )
  end

  def azure_oauth2_callback
    auth = request.env['omniauth.auth']
    
		# cahce tokens
		token_service.cache_tokens(auth.info.oid, Constant::Resource::AADGraph, auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)

    # get tenant
		token = token_service.get_access_token(auth.info.oid, Constant::Resource::MSGraph)
		ms_graph_service = MSGraphService.new(token)
		tenant = ms_graph_service.get_organization(auth.info.tid)

    # o365 user
		roles = ms_graph_service.get_my_roles()
		o365_user = O365User.new(auth.info.oid, auth.info.email, auth.info.first_name, auth.info.last_name,  auth.info.tid, tenant.display_name, roles)
		set_o365_user(o365_user)
		cookies[:o365_login_name] = auth.info.first_name + ' ' + auth.info.last_name
		cookies[:o365_login_email] =  auth.info.email

    # create organization and link local user
    user_service = UserService.new
    user_service.create_or_update_organization(auth.info.tid, tenant.display_name)
    link_service.link(current_user.local_user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)
    
		redirect_to account_index_path
  end


  def login_o365_required
  end

  def relogin_o365
    redirect_to azure_auth_path(
      :logint_hint => current_user.o365_email
      :prompt => 'login',
      :callback_path => '/account/azure_oauth2/callback'
    )
  end

end