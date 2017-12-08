
# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class PhysicalAddress < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def street
      get_value('street')
    end

    def city
      get_value('city')
    end

     def state
      get_value('state')
    end

    def postal_code
      get_value('postalCode')
    end

  end

end