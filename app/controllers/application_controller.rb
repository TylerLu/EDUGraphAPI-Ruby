# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_access_token
  before_action :get_ms_graph
  before_action :get_aad_graph

  include ApplicationHelper

  attr_accessor :current_user
  attr_accessor :aad_graph
  attr_accessor :ms_graph
  attr_accessor :tenant_name

  def set_current_user
    user_obj = Service::User.new(get_aad_graph, get_ms_graph)
    self.current_user = user_obj.get_current_user
    if session[:current_user][:email].present?
      account = Account.find_by_email(session[:current_user][:email])
      self.current_user.merge!({ 
        is_local_account_login: true,
        email: session[:current_user][:email],
        o365_email: account.o365_email,
        is_linked: (!account || account.o365_email.blank? || account.email.blank?) ? false : true
      })
    else
      account = Account.find_by_o365_email(cookies[:o365_login_email])
      self.current_user.merge!({
        is_local_account_login: false,
        email: account.email,
        o365_email: cookies[:o365_login_email],
        is_linked: (!account || account.o365_email.blank? || account.email.blank?) ? false : true
      })
    end
    class_obj = Service::Education::SchoolClass.new(get_aad_graph, current_user[:school_number])
    current_user[:myclasses] = class_obj.get_my_classes_by_school_number(current_user).map{|_| _['displayName']}
    session[:current_user] = self.current_user
  end

  private
  def get_ms_graph
    self.ms_graph ||= Service::Graph::MSGraph.new(session[:gmc_access_token])
  end

  def get_aad_graph
    self.tenant_name = cookies[:o365_login_email][/(?<=@).*/]
    self.aad_graph ||= Service::Graph::AADGraph.new(session[:gwn_access_token], self.tenant_name)
  end

  def verify_access_token
  	if session[:logout] || (session[:expires_on] && Time.now.to_i > session[:expires_on].to_i)
      session[:logout] = false

      if session[:local_login]
        redirect_to '/account/login'
        return
      else
        redirect_to '/account/o365login'
        return
      end
  	end

    if !session[:expires_on] && session[:logout].blank?
      redirect_to '/account/login'
      return
    end
  end
end
