# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
