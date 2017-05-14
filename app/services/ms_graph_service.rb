class MSGraphService

  
  def initialize(access_token)
    @access_token = access_token
    @base_url = Constant::Resource::MSGraph + '/v1.0'

    callback = Proc.new { |r| r.headers["Authorization"] = "Bearer #{@access_token}" }
    @graph = MicrosoftGraph.new(
        base_url: @base_url,
        cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, "metadata_v1.0.xml"),
        &callback
      )
    #@rest_service = RESTService.new(base_url, access_token)
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
    admin_role = @graph.directoryRoles.first{|_| _.display_name == Constant.AADCompanyAdminRoleName }
    members = @graph.directoryRoles.find(admin_role.id).members
    if members.any?{|_| _.id == me.id}
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
#     return self.roles if self.roles.present?
#     self.roles = []
#     if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:teacher_sku_id) || _['skuId'] == Constant.get(:teacher_pro_sku_id) }
#     self.roles << 'Teacher'
#     end

#     if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:student_sku_id) || _['skuId'] == Constant.get(:student_pro_sku_id) }
#     self.roles << 'Student'
#     end

#     myroles = graph_request({
#     host: Constant::Resource::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'directoryRoles',
#     access_token: self.aad_token,
#     query: {
#         "$expand" => 'members'
#     }
#     })['value'].select{|_| _['displayName'] == Constant.get(:aad_company_admin_role_name) }

#     myroles.each do |_role|
#     if _role['members'].find{|_| _['objectId'] == get_current_user['objectId'] }
#         self.roles << 'Admin'
#     end
#     end

#     return self.roles

end