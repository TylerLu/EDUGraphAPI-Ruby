module Service
  module Graph
    extend ActiveSupport::Autoload

    module GraphRequest
      def graph_request(row = {})
        if row[:host] == Constant::Resource::AADGraph
          return JSON.parse(
            HTTParty.method(row[:http_method] || 'get').call(
              "#{row[:host]}/#{row[:tenant_name]}/#{row[:resource_name]}?api-version=#{row[:api_version] || 'beta'}",
              query: row[:query] || {},
              body: row[:body] || {},
              headers: {
                "Authorization" => "Bearer #{row[:access_token]}",
                "Content-Type" => "application/x-www-form-urlencoded"
              }
            ).body
          ) rescue {}
        elsif row[:host] == Constant::Resource::MSGraph
          callback = Proc.new { |r| r.headers["Authorization"] = "Bearer #{row[:access_token]}" }

          return MicrosoftGraph.new(
            base_url: "#{row[:host]}/v#{row[:api_version] || '1.0'}",
            cached_metadata_file: File.join(MicrosoftGraph::CACHED_METADATA_DIRECTORY, "metadata_v1.0.xml"),
            &callback
          )
        end
      end
    end

    autoload :AADGraph
    autoload :MSGraph
  end
end