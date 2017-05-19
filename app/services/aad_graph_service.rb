# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class AADGraphService

  def initialize(access_token, tenant_id)
    @access_token = access_token
    @baseUrl = Constants::Resources::AADGraph + '/' + tenant_id + '/'
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