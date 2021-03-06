# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'paged_collection.rb'
require_relative 'next_link.rb'
require_relative 'user.rb'
require_relative 'school.rb'
require_relative 'class.rb'

module Education

  class EducationService

    def initialize(tenant_id, access_token)
      @base_url = "#{Constants::Resources::MSGraph}/beta"
      @access_token = access_token
    end

    def get_me
      get_object(Education::User, 'education/me', {
        '$expand': 'schools,classes'
      })
    end

    def get_all_schools
      get_objects(Education::School, 'education/schools')
    end

    def get_school(id)
      get_object(Education::School, "education/schools/#{id}")
    end
    
    def get_classes(school_id, top = 12, skip_token = nil)
      get_paged_objects(Education::Class, "education/schools/#{school_id}/classes", {
        '$top': top,
        '$skiptoken': skip_token,
        '$expand': 'members'
      })
    end

    def get_my_classes(school_id = nil)
      classes = get_objects(Education::Class, "education/me/classes", {
        '$expand': 'schools'
      })
      if school_id 
        classes = classes.select{|c| c.schools.any? { |s| s.id == school_id }}
      end  
      classes.each do |c|
        c.members = get_class_members(c.id)
      end  
    end

    def get_class(class_id)
      get_object(Education::Class, "education/classes/#{class_id}")
    end
    
    def get_class_members(class_id)
      get_objects(Education::User, "education/classes/#{class_id}/members")
    end

    def get_teachers(school_number)
      get_objects(Education::User, "users", {
        '$filter': "extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId eq '#{school_number}' and extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType eq 'Teacher'"
      })
    end

    def add_user_to_class_as_member(class_id, user_id) 
      data = { "@odata.id": "#{@base_url}/users/#{user_id}"}
      request('post', "groups/#{class_id}/members/$ref", {}, data.to_json)
    end

    def add_user_to_class_as_owner(class_id, user_id) 
       data = { "@odata.id": "#{@base_url}/users/#{user_id}"}
       request('post', "groups/#{class_id}/owners/$ref", {}, data.to_json)
    end

    def get_assignments_by_class_id(class_id)
      get_objects(Education::Assignment, "education/classes/#{class_id}/assignments")
    end
    
    def create_assignment(class_id, assignment_obj)
      request('post', "education/classes/#{class_id}/assignments", {}, assignment_obj.to_json)
    end

    def publish_assignment(class_id, assignment_id)
      request('post', "education/classes/#{class_id}/assignments/#{assignment_id}/publish", {}, nil)
    end

    def get_assignment_resource_folder_URL(class_id, assignment_id)
        get_object(Education::ResourcesFolder, "education/classes/#{class_id}/assignments/#{assignment_id}/GetResourcesFolderUrl")
    end

    def upload_File(ids, file_name, data)
      request('put', "drives/#{ids[0]}/items/#{ids[1]}:/#{file_name}:/content",{}, data)
    end

    def add_assignment_resources(class_id, assignment_id,file_name, file_type,resource_url)
      data = {"resource":{"displayName":file_name, "@odata.type":file_type, "file":{"odataid":"#{@base_url}/#{resource_url}"}} }
      request('post', "education/classes/#{class_id}/assignments/#{assignment_id}/resources", {}, data.to_json)
    end

    def add_submission_resource(class_id, assignment_id, submission_id,file_name, file_type,resource_url)
      data = {"resource":{"displayName":file_name, "@odata.type":file_type, "file":{"odataid":"#{@base_url}/#{resource_url}"}} }
      request('post', "education/classes/#{class_id}/assignments/#{assignment_id}/submissions/#{submission_id}/resources", {}, data.to_json)
    end

    def get_assignment_resources(class_id, assignment_id)
      get_objects(Education::EducationAssignmentResource, "education/classes/#{class_id}/assignments/#{assignment_id}/resources")
    end

   def get_assignment_submission_by_user(class_id, assignment_id, user_id)
      get_objects(Education::Submission, "education/classes/#{class_id}/assignments/#{assignment_id}/submissions?$filter=submittedBy/user/id eq '#{user_id}'")
   end

   def get_assignment_submissions(class_id, assignment_id)
      get_objects(Education::Submission, "education/classes/#{class_id}/assignments/#{assignment_id}/submissions")
   end





    private

    def graph_request(row = {}, kclass)
      response = HTTParty.get(
        "#{@base_url}/#{row[:resource_name]}",
        query: row[:query] || {},
        headers: {
          "Authorization" => "Bearer #{@access_token}"
        }
      )
      hash = JSON.parse(response.body)
      kclass ? kclass.new(hash) : hash     
    end

    def get_object(kclass, path, query = {})
      hash = get_hash(path, query)
      kclass.new(hash)
    end

    def get_objects(kclass, path, query ={})
      hash = get_hash(path, query)
      hash['value'].map{ |i| kclass.new(i) }
    end

    def get_paged_objects(kclass, path, query = {})
      hash = get_hash(path, query)
      
      objects = hash['value'].map{ |i| kclass.new(i) }
      next_link = hash.key?('@odata.nextLink') ? Education::NextLink.new(hash['@odata.nextLink']) : nil
      Education::PagedCollection.new(objects, next_link)
    end

    def get_hash(path, query = {})
      url = "#{@base_url}/#{path}"
      if(!query.empty?)
        url += "?"
        query.each do |key, value|
          url = value ? url + "#{key}=#{value}&" : url
        end
        url = url[0, url.length-1]
      end
      response = HTTParty.get(
        url,
        headers: {
          "Authorization" => "Bearer #{@access_token}"
        }
      )
      JSON.parse(response.body)    
    end

    def request(request_method, path, query = {}, body = {})
      url = "#{@base_url}/#{path}"
      begin
        response = HTTParty.method(request_method).call(
          url,
          query: query,
          body: body,
          headers: {
            "Authorization" => "Bearer #{@access_token}",
            "Content-Type" => "application/json"
          }
        )
        response.body ? JSON.parse(response.body) : nil
      rescue => exception
        nil
      end
    end

  end
end