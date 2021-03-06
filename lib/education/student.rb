# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class Student < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def external_id      
      get_value('externalId')
    end

    def grade
      get_value('grade')
    end

    def student_number
      get_value('studentNumber')
    end

  end

end