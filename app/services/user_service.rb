
class UserService

  def authenticate(email, password)
    user = User.find_by_email(email)
		return user if user && user.authenticate(password)
    return nil
  end

  def get_user_by_email(email)
    User.find_by_email(email)
  end

  def get_user_by_o365_email(o365_email)
    User.find_by_o365_email(o365_email)
  end

  def register(email, password, favorite_color)
    user = User.new
		user.assign_attributes({
			email: email,
			password: password,
			favorite_color: favorite_color,
		})
    user.save
    user
  end

  def create(email, first_name, last_name, favorite_color)
    user = User.new
    user.assign_attributes({
      email: email,
      first_name: first_name,
      last_name: last_name,
      password: Settings.default_password,
      favorite_color: favorite_color
    })
    user.save
    user
  end

  def create_or_update_organization(tenant_id, tenant_name)
    org = Organization.find_or_create_by(tenant_id: tenant_id)
		org.name = tenant_name
		org.save()
  end

end