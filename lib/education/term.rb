# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class Term < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def external_Id      
      get_value('externalId')
    end
  
    def display_name
      get_value('displayName')
    end

    def start_date
      DateTime.parse(get_value('startDate'))
    end

    def end_date
      DateTime.parse(get_value('endDate'))
    end

  end

end