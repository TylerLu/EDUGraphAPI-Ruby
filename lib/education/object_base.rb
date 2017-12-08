# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

class ObjectBase

  attr_accessor :prop_hash
  attr_accessor :custom_hash
  def initialize(prop_hash = {})
    self.prop_hash = prop_hash
    self.custom_hash = {}
  end

  def get_value(property_name)
    prop_hash[property_name]
  end
  
  def set_value(property_name, value)
    prop_hash[property_name] = value
  end

  def id
    get_value('id')
  end

  def custom_data
    custom_hash
  end   

end