
module Education
  def graph_request(row = {})
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
  end
end