# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class LinkService

  def is_linked_to_local_account(o365_email)
    user = User.find_by_o365_email(o365_email)
    user && user.is_linked?
  end

  def is_linked_to_o365_account(email)
    user = User.find_by_email(email)
    user && user.is_linked?
  end

  def link(local_user, o365_user_id, o365_email, tenant_id, roles)
    local_user.assign_attributes({
      o365_user_id: o365_user_id,
      o365_email: o365_email,
      organization: Organization.find_by_tenant_id(tenant_id),
    })
    local_user.roles =  Role.where(name: roles)
    local_user.save
  end

  def get_linked_users(tenant_id)
    org = Organization.find_by_tenant_id(tenant_id)
    if org
      User.where(organization_id: org.id)
        .where.not(o365_user_id: '')
        .where.not(o365_email: '')
    else
      User.none 
    end
  end

  def unlink_accounts(tenant_id)
    org = Organization.find_by_tenant_id(tenant_id)
    if org
      users = User.where(organization_id: org.id)      
      users.update_all({
        o365_user_id: nil,
        o365_email: nil,
        organization_id: nil,
      })
      Role.where(user_id: users.map{|u|u.id}).delete_all()
    end
  end

  def unlink_account(user_id)
    user = User.find_by_id(user_id)
    if user
      user.update_attributes({
        o365_user_id: nil,
        o365_email: nil,
        organization: nil,
      })
      user.roles = Role.none
      user.save()
    end
  end

end