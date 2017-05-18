
class AADGraphService

  def initialize(access_token, tenant_id)
    @access_token = access_token
    @baseUrl = Constant::Resources::AADGraph + '/' + tenant_id + '/'
  end

  def get_service_principal(appId)
    result = request('get', 'servicePrincipals?api-version=1.6', {
        '$filter': "appId eq '#{appId}'"
    })
    value = result['value']
    value.length > 0 ? value[0] : nil
  end

  def delete_service_principal(service_principal_id)
    request('delete', "servicePrincipals/#{service_principal_id}?api-version=1.6")
  end

  def add_app_role_assignments(service_principal_id, service_principal_id_name)
    users = request('get', 'users?api-version=1.6&$expand=appRoleAssignments')['value']

    count = 0
    for user in users
      if user['appRoleAssignments'].all? { |a| a['resourceId'] != service_principal_id }
        add_app_role_assignment(user, service_principal_id, service_principal_id_name)
        count = count + 1
      end
    end        
    count
  end

  private def add_app_role_assignment(user, service_principal_id, service_principal_id_name)
    app_role_assignment = {
        'odata.type': 'Microsoft.DirectoryServices.AppRoleAssignment',
        'principalDisplayName': user['displayName'],
        'principalId': user['objectId'],
        'principalType': 'User',
        'resourceId': service_principal_id,
        'resourceDisplayName': service_principal_id_name
    }
    request('post', "users/#{user['objectId']}/appRoleAssignments?api-version=1.6", {}, app_role_assignment.to_json)
  end

  private def request(request_method, path, query = {}, body = {})
    response = HTTParty.method(request_method).call(
      @baseUrl + path,
      query: query,
      body: body,
      headers: {
        "Authorization" => "Bearer #{@access_token}",
        "Content-Type" => "application/json"
      }
    )
    JSON.parse(response.body)
  end

end
# def get_service_principals(ClientId)
#     res = graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'servicePrincipals',
#     access_token: aad_token,
#     query: {
#         "$filter" => "appId eq '#{ClientId}'"
#     }
#     })
#     res['value']
# end

# def delete_service_principals(object_id)
#     res = graph_request({
#     http_method: 'delete',
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: "servicePrincipals/#{object_id}",
#     access_token: aad_token,
#     })
#     return res
# end

# def get_app_role_assignments
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'users',
#     api_version: '1.5',
#     access_token: aad_token,
#     query: {
#         "$expand" => "appRoleAssignments"
#     }
#     })
# end

# def set_app_role_assignments(user_id, resourceId, principalId)
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: "users/#{user_id}/appRoleAssignments",
#     api_version: '1.5',
#     body: {
#         "resourceId" => resourceId,
#         "principalId" => principalId
#     }.to_json
#     })
# end


# def get_administrative_units
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'administrativeUnits',
#     access_token: aad_token
#     })['value']
# end

# def get_class_info(class_id)
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: "groups/#{class_id}",
#     access_token: aad_token
#     })
# end

# def get_class_members(class_id)
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: "groups/#{class_id}/$links/members",
#     access_token: aad_token
#     })
# end

# def get_user_classes(id_or_email)
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     access_token: aad_token,
#     resource_name: "users/#{id_or_email}/memberOf"
#     })['value'].select{|_class| _class['objectType'] == 'Group' }
# end

# def get_classes_with_members(object_id)
#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     access_token: aad_token,
#     resource_name: "groups/#{object_id}",
#     query: {
#         "$expand" => "members"
#     }
#     })
# end

# def get_classes_by_school_number(school_number, skip_token = nil)
#     _query = {
#     "$top" => 12,
#     "$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
#     }
#     _query.merge!({"$skiptoken" => skip_token}) if skip_token

#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'groups',
#     access_token: aad_token,
#     query: _query
#     })
# end

# def get_users(school_number, role: nil, skiptoken: nil)
#     _query = {
#     "$top" => 12,
#     "$filter" => "#{Constant.get('edu_school_id')} eq '#{school_number}'"
#     }
#     _query.merge!({"$skiptoken" => skiptoken}) if skiptoken
#     _query.merge!({"$filter" => "#{Constant.get('edu_object_type')} eq '#{role}' and #{Constant.get('edu_school_id')} eq '#{school_number}'"}) if role

#     graph_request({
#     host: Constant::Resources::AADGraph,
#     tenant_name: self.tenant_name,
#     resource_name: 'users',
#     access_token: aad_token,
#     query: _query
#     })
# end

# def get_roles
#     return self.roles if self.roles.present?
#     self.roles = []
#     if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:teacher_sku_id) || _['skuId'] == Constant.get(:teacher_pro_sku_id) }
#     self.roles << 'Teacher'
#     end

#     if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:student_sku_id) || _['skuId'] == Constant.get(:student_pro_sku_id) }
#     self.roles << 'Student'
#     end

#     myroles = graph_request({
#     host: Constant::Resources::AADGraph,
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
