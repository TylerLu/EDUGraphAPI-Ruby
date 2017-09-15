# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class UnifiedUser

  attr_accessor :local_user

  def initialize(local_user)
    self.local_user = local_user
  end

  def is_authenticated?
    self.local_user
  end
  
  def display_name
    user = self.local_user
    if user
      if user.first_name.blank? || user.last_name.blank?
        return user.email
      else
        return "#{user.first_name} #{user.last_name}"
      end
    end
  end
end