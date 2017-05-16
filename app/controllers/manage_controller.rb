# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class  < ApplicationController
	skip_before_action :verify_authenticity_token

  def aboutme
  	@local_user = User.find_by_email(cookies[:local_account]) || User.find_by_o365_email(cookies[:o365_login_email])
  end

  def update_favorite_color
  	local_user = User.find(params["account_id"])
  	local_user.favorite_color = params["favoritecolor"]
  	local_user.save

  	redirect_to aboutme_manage_index_path, notice: 'Favorite color has been updated!'
  end
end
