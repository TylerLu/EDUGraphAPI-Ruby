# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AccountController < ApplicationController
  
  def index
    url = ''
    if !current_user.is_authenticated?
      url = '/account/login'
    elsif !current_user.are_linked?
      url = '/link'
    elsif current_user.is_admin?
      url = '/admin'
    else
      url = '/schools'
    end
    redirect_to url
  end

  def login
    o365_login = cookies[:o365_login_name].present? && cookies[:o365_login_email].present?
    view = o365_login ? 'o365login' : 'login'
    render view
  end

  def reset
    cookies.delete :o365_login_name
    cookies.delete :o365_login_email
    redirect_to account_login_path
  end

  def login_o365
     redirect_to azure_auth_path
  end

  def azure_oauth2_callback
    auth = request.env['omniauth.auth']

    # cahce tokens
    token_service.cache_tokens(auth.info.oid, Constants::Resources::AADGraph, 
      auth.credentials.refresh_token, auth.credentials.token, auth.credentials.expires_at)

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

    # linked local user
    user_service = UserService.new
    user = user_service.get_user_by_o365_email(auth.info.email)    
    set_local_user(user) if user

    clear_session_expire_after()
    azure_oauth2_logout_required = true
    redirect_to account_index_path
  end

  def login_local
    user_service = UserService.new
    user = user_service.authenticate(params["Email"], params["Password"])
    if !user
      redirect_to account_login_path, alert: 'Invalid login attempt.' and return
    end

    if params[:RememberMe]
      set_session_expire_after(30)
    else
      clear_session_expire_after()
    end

    set_local_user(user)

    if user.is_linked?
      o365_user = O365User.new(user.o365_user_id, user.o365_email, user.first_name, user.last_name, 
        user.organization.tenant_id, user.organization.name, user.roles.map { |r| r.name })
      set_o365_user(o365_user)
    end  
    redirect_to account_index_path
  end

  def register
  end

  def register_post
    user_service = UserService.new
    user = user_service.get_user_by_o365_email(params["Email"])
    if user
      flash[:alert] = "Email #{params['Email']} is already taken"
        render 'register' and return
    end

    user = user_service.register(params["Email"], params["Password"], params["FavoriteColor"])
    set_local_user(user)
    redirect_to account_index_path
  end

  def photo
    access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    ms_graph_service = MSGraphService.new(access_token)

    response = ms_graph_service.get_user_photo(params[:id])
    if response.code == 200
      send_data response.body, type: response.content_type, disposition: 'inline'
    else
      send_file "#{Rails.root}/public/Images/header-default.jpg", disposition: 'inline'
    end
  end

  def logoff
    session.clear
    reset_session()
    clear_session_expire_after()

    if azure_oauth2_logout_required? 
      post_logout_redirect_uri = URI.escape("#{full_host}/account/login", Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      logoff_url = "#{Constants::AADInstance}common/oauth2/logout?post_logout_redirect_uri=#{post_logout_redirect_uri}"
      redirect_to logoff_url
    else
      redirect_to account_login_path 
    end   
  end

end