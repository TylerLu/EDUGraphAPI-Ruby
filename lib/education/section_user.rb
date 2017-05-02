
module Education
  class SectionUser
    include Education 
    
    attr_accessor :tenant_name
    attr_accessor :school_number
    attr_accessor :aad_token

    def initialize(tenant_name, token, school_number)
      self.tenant_name = tenant_name
      self.aad_token = token
      self.school_number = school_number
    end

    def get_users(role: nil, skiptoken: nil)
      _query = {
        "$top" => 12,
        "$filter" => "#{Constant.get('edu_school_id')} eq '#{self.school_number}'"
      }
      _query.merge!({"$skiptoken" => skiptoken}) if skiptoken
      _query.merge!({"$filter" => "#{Constant.get('edu_object_type')} eq '#{role}' and #{Constant.get('edu_school_id')} eq '#{self.school_number}'"}) if role

      graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: 'users',
        access_token: aad_token,
        query: _query
      })
    end

    def get_teachers(skip_token=nil)
      get_users(role: 'Teacher', skiptoken: skip_token)
    end

    def get_students(skip_token=nil)
      get_users(role: 'Student', skiptoken: skip_token)
    end
  end
end
