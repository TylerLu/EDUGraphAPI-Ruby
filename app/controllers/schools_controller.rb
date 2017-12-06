# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class SchoolsController < ApplicationController

  before_action :require_login
  before_action :linked_users_only

  def index
    ms_access_token = token_service.get_access_token(current_user.o365_user_id, Constants::Resources::MSGraph)
    education_service = Education::EducationService.new(current_user.tenant_id, ms_access_token)
      
    @me = education_service.get_me
    @schools = education_service.get_all_schools
      .sort_by { |s| ((s.school_id == @me.school_id) ? 'A' : 'Z') + s.display_name }
  end

end