# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
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

    def set_o365_user(o365_user)
        session['_o365_user'] = o365_user
    end

    def token_service
        @token_service ||= TokenService.new
    end

end