# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AdminController < ApplicationController
	skip_before_action :verify_authenticity_token
  skip_before_action :verify_access_token, only: :consent

  def index
  	# 判断是否consent
  	@account = Account.find_by_o365_email(cookies[:o365_login_email])
  end

  def consent
    if request.post?
    	consent_url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&client_id=#{Settings.edu_graph_api.app_id}&resource=https://graph.windows.net&redirect_uri=#{get_request_schema}#{Settings.redirect_uri}&state=12345&prompt=admin_consent"
    	redirect_to consent_url
    end
  end

  def unconsent
    
    res = graph_request({
      host: Settings.host.gwn,
      tenant_name: Settings.tenant_name,
      resource_name: 'servicePrincipals',
      access_token: session[:gwn_access_token],
      query: {
        "$filter" => "appId eq '#{Settings.edu_graph_api.app_id}'"
      }
    })['value']

    obj = res.find{ |_| _['appId'] == Settings.edu_graph_api.app_id }

    if obj
      res = graph_request({
        http_method: 'delete',
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        resource_name: "servicePrincipals/#{obj['objectId']}",
        access_token: session[:gwn_access_token],
      })

      Account.where("o365_email is not null and email is not null and o365_email != ?", cookies[:o365_login_email]).each do |_account|
        _account.update({o365_email: nil})
      end
    end

    account = Account.find_by_o365_email(cookies[:o365_login_email])
    account.is_consent = false
    account.save

    redirect_to admin_index_path
  end

  def add_app_role_assignments
    res = graph_request({
      host: Settings.host.gwn,
      tenant_name: Settings.tenant_name,
      resource_name: 'servicePrincipals',
      access_token: session[:gwn_access_token]
    })['value']
    
    obj = res.find{ |_| _['appId'] == Settings.edu_graph_api.app_id }

    if obj
      resourceId = obj['objectId']
      resoucreName = obj['displayName']
      
      users = graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        resource_name: 'users',
        api_version: '1.5',
        access_token: session[:gwn_access_token],
        query: {
          "$expand" => "appRoleAssignments"
        }
      })

      users.each do |user|
        next if user['appRoleAssignments'].find{|_user| _user['resourceId'] == resourceId }

        res = graph_request({
          host: Settings.host.gwn,
          tenant_name: Settings.tenant_name,
          resource_name: "users/#{user['objectId']}/appRoleAssignments",
          api_version: '1.5',
          body: {
            "resourceId" => resourceId,
            "principalId" => user['objectId']
          }.to_json
        })
      end
    end
    
    redirect_to admin_index_path
  end

  def unlink_account
  	account_id = params[:account_id]
  	@account = Account.find(account_id)

  	if request.post?
      @account.unlink_email = @account.o365_email
  		@account.o365_email = nil
  		@account.save
  		redirect_to linked_accounts_admin_index_path
  	end
  end

  def linked_accounts
  	@accounts = Account.where("o365_email is not null and email is not null").select{|obj| obj.o365_email.end_with? Settings.tenant_name }
  end
end
