# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class User < ApplicationRecord
  has_secure_password
  belongs_to :organization
  has_many :roles, through: :user_roles
end
