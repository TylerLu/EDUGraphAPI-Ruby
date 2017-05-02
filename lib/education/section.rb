
module Education
  class Section
    include Education
    
    attr_accessor :myclasses
    attr_accessor :school_number
    attr_accessor :tenant_name
    attr_accessor :aad_token

    def initialize(tenant_name, token, school_number)
      self.tenant_name = tenant_name
      self.aad_token = token
      self.school_number = school_number
    end

    def get_my_classes_by_school_number(current_user)
      self.myclasses ||= if current_user[:school_number] == school_number
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          access_token: aad_token,
          resource_name: "users/#{current_user[:o365_email]}/memberOf"
        })['value'].select{|_class| _class['objectType'] == 'Group' }
      else
        []
      end
    end

    def get_class_info(class_id)
      graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: "groups/#{class_id}",
        access_token: aad_token
      })
    end

    def get_class_members(class_id)
      graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: "groups/#{class_id}/$links/members",
        access_token: aad_token
      })
    end

    # def get_conversations_by_class_id(class_id)
    #   self.graph.get_conversations_by_class_id(class_id)
    # end

    # def get_documents_by_class_id(class_id)
    #   self.graph.get_documents_by_class_id(class_id)
    # end

    def get_classes_by_school_number(skip_token = nil)
      _query = {
        "$top" => 12,
        "$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{self.school_number}'"
      }
      _query.merge!({"$skiptoken" => skip_token}) if skip_token

      graph_request({
        host: Constant::Resource::AADGraph,
        tenant_name: self.tenant_name,
        resource_name: 'groups',
        access_token: aad_token,
        query: _query
      })
    end

    def get_my_cleasses_teacher_mapping
      class_teacher_mapping = {}
      (self.myclasses || get_my_classes_by_school_number(self.school_number)).each do |_class|
        res = graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          access_token: aad_token,
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
  end
end
