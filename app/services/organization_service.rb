# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class OrganizationService

  def create_or_update_organization(tenant_id, tenant_name)
    org = Organization.find_or_create_by(tenant_id: tenant_id)
		org.name = tenant_name
		org.save()
  end

  def update_organization(tenant_id, attributes)
    org = Organization.find_by_tenant_id(tenant_id)
    if org
      org.update_attributes(attributes)
      org.save
    end
  end

  def is_admin_consented(tenant_id)
    org = Organization.find_by_tenant_id(tenant_id)
    org && org.is_admin_consented
  end

end