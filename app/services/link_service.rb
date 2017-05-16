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


end