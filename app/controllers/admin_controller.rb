class AdminController < ApplicationController
	skip_before_action :verify_authenticity_token

  def index
  	# 判断是否consent
  	@account = Account.find_by_o365_email(cookies[:o365_login_email])
  end

  def consent
  	consent_url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&client_id=#{Settings.edu_graph_api.app_id}&resource=https://graph.windows.net&redirect_uri=#{Settings.redirect_uri}&state=12345&prompt=admin_consent"

  	redirect_to consent_url
  end

  def unconsent

  end

  def unlink_account
  	account_id = params[:account_id]
  	@account = Account.find(account_id)

  	if request.post?
  		@account.o365_email = nil
  		@account.save
  		redirect_to linked_accounts_admin_index_path
  	end
  end

  def linked_accounts
  	@accounts = Account.where("o365_email is not null and email is not null")
  end
end
