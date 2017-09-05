# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

module Constants

  AADInstance = "https://login.microsoftonline.com/"

  module Resources
    MSGraph = 'https://graph.microsoft.com' 
    AADGraph = 'https://graph.windows.net'
  end

  module Roles
    Admin = 'Admin'
    Faculty = 'Teacher'
    Student = 'Student'
  end

  # O365 product licenses
  module Licenses
    #Microsoft Classroom Preview
    Classroom = "80f12768-d8d9-4e93-99a8-fa2464374d34"
    #Office 365 Education for faculty
    Faculty = "94763226-9b3c-4e75-a931-5c89701abe66"
    #Office 365 Education for students
    Student = "314c4481-f395-4525-be8b-2ec4bb1e9d91"
    #Office 365 Education for faculty
    FacultyPro = "78e66a63-337a-4a9a-8959-41c6654dfb56"
    #Office 365 Education for students
    StudentPro = "e82ae690-a2d5-4d76-8d30-7c6e01e6022e"
  end

  AADCompanyAdminRoleName = 'Company Administrator'

end