# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class UserService

  def authenticate(email, password)
    user = User.find_by_email(email)
		return user if user && user.authenticate(password)
    return nil
  end

  def get_user_by_id(user_id)
    User.find_by_id(user_id)
  end

  def get_user_by_email(email)
    User.find_by_email(email)
  end

  def register(email, password)
    user = User.new
		user.assign_attributes({
			email: email,
			password: password
		})
    user.save
    user
  end

  def create(email, first_name, last_name)
    user = User.new
    user.assign_attributes({
      email: email,
      first_name: first_name,
      last_name: last_name,
      password: SecureRandom.base64
    })
    user.save
    user
  end
  
end