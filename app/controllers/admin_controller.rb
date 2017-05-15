# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AdminController < ApplicationController
	skip_before_action :verify_authenticity_token
  skip_before_action :verify_access_token, only: :consent

  def index
  	# 判断是否consent
  	@local_user = User.find_by_o365_email(cookies[:o365_login_email])
  end

  def consent
    redirect_to azure_auth_path(
      :prompt => 'admin_consent',
      :callback_path => '/admin/process_code'
    )
    # if request.post?
    # 	# consent_url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&client_id=#{Settings.edu_graph_api.app_id}&resource=https://graph.windows.net&redirect_uri=#{get_request_schema}#{Settings.redirect_uri}&state=12345&prompt=admin_consent"
    #   adal = ADAL::AuthenticationContext.new
    #   consent_url = adal.authorization_request_url(Constant::Resource::AADGraph, Settings.edu_graph_api.app_id, "#{get_request_schema}#{Settings.redirect_uri}", {prompt: 'admin_consent'})
    # 	redirect_to consent_url.to_s
    # end
  end

  def unconsent
    
    admin_obj = AdminService.new(aad_graph)
    res = admin_obj.get_service_principals(Settings.edu_graph_api.app_id)
    obj = res.first

    if obj
      res = admin_obj.delete_service_principals(obj['objectId'])

      local_user = User.find_by_o365_email(cookies[:o365_login_email])
      local_user.organization.update_attributes({
        is_admin_consented: false
      })
      local_user.save

      # User.where("o365_email is not null and email is not null and o365_email != ?", cookies[:o365_login_email]).each do |_account|
      local_user.organization.users.each do |_account|
        _account.update_attributes({
          o365_email: nil,
          o365_user_id: nil,
          organization_id: nil,
        })
      end
    end

    redirect_to admin_index_path
  end

  def add_app_role_assignments
    admin_obj = AdminService.new(aad_graph)
    res = admin_obj.get_service_principals(Settings.edu_graph_api.app_id)
    obj = res.first

    if obj
      resourceId = obj['objectId']
      resoucreName = obj['displayName']

      users = admin_obj.get_app_role_assignments

      users.each do |user|
        next if user['appRoleAssignments'].find{|_user| _user['resourceId'] == resourceId }
        admin_obj.set_app_role_assignments(user['objectId'], resourceId, user['objectId'])
      end
    end
    
    redirect_to admin_index_path
  end

  def unlink_account
  	account_id = params[:account_id]
  	@local_user = User.find(account_id)

  	if request.post?
      # @account.unlink_email = @account.o365_email
  		# @account.o365_email = nil
      @local_user.organization_id = nil
  		@local_user.save
  		redirect_to linked_accounts_admin_index_path
  	end
  end

  def linked_accounts
    # @accounts = User.where("o365_email is not null and email is not null").select{|obj| obj.o365_email.end_with? tenant_name }
    @accounts = Organization.find_by_name(self.tenant_name).users
  end
end



	# def login_for_admin_consent
	# 	local_user = User.find_by_o365_email(cookies[:o365_login_email])
	# 	if _organization = local_user.organization
	# 		local_user.organization.update_attributes({
	# 			is_admin_consented: true
	# 		})
	# 		local_user.save
	# 	else
	# 		_organization = Organization.new
	# 		_organization.update_attributes({
	# 			name: cookies[:o365_login_email][/(?<=@).*/],
	# 			is_admin_consented: true
	# 		})
	# 		_organization.save
	# 		local_user.organization = _organization
	# 		local_user.save
	# 	end
		
	# 	redirect_to admin_path, notice: 'admin consent success'
	# end