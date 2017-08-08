# Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.  
# See LICENSE in the project root for license information. 

require_relative 'object_base.rb'
require_relative 'paged_collection.rb'
require_relative 'next_link.rb'
require_relative 'user.rb'
require_relative 'school.rb'
require_relative 'section.rb'

module Education

  class EducationService

    def initialize(tenant_id, access_token)
      @base_url = "#{Constants::Resources::MSGraph}/beta/"
      @access_token = access_token
    end

    def get_me
      get_object(Education::User, 'me')
    end

    def get_all_schools
      get_objects(Education::School, 'administrativeUnits')
    end

    def get_school(object_id)
      get_object(Education::School, "administrativeUnits/#{object_id}")
    end
    
    def get_my_sections(school_id)
      sections = get_objects(Education::Section, "me/memberOf")
      my_sections = sections.select{|s| s.education_object_type == 'Section' && s.school_id == school_id}  
      my_sections.each do |s|
        s.members = get_section_members(s.object_id)
      end  
    end

    def get_section(section_id)
      get_object(Education::Section, "groups/#{section_id}")
    end
    
    def get_section_members(section_id)
      get_objects(Education::User, "groups/#{section_id}/members")
    end

    def get_sections(school_id, skip_token = nil, top = 12)
      get_paged_objects(Education::Section, 'groups', {
        '$top': 12,
        '$filter': "extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType eq 'Section' and extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId eq '#{school_id}'",
        '$skiptoken': skip_token
      })
    end

    def get_members(school_id, skip_token = nil, top = 12)
      get_paged_objects(Education::User, "administrativeUnits/#{school_id}/members", {
        '$top': top,
        '$skiptoken': skip_token
      })
    end

    def get_teachers(school_id, skip_token = nil, top = 12)
      get_paged_objects(Education::User, "users", {
        '$top': top,
        '$filter': "extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId eq '#{school_id}' and extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType eq 'Teacher'",
        '$skiptoken': skip_token
      })
    end

    def get_students(school_id, skip_token = nil, top = 12)
      get_paged_objects(Education::User, "users", {
        '$top': top,
        '$filter': "extension_fe2174665583431c953114ff7268b7b3_Education_SyncSource_SchoolId eq '#{school_id}' and extension_fe2174665583431c953114ff7268b7b3_Education_ObjectType eq 'Student'",
        '$skiptoken': skip_token
      })
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
        url = url + "?"
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

  end
end