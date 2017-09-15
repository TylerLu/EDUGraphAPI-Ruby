# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ApplicationController < ActionController::Base

  # protect_from_forgery with: :exception
  before_action :convert_ssl_header

  include ApplicationHelper
  helper_method :current_user

  def current_user
    local_user = session['_local_user_id'] ? User.find_by_id(session['_local_user_id']) : nil
    UnifiedUser.new(local_user)
  end

  def set_local_user(local_user)
    session['_local_user_id'] = local_user.id
  end

  def clear_local_user()
    session.delete(:_local_user_id)
  end 

  def set_session_expire_after(days)
    session.options[:expire_after] = 60 * 60 * 24 * days
  end

  def clear_session_expire_after
    session.options[:expire_after] = nil 
  end

  def require_login
    if !current_user.is_authenticated?
      redirect_to account_login_path
    end
  end
  def convert_ssl_header
    if request.headers['HTTP_X_ARR_SSL']
      request.headers['HTTP_X_FORWARDED_SCHEME'] = 'https'
    end
  end

end