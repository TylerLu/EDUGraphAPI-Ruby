# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class User < ApplicationRecord
  has_secure_password
  belongs_to :organization
  has_many :user_roles
  has_many :roles, through: :user_roles

  def is_linked?
    !self.o365_email.blank? && !self.o365_user_id.blank?
  end

end