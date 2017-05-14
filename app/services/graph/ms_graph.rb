
module Graph
  class MSGraph

    attr_accessor :mc_token
    attr_accessor :mc_graph
    attr_accessor :tenant_name

    def initialize(mc_token, tenant_name)
      self.mc_token = mc_token
      self.mc_graph = graph_request({
        host: Constant::Resource::MSGraph,
        access_token: mc_token
      })
      self.tenant_name = tenant_name
    end

    def graph_request(row = {})
      callback = Proc.new { |r| r.headers["Authorization"] = "Bearer #{row[:access_token]}" }

      return MicrosoftGraph.new(
        base_url: "#{row[:host]}/v#{row[:api_version] || '1.0'}",
        cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, "metadata_v1.0.xml"),
        &callback
      )
    end

    def get_user_photo(objectId)
      HTTParty.get("https://graph.microsoft.com/v1.0/users/#{objectId}/photo/$value", headers: {
        "Authorization" => "Bearer #{self.mc_token}",
        "Content-Type" => "application/x-www-form-urlencoded"
      }).body
    end


  end
end

