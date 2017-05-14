class RESTService

  attr_accessor :access_token
  attr_accessor :baseUrl


  def get_object(path, options, klass)
    request_object(:get, path, options, klass)
  end

  def get_objects(path, options, klass)
    request_objects(:get, path, options, klass)
  end

  def get_array(path)
    request_array(:get, path)
  end

  def post_object(path, options, klass)
    request_object(:post, path, options, klass)
  end

  def put_object(path, options, klass)
    request_object(:put, path, options, klass)
  end

  def delete_object(path, options, klass)
    request_object(:delete, path, options, klass)
  end

  def request_object(request_method, path, options, klass)
    response = request(request_method, path)
    klass.new(response)
  end

  def request_objects(request_method, path, options, klass)
    response_array = request(request_method, path) || []
    response_array.collect do |element|
      klass.new(element)
    end
  end

  def request_array(request_method, path)
    request(request_method, path) || []
  end

  def request(request_method, path, options, klass)
    response = HTTParty.method(request_method).call(
      baseUrl + path,
      query: options.query,
      body: options.body,
      headers: {
        "Authorization" => "Bearer #{row[:access_token]}",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    ).body
    json = JSON.par

  end

  # def request(request_method, path, options)
  #   response = HTTParty.method(request_method).call(
  #     baseUrl + path,
  #     query: options.query,
  #     body: options.body,
  #     headers: {
  #       "Authorization" => "Bearer #{row[:access_token]}",
  #       "Content-Type" => "application/x-www-form-urlencoded"
  #     }
  #   )
  #   # if response.code != 
  #   request.body
  # end

end