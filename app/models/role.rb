# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class Role < ApplicationRecord
  has_many :users, through: :user_roles
end
