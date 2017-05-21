# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class LinkController < ApplicationController
  
  before_action :require_login

  def index
    if !current_user.are_linked? && current_user.is_o365?
		  user_service = UserService.new
      @matched_local_user = user_service.get_user_by_email(current_user.o365_email)
    end
  end

  def matched_local
    user_service = UserService.new
    user = user_service.get_user_by_email(current_user.o365_email)
    if user.is_linked?
      redirect_to account_index_path, notice: 'The local account has already been linked to another Office 365 account.' and return
  	end

    link_service = LinkService.new()
    o365_user = current_user.o365_user
    link_service.link(user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)
    set_local_user(user)
    redirect_to account_index_path, notice: 'Your local account has been successfully linked to your Office 365 account.'
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
  	redirect_to account_index_path, notice: 'Your local account has been successfully linked to your Office 365 account.'
  end

  def login_local
  end

  def login_local_post      
    user_service = UserService.new
    user = user_service.authenticate(params["Email"], params["Password"])
    if !user
      flash[:alert] = 'Email or password is incorrect.'
      render 'login_local' and return
    end

    if user.is_linked?
      flash[:alert] ='The local account has already been linked to another Office 365 account.'
      render 'login_local' and return
    end

    link_service = LinkService.new()
    o365_user = current_user.o365_user
    link_service.link(user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)
    set_local_user(user)

    redirect_to account_index_path, notice: 'Your local account has been successfully linked to your Office 365 account.'
  end

  def login_o365
    redirect_to azure_auth_path(
      :prompt => 'login',
      :callback_path => '/link/login_o365_callback'
    )
  end

  def login_o365_callback
    auth = request.env['omniauth.auth']

    # check if the o365 account is linked with other account
    link_service = LinkService.new()
    if link_service.is_linked_to_local_account(auth.info.email)
      flash[:alert] = "Failed to link accounts. The Office 365 account '#{auth.info.email}' is already linked to another local account."
      redirect_to account_index_path and return
    end
    
		# cahce tokens
		token_service.cache_tokens(auth.info.oid, Constants::Resources::AADGraph, auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)

    # get tenant
		token = token_service.get_access_token(auth.info.oid, Constants::Resources::MSGraph)
		ms_graph_service = MSGraphService.new(token)
		tenant = ms_graph_service.get_organization(auth.info.tid)

    # o365 user
		roles = ms_graph_service.get_my_roles()
		o365_user = O365User.new(auth.info.oid, auth.info.email, auth.info.first_name, auth.info.last_name,  auth.info.tid, tenant.display_name, roles)
		set_o365_user(o365_user)
		cookies[:o365_login_name] = auth.info.first_name + ' ' + auth.info.last_name
		cookies[:o365_login_email] =  auth.info.email

    # create or update organization
		organization_service = OrganizationService.new
    organization_service.create_or_update_organization(auth.info.tid, tenant.display_name)

    # lin accounts
    link_service = LinkService.new()
    link_service.link(current_user.local_user, o365_user.id, o365_user.email, o365_user.tenant_id, o365_user.roles)
    
    self.azure_oauth2_logout_required = true
		redirect_to account_index_path, notice: 'Your local account has been successfully linked to your Office 365 account.'
  end

  def login_o365_required
  end

  def relogin_o365
    redirect_to azure_auth_path(
      :prompt => 'login',
      :login_hint => current_user.o365_email
    )
  end

end