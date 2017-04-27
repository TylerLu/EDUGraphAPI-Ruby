module Service
  class Admin
    attr_accessor :graph
    
    def initialize(graph)
      self.graph = graph
    end

    def get_service_principals(app_id)
      self.graph.get_service_principals(app_id)
    end

    def delete_service_principals(object_id)
      self.graph.delete_service_principals(object_id)
    end

    def get_app_role_assignments
      self.graph.get_app_role_assignments
    end

    def set_app_role_assignments(user_id, resourceId, principalId)
      self.graph.set_app_role_assignments(user_id, resourceId, principalId)
    end
  end
end