# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class O365User   

  attr_accessor :id
  attr_accessor :email
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :tenant_id
  
  def initialize(id, email, first_name, last_name, tenant_id)
    self.id = id
    self.email = email
    self.first_name = first_name
    self.last_name = last_name
    self.tenant_id = tenant_id
  end

end