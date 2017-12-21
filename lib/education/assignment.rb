# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'school.rb'
require_relative 'term.rb'

module Education

  class ResourceContainer < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def resource
      @resource ||= EducationResource.new(get_value('resource'))
    end

  end

  class EducationResource < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def display_name
      get_value('displayName')
    end

    def created_dateTime
      get_value('createdDateTime')
    end

  end


  class Assignment < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end
  
    def allow_lateSubmissions
      get_value('allowLateSubmissions')
    end

    def allow_studentsToAddResourcesToSubmission
      get_value('allowStudentsToAddResourcesToSubmission')
    end

    def assign_dateTime
      get_value('assignDateTime')
    end
    
    def assigned_dateTime
      get_value('assignedDateTime')
    end

    def class_id
      get_value('classId')
    end

    def display_name
      get_value('displayName')
    end

    def due_dateTime
      get_value('dueDateTime')
    end

    def status
      get_value('status')
    end

    def resources
      @resources ||= get_value('resources').map { |s| ResourceContainer.new(s) }
    end

  end
end