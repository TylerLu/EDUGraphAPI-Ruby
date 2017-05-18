# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class MSGraphService

  def initialize(access_token)
    @access_token = access_token
    @base_url = Constant::Resources::MSGraph + '/v1.0'

    callback = Proc.new { |r| r.headers["Authorization"] = "Bearer #{@access_token}" }
    @graph = MicrosoftGraph.new(
        base_url: @base_url,
        cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, "metadata_v1.0.xml"),
        &callback
      )
  end

  def get_organization(tenant_id)
    @graph.organization.find(tenant_id)
  end

  def get_user_photo(o365_user_id)
    url = @base_url + "/users/#{o365_user_id}/photo/$value"
    HTTParty.get(url, headers: {
       "Authorization" => "Bearer #{@access_token}"
    })
  end

  def get_my_roles
    me = @graph.me
    roles = []
    # 
    licenses = @graph.me.assigned_licenses
    if @graph.me.assigned_licenses.any?{|_| _.sku_id == Constant::Licenses::Faculty || _.sku_id == Constant::Licenses::FacultyPro }
      roles << Constant::Roles::Faculty
    elsif
      @graph.me.assigned_licenses.any?{|_| _.sku_id == Constant::Licenses::Student || _.sku_id == Constant::Licenses::StudentPro }
      roles << Constant::Roles::Student
    end
    #
    admin_role = @graph.directoryRoles.detect{|a|a.display_name == Constant::AADCompanyAdminRoleName }
    admin_role.members.reload!    
    if admin_role.members.any?{|_| _.id == me.id}
      roles << Constant::Roles::Admin
    end       
    roles
  end  

  def get_conversations(section_id)
    @graph.groups.find(section_id).conversations rescue []
  end

  def get_documents(section_id)
    @graph.groups.find(section_id).drive.root.children rescue []
  end
  
end