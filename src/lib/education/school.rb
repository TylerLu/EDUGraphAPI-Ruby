# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class School < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def school_id
      get_education_extension_value('SyncSource_SchoolId')
    end
  
    def number
      get_education_extension_value('SchoolNumber') 
    end

    def display_name
      get_value('displayName')
    end

    def principal_name
      get_education_extension_value('SchoolPrincipalName')
    end

    def lowest_grade
      get_education_extension_value('LowestGrade')
    end

    def highest_grade
      get_education_extension_value('HighestGrade')
    end

    def zip
      get_education_extension_value('Zip')
    end

    def address
      get_education_extension_value('Address')
    end

    def city
      get_education_extension_value('City')
    end

    def state
      get_education_extension_value('StateId')
    end

  end

end