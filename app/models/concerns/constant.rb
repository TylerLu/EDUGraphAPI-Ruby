# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information.  

class Constant
	@mapping = {
		object_id: 'objectId',
		edu_object_type: 'extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType',
		display_name: 'displayName',
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