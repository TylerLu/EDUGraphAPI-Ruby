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

###############3

#   def set_current_user
#     user_obj = UserService.new(get_aad_graph, get_ms_graph)
#     self.current_user.merge!(user_obj.get_current_user)
#     if current_user[:email].present?
#       account = User.find_by_email(current_user[:email])
#       self.current_user.merge!({ 
#         is_local_account_login: true,
#         email: current_user[:email],
#         o365_email: account.o365_email,
#         is_linked: (!account || account.o365_email.blank? || account.email.blank?) ? false : true
#       })
#     else
#       account = User.find_by_o365_email(cookies[:o365_login_email])
#       self.current_user.merge!({
#         is_local_account_login: false,
#         email: account.email,
#         o365_email: cookies[:o365_login_email],
#         is_linked: (!account || account.o365_email.blank? || account.email.blank?) ? false : true
#       })
#     end
#     # class_obj = Service::Education::SchoolClass.new(get_aad_graph, current_user[:school_number])
#     _ts = TokenService.new(cookies[:o365_user_id])
#     class_obj = SchoolsService.new(self.tenant_name, _ts, current_user[:school_number])
#     self.current_user[:myclasses] = class_obj.get_my_classes_by_school_number(current_user).map{|_| _['displayName']}
#   end



#   def current_user=(user_info)
#     session[:current_user] = user_info
#   end

#   private
#   # def get_token_service
#   #   _ts = TokenService.new(cookies[:o365_login_email])
#   # end

#   def get_ms_graph
#     _ts = TokenService.new(cookies[:o365_user_id])
#     self.ms_graph ||= Graph::MSGraph.new(_ts.get_ms_token, self.tenant_name)
#     # self.ms_graph ||= Service::Graph::MSGraph.new(session[:gmc_access_token])
#   end

#   def get_aad_graph
#     self.tenant_name = cookies[:o365_login_email][/(?<=@).*/] if cookies[:o365_login_email]

#     _ts = TokenService.new(cookies[:o365_user_id])
#     self.aad_graph ||= Graph::AADGraph.new(_ts.get_aad_token, self.tenant_name)
#     # self.aad_graph ||= Service::Graph::AADGraph.new(session[:gwn_access_token], self.tenant_name)
#   end

#   def verify_access_token
#     unless cookies[:o365_user_id]
#       redirect_to login_account_index_path 
#       return
#     end
#     _ts = TokenService.new(cookies[:o365_user_id])
#     _expires_on = _ts.get_expires_on
#   	if session[:logout] || (_expires_on && Time.now.to_i > _expires_on.to_i)
#       session[:logout] = false

#       if session[:local_login]
#         redirect_to login_account_index_path
#         return
#       else
#         redirect_to o365login_account_index_path
#         return
#       end
#   	end

#     if !_expires_on && session[:logout].blank?
#       redirect_to login_account_index_path
#       return
#     end
#   end
# end
