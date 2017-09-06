# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'

module Education

  class Section < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def school_id
       get_education_extension_value('SyncSource_SchoolId')
    end

    def course_id
      get_education_extension_value('SyncSource_CourseId')
    end

    def mail
      return self.get_value('mail')
    end

    def display_name
      return self.get_value('displayName')
    end

    def course_description
      get_education_extension_value('CourseDescription')
    end

    def course_name
      get_education_extension_value('CourseName')
    end

    def course_number
      get_education_extension_value('CourseNumber')
    end
  
    def term_name
      get_education_extension_value('TermName')
    end

    def term_start_date
      get_education_extension_value('TermStartDate')
    end

    def term_end_date
      get_education_extension_value('TermEndDate')
    end

    def period
      get_education_extension_value('Period')
    end

    def anchor_id
      get_education_extension_value('AnchorId')
    end

    def combined_course_number
      "#{course_name[0..2].upcase()}#{course_number}"
    end

    def members
      return self.get_value('members')
    end

    def members=(value)
      self.set_value('members', value)
    end

    def teachers
      if members
        members.select{ | m | m.education_object_type == 'Teacher' }
      else
        nil
      end
    end

    def students
      if members
        members.select{ | m | m.education_object_type == 'Student' }
      else
        nil
      end
    end

  end
end