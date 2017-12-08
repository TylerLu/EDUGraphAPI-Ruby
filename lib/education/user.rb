# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'teacher.rb'
require_relative 'student.rb'
require_relative 'school.rb'
require_relative 'class.rb'

module Education

  class User < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def display_name
      get_value('displayName')
    end

    def grade
      get_value('Grade')
    end

    def primary_role
      get_value('primaryRole')
    end

    def teacher
      @teacher ||= get_value('teacher') ?  Teacher.new(get_value('teacher')) : nil
    end

    def student
      @student ||= get_value('student') ? Student.new(get_value('student')) : nil
    end

    def is_teacher?
      primary_role == 'teacher'
    end

    def schools
      @schools ||= get_value('schools').map{ |i| School.new(i) }
    end

    def classes
      @schools ||= get_value('classes').map{ |i| Class.new(i) }
    end

    def is_in_school(school)
      schools.any? { |s| s.id == school.id }
    end

    #def school_id
    #  get_value('SyncSource_SchoolId')
    #end

    #def student_id
    #  get_value('SyncSource_StudentId')
    #end
    
    #def teacher_id
    #  get_value('SyncSource_TeacherId')
    #end

    def education_user_id
      teacher.nil? ? student.external_id : teacher.external_id
    end

  end

end