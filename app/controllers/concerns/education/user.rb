module Education
  module User
    def get_users(school_number, skiptoken = nil)
      _query = {
        "$top" => 12,
        "$filter" => "#{Constant.get('edu_school_id')} eq '#{school_number}'"
      }
      _query.merge!({"$skiptoken" => skiptoken}) if skiptoken

      graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        resource_name: 'users',
        access_token: session[:gwn_access_token],
        query: _query
      })
    end

    def get_teachers(school_number, skiptoken = nil)
      _query = {
        "$top" => 12,
        "$filter" => "#{Constant.get('edu_object_type')} eq 'Teacher' and #{Constant.get('edu_school_id')} eq '#{school_number}'"
      }
      _query.merge!({"$skiptoken" => skiptoken}) if skiptoken
      graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        resource_name: 'users',
        access_token: session[:gwn_access_token],
        query: _query
      })
    end

    def get_students(school_number, skiptoken = nil)
      _query = {
        "$top" => 12,
        "$filter" => "#{Constant.get('edu_object_type')} eq 'Student' and #{Constant.get('edu_school_id')} eq '#{school_number}'"
      }
      _query.merge!({"$skiptoken" => skiptoken}) if skiptoken
      graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        resource_name: 'users',
        access_token: session[:gwn_access_token],
        query: _query
      })
    end
  end
end