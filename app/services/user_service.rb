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
      password: nil,
      favorite_color: favorite_color
    })
    user.save
    user
  end
  
  def get_favorite_color(user_id)
    user = User.find_by_id(user_id)
    user ? user.favorite_color : nil
  end

  def update_favorite_color(user_id, favorite_color)
    user = User.find_by_id(user_id)
    if user
      user.favorite_color = favorite_color
      user.save()
    end
  end

  def get_favorite_color_hash(o365_user_ids)
    User
			.where('o365_user_id', o365_user_ids)
			.pluck(:o365_user_id, :favorite_color)
			.to_h     
  end

  def get_seating_position_hash(class_object_id)
		ClassroomSeatingArrangement
			.where("class_id = ? and position != 0", class_object_id)
			.pluck(:user_id, :position)
			.to_h
  end

  def save_seating_positions(class_object_id, postions)
		postions.values.each do |info|
			user_set = ClassroomSeatingArrangement.find_by({class_id: info['ClassId'],user_id: info['O365UserId']})
			if user_set
				user_set.position = info['Position']
				user_set.save
			else
				ClassroomSeatingArrangement.create({
					class_id: info['ClassId'],
					user_id: info['O365UserId'],
					position: info['Position']
				})
			end
		end
  end

end