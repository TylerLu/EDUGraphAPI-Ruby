# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'school.rb'
require_relative 'term.rb'

module Education

  class Class < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def external_Id      
      get_value('externalId')
    end
  
    def display_name
      get_value('displayName')
    end

    def code
      get_value('classCode')
    end

    def mail_nickname
      get_value('mailNickname')
    end

    def term
      @term ||= Term.new(get_value('term'))
    end

    def schools
      @schools ||= get_value('schools').map { |s| School.new(s) }
    end
  
    def description
      get_value('description')
    end

    def members
      return self.get_value('members')
    end

    def members=(value)
      self.set_value('members', value)
    end

    def teachers
      if members
        members.select{ | m | m.primary_role == 'teacher' }
      else
        nil
      end
    end

    def students
      if members
        members.select{ | m | m.primary_role == 'student' }
      else
        nil
      end
    end

  end
end