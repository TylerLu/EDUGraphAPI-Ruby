# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AdminController < ApplicationController
	skip_before_action :verify_authenticity_token

  def index
  	@local_user = current_user.local_user
  end

  def consent
    redirect_to azure_auth_path(
      :prompt => 'admin_consent',
      :login_hint => current_user.o365_email,
      :callback_path => '/admin/consent_callback'
    )
  end

  def consent_callback
		auth = request.env['omniauth.auth']
		# mark organization as admin consented
		user_service = UserService.new
		user_service.update_organization(auth.info.tid, {is_admin_consented: true})
		redirect_to admin_index_path
  end

  def unconsent
    token = token_service.get_access_token(current_user.o365_user_id, Constant::Resource::AADGraph)
    aad_graph_service = AADGraphService.new(token, current_user.tenant_id)

    service_principal = aad_graph_service.get_service_principal(Settings.AAD.ClientId)
    if service_principal
      aad_graph_service.delete_service_principal(service_principal['appId'])
    end

    link_service = LinkService.new
    link_service.unlink_accounts(current_user.tenant_id)
    clear_local_user()

    redirect_to admin_index_path
  end


  def add_app_role_assignments
    admin_obj = AdminService.new(aad_graph)
    res = admin_obj.get_service_principal(Settings.AAD.ClientId)
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

  def linked_accounts
    link_service = LinkService.new
    @linked_users = link_service.get_linked_users()
  end

  def unlink_account(id)
    user_service = UserService.new
    @user = user_service.get_user_by_id(user_id)
  end

  def unlink_account_post
  	id = params[:id]
    link_service = LinkService.new
    link_service.unlink_account(id)

  	if request.post?
      # @account.unlink_email = @account.o365_email
  		# @account.o365_email = nil
      @local_user.organization_id = nil
  		@local_user.save
  		redirect_to admin_linked_accounts_path
  	end
  end

end