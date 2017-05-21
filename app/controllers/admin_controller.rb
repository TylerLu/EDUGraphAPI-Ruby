# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AdminController < ApplicationController

	before_action :require_login, :except => [:consent, :consent_post, :consent_callback]
	before_action :admin_only, :except => [:consent, :consent_post, :consent_callback]

  def index
		organization_service = OrganizationService.new
    @is_admin_consented = organization_service.is_admin_consented(current_user.tenant_id)
  end

  def consent
  end

  def consent_post
    redirect_to azure_auth_path(
      :prompt => 'admin_consent',
      :login_hint => current_user.o365_email,
      :callback_path => '/admin/consent_callback'
    )
  end

  def consent_callback
		auth = request.env['omniauth.auth']
		organization_service = OrganizationService.new
		organization_service.update_organization(auth.info.tid, {is_admin_consented: true})
    flash[:notice] = 'Admin unconsented successfully!'
    self.azure_oauth2_logout_required = true
		redirect_to current_user.is_admin? ? admin_index_path : admin_consent_path
  end

  def unconsent
    token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    aad_graph_service = AADGraphService.new(token, current_user.tenant_id)

    # delete the service principal from AAD
    service_principal = aad_graph_service.get_service_principal(Settings.AAD.ClientId)
    if service_principal
      aad_graph_service.delete_service_principal(service_principal['appId'])
    end

		organization_service = OrganizationService.new
		organization_service.update_organization(current_user.tenant_id, {is_admin_consented: false})

    link_service = LinkService.new
    link_service.unlink_accounts(current_user.tenant_id)
    clear_local_user()

    redirect_to admin_index_path
  end


  def add_app_role_assignments
    token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
    aad_graph_service = AADGraphService.new(token, current_user.tenant_id)

    service_principal = aad_graph_service.get_service_principal(Settings.AAD.ClientId)
    if !service_principal
      redirect_to admin_index_path, alert: 'Could not find the service principal. Please provide admin consent.' and return
    end

    count = aad_graph_service.add_app_role_assignments(service_principal['objectId'], service_principal['appDisplayName'])
    
    flash[:notice] = count > 0 ? "User access was successfully enabled for #{count} user(s)." : 'User access was enabled for all users.'
     % count if count > 0 else 
    redirect_to admin_index_path
  end

  def linked_accounts
    link_service = LinkService.new
    @linked_users = link_service.get_linked_users(current_user.tenant_id)
  end

  def unlink_account
    user_service = UserService.new
    @user = user_service.get_user_by_id(params[:id])
  end

  def unlink_account_post
    link_service = LinkService.new
    link_service.unlink_account(params[:id])
    redirect_to admin_linked_accounts_path
  end

end