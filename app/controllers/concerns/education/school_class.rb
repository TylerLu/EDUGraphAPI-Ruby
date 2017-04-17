
module Education::SchoolClass
  attr_accessor :myclasses
  attr_accessor :graph

  def get_my_classes_by_school_number(school_number)
    self.myclasses ||= if session[:current_user][:school_number] == school_number
      graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        access_token: session[:gwn_access_token],
        resource_name: "users/#{cookies[:o365_login_email]}/memberOf"
      })['value'].select{|_class| _class['objectType'] == 'Group' }
    else
      []
    end
  end

  def get_my_cleasses_teacher_mapping
    class_teacher_mapping = {}
    self.myclasses.each do |_class|
      res = graph_request({
        host: Settings.host.gwn,
        tenant_name: Settings.tenant_name,
        access_token: session[:gwn_access_token],
        resource_name: "groups/#{_class["objectId"]}",
        query: {
          "$expand" => "members"
        }
      })
      _teacher = res['members'].select do |_member|
        _member[Constant.get(:edu_object_type)] == "Teacher"
      end.first

      class_teacher_mapping[res['objectId'].to_s] = _teacher['displayName']
    end
    class_teacher_mapping
  end

  def get_classes_by_school_number(school_number, skip_token = nil)
    _query = {
      "$top" => 12,
      "$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
    }
    _query.merge!({"$skiptoken" => skip_token}) if skip_token

    graph_request({
      host: Settings.host.gwn,
      tenant_name: Settings.tenant_name,
      resource_name: 'groups',
      access_token: session[:gwn_access_token],
      query: _query
    })
  end

  def get_conversations_by_class_id(class_id)
    get_graph.groups.find(class_id).conversations rescue []
  end

  def get_class_info(class_id)
    graph_request({
      host: Settings.host.gwn,
      tenant_name: Settings.tenant_name,
      resource_name: "groups/#{class_id}",
      access_token: session[:gwn_access_token]
    })
  end

  def get_class_members(class_id)
    graph_request({
      host: Settings.host.gwn,
      tenant_name: Settings.tenant_name,
      resource_name: "groups/#{class_id}/$links/members",
      access_token: session[:gwn_access_token]
    })
  end

  def get_documents_by_class_id(class_id)
    get_graph.groups.find(class_id).drive.root.children rescue []
  end

  private
  def get_graph
    self.graph ||= graph_request({
      host: Settings.host.gmc,
      access_token: session[:gmc_access_token]
    })
  end
end
