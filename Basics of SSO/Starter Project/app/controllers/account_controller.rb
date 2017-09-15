# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

# This sample uses an open source OpenID Connect library that is compatible with the Azure AD.
# Microsoft does not provide fixes or direct support for this library.
# Refer to the library’s repository to file issues or for other support.
# For more information about auth libraries see: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-authentication-libraries
# Library repo: https://github.com/intridea/omniauth-oauth2

class AccountController < ApplicationController
  
  def index
    url = ''
    if !current_user.is_authenticated?
      url = '/account/login'
    else
      url = '/schools'
    end
    redirect_to url
  end

  def login
    render 'login'
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
    
    redirect_to account_index_path
  end

  def register
  end

  def register_post
    user_service = UserService.new
    user = user_service.get_user_by_email(params["Email"])
    if user
      flash[:alert] = "Email #{params['Email']} is already taken"
        render 'register' and return
    end

    user = user_service.register(params["Email"], params["Password"])
    set_local_user(user)
    redirect_to account_index_path
  end


  def logoff
    session.clear
    reset_session()
    clear_session_expire_after()
    redirect_to account_login_path   
  end

end