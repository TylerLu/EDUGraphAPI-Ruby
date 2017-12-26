# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'school.rb'
require_relative 'term.rb'

module Education
  
  class EducationAssignmentResource < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def distribute_for_student_work
      get_value('distributeForStudentWork')
    end

    def resource
      @resource ||= EducationResource.new(get_value('resource'))
    end
  end

  class ItemReference < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def drive_id
      get_value('driveId')
    end
  end

  class DriveItem < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def name
      get_value('name')
    end

    def parent_reference
      @parent_reference ||= ItemReference.new(get_value('parentReference'))
    end
    
  end

   class ResourcesFolder < ObjectBase
    
    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def odata_id
      get_value('odataid')
    end

    def resource_folder_URL
      get_value('value')
    end
    
  end

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

class User < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def display_name
      get_value('displayName')
    end
end

class SubmittedBy < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end

    def user
      @user ||= User.new(get_value('user'))
    end
end

class Submission < ObjectBase

    def initialize(prop_hash = {})
      super(prop_hash)
    end
    
    def status
      get_value('status')
    end
    def submitted_dateTime
      get_value('submittedDateTime')
    end

    def submitted_By
      @submitted_By ||= SubmittedBy.new(get_value('submittedBy'))
    end

    def resources_folder
      @resources_folder ||= EducationResource.new(get_value('resourcesFolder'))
    end

    def resources_folder_Url
      get_value('resourcesFolderUrl')
    end
    
    def resources
      @resources ||= get_value('resources').map { |s| ResourceContainer.new(s) }
    end
  end

end