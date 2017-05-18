# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    around_action :handle_refresh_token_error
    before_action :init_demo_helper

    include ApplicationHelper
    helper_method :current_user

    def local_user
        return unless session[:user_id]
        @current_user ||= User.find(session[:user_id])
    end

    # def o365_user
    #     session[:o365_user]
    # end 

    # def o365_user=(o365_user)
    #     session[:o365_user] = o365_user
    # end 

    def current_user
        #session[:current_user]
        local_user = session['_local_user_id'] ? User.find_by_id(session['_local_user_id']) : nil
        o365_user = session['_o365_user']
        UnifiedUser.new(local_user, o365_user)
    end

    def set_local_user(local_user)
        session['_local_user_id'] = local_user.id
    end

    def clear_local_user()
        session.delete(:_local_user_id)
    end 

    def set_o365_user(o365_user)
        session['_o365_user'] = o365_user
    end

    def token_service
        @token_service ||= TokenService.new
    end

    def handle_refresh_token_error
      begin
        yield
      rescue Exceptions::RefreshTokenError => exception
        redirect_to link_login_o365_required_path
      end
    end

    def init_demo_helper
        if request.get?
          @demo_helper_links = DemoHelperService.get_links(params[:controller], params[:action])
        end
    end
end