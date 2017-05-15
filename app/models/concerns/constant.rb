# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

module Constant

	AADInstance = "https://login.microsoftonline.com/"

	module Resource
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

  
	@mapping = {
		object_id: 'objectId',
		edu_object_type: 'extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType',
		display_name: 'displayName',
		given_name: 'givenName',
		edu_student_id: 'extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_StudentId',
		edu_teacher_id: 'extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_TeacherId',
		edu_school_id: 'extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId',
		edu_address: 'extension_fe2174665583431c953114ff7268b7b3_Education_Address',
		edu_school_number: 'extension_fe2174665583431c953114ff7268b7b3_Education_SchoolNumber',
		edu_course_id: 'extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_CourseId',
		edu_course_suject: 'extension_fe2174665583431c953114ff7268b7b3_Education_CourseSubject',
		edu_course_number: 'extension_fe2174665583431c953114ff7268b7b3_Education_CourseNumber',
		edu_course_desc: 'extension_fe2174665583431c953114ff7268b7b3_Education_CourseDescription',
		edu_term_name: 'extension_fe2174665583431c953114ff7268b7b3_Education_TermName',
		edu_term_start_date: 'extension_fe2174665583431c953114ff7268b7b3_Education_TermStartDate',
		edu_term_end_date: 'extension_fe2174665583431c953114ff7268b7b3_Education_TermEndDate',
		edu_period: 'extension_fe2174665583431c953114ff7268b7b3_Education_Period',
		principal_name: 'userPrincipalName',
		edu_grade: 'extension_fe2174665583431c953114ff7268b7b3_Education_Grade',
		edu_state: 'extension_fe2174665583431c953114ff7268b7b3_Education_State',
		edu_city: 'extension_fe2174665583431c953114ff7268b7b3_Education_City',
		surname: 'surname',
		aad_company_admin_role_name: 'Company Administrator',
		errors: {
			token_expired: 'Directory_ExpiredPageToken'
		}
	}

	class << self
		def get(key)
			@mapping[key.to_sym]
		end
	end
end