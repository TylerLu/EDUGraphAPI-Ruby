
module Service
  module Graph
    class AADGraph
      include GraphRequest

      attr_accessor :aad_token
      attr_accessor :roles
      attr_accessor :me
      attr_accessor :tenant_name

      def initialize(aad_token, tenant_name)
        self.aad_token = aad_token
        self.tenant_name = tenant_name
      end

      def get_resource(resource_name)
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          access_token: aad_token,
          resource_name: resource_name
        })
      end

      def get_service_principals(app_id)
        res = graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'servicePrincipals',
          access_token: aad_token,
          query: {
            "$filter" => "appId eq '#{app_id}'"
          }
        })
        res['value']
      end

      def delete_service_principals(object_id)
        graph_request({
          http_method: 'delete',
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: "servicePrincipals/#{object_id}",
          access_token: aad_token,
        })
      end

      def get_app_role_assignments
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'users',
          api_version: '1.5',
          access_token: aad_token,
          query: {
            "$expand" => "appRoleAssignments"
          }
        })
      end

      def set_app_role_assignments(user_id, resourceId, principalId)
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: "users/#{user_id}/appRoleAssignments",
          api_version: '1.5',
          body: {
            "resourceId" => resourceId,
            "principalId" => principalId
          }.to_json
        })
      end

      def get_current_user
        self.me ||= graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'me',
          access_token: aad_token
        })
      end

      def get_administrative_units
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'administrativeUnits',
          access_token: aad_token
        })['value']
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

      def get_user_classes(id_or_email)
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          access_token: aad_token,
          resource_name: "users/#{id_or_email}/memberOf"
        })['value'].select{|_class| _class['objectType'] == 'Group' }
      end

      def get_classes_with_members(object_id)
        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          access_token: aad_token,
          resource_name: "groups/#{object_id}",
          query: {
            "$expand" => "members"
          }
        })
      end

      def get_classes_by_school_number(school_number, skip_token = nil)
        _query = {
          "$top" => 12,
          "$filter" => "#{Constant.get(:edu_object_type)} eq 'Section' and #{Constant.get(:edu_school_id)} eq '#{school_number}'"
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

      def get_users(school_number, role: nil, skiptoken: nil)
        _query = {
          "$top" => 12,
          "$filter" => "#{Constant.get('edu_school_id')} eq '#{school_number}'"
        }
        _query.merge!({"$skiptoken" => skiptoken}) if skiptoken
        _query.merge!({"$filter" => "#{Constant.get('edu_object_type')} eq '#{role}' and #{Constant.get('edu_school_id')} eq '#{school_number}'"}) if role

        graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'users',
          access_token: aad_token,
          query: _query
        })
      end

      def get_roles
        return self.roles if self.roles.present?
        self.roles = []
        if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:teacher_sku_id) || _['skuId'] == Constant.get(:teacher_pro_sku_id) }
          self.roles << 'Teacher'
        end

        if get_current_user['assignedLicenses'].find{|_| _['skuId'] == Constant.get(:student_sku_id) || _['skuId'] == Constant.get(:student_pro_sku_id) }
          self.roles << 'Student'
        end

        myroles = graph_request({
          host: Constant::Resource::AADGraph,
          tenant_name: self.tenant_name,
          resource_name: 'directoryRoles',
          access_token: self.aad_token,
          query: {
            "$expand" => 'members'
          }
        })['value'].select{|_| _['displayName'] == Constant.get(:aad_company_admin_role_name) }

        myroles.each do |_role|
          if _role['members'].find{|_| _['objectId'] == get_current_user['objectId'] }
            self.roles << 'Admin'
          end
        end

        return self.roles
      end
    end
  end
end