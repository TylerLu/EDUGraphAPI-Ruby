# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class Account < ApplicationRecord
	# belongs_to :role
	belongs_to :token
  belongs_to :organization
  has_many :roles, through: :accounts_and_roles
end
