# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'physical_address.rb'

module Education

  class School < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def school_id      
      get_value('externalId')
    end
  
    def display_name
      get_value('displayName')
    end

    def principal_name
      get_value('principalName')
    end

    def lowest_grade
      get_value('highestGrade')
    end

    def highest_grade
      get_value('lowestGrade')
    end

    def number
      get_value('schoolNumber')
    end

    def school_id
      get_value('SyncSource_SchoolId')
    end

    def address
      if @address.nil?
        @address = PhysicalAddress.new(get_value('address'))
      end
      @address
    end

  end

end