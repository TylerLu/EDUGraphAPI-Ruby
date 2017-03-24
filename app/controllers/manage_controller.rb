# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ManageController < ApplicationController
	skip_before_action :verify_authenticity_token

  def aboutme
  	@account = Account.find_by_email(cookies[:local_account]) || Account.find_by_o365_email(cookies[:o365_login_email])
  end

  def update_favorite_color
  	account = Account.find(params["account_id"])
  	account.favorite_color = params["favoritecolor"]
  	account.save

  	redirect_to aboutme_manage_index_path, notice: 'Favorite color has been updated!'
  end
end
