# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_access_token

  include ApplicationHelper

  private
  def verify_access_token
  	#验证token是否过期，过期则重新登录
  	if session[:logout] || (session[:expires_on] && Time.now.to_i > session[:expires_on].to_i)
      session[:logout] = false
  		if cookies[:o365_login_email].present?
  			redirect_to '/account/o365login'
  		else
  			redirect_to '/account/login'
  		end
  	end
  end
end
