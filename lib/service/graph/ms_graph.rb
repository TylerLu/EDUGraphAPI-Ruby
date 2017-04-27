
module Service
  module Graph
    class MSGraph
      include GraphRequest

      attr_accessor :mc_token
      attr_accessor :mc_graph
      # attr_accessor :tenant_name

      def initialize(mc_token)
        self.mc_token = mc_token
        self.mc_graph = graph_request({
          host: Constant::Resource::MSGraph,
          access_token: mc_token
        })
      end

      def get_user_photo(objectId)
        HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
          "Authorization" => "Bearer #{self.mc_token}",
          "Content-Type" => "application/x-www-form-urlencoded"
        }).body
      end

      def get_conversations_by_class_id(class_id)
        self.mc_graph.groups.find(class_id).conversations rescue []
      end

      def get_documents_by_class_id(class_id)
        self.mc_graph.groups.find(class_id).drive.root.children rescue []
      end
    end
  end
end
