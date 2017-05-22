# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class ManageController < ApplicationController
	
  before_action :require_login

  def aboutme
		if current_user.are_linked? or current_user.local_user
			user_service = UserService.new
			@favorite_color = user_service.get_favorite_color(current_user.user_id)
		end
		if current_user.o365_user
			token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::AADGraph)
			education_service = Education::EducationService.new(current_user.tenant_id, token)
			me = education_service.get_me()
			if me.school_id
				@sections = education_service.get_my_sections(me.school_id)
		  end
		end
  end

  def update_favorite_color
		user_service = UserService.new
		user_service.update_favorite_color(params["user_id"], params["favoritecolor"])
  	redirect_to manage_aboutme_path, notice: 'Favorite color has been updated!'
  end

end