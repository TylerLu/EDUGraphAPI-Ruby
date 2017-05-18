# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class User < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def display_name
      get_value('displayName')
    end

    def grade
      get_education_extension_value('Grade')
    end

    def is_teacher?
      education_object_type == 'Teacher'
    end

    def school_id
      get_education_extension_value('SyncSource_SchoolId')
    end

    def student_id
      get_education_extension_value('SyncSource_StudentId')
    end
    
    def teacher_id
      get_education_extension_value('SyncSource_TeacherId')
    end

    def education_user_id
      student_id ? student_id : teacher_id 
    end

  end

end