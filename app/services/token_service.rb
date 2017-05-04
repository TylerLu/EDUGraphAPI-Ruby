
class TokenService
  attr_accessor :token_obj

  def initialize(o365_user_id)
    if o365_user_id.present? && token_obj.blank?
      _token = Token.find_by_o365_userId(o365_user_id)
      if !_token
        _token = Token.new
        _token.o365_userId = o365_user_id
        _token.access_tokens = {}.to_json
        _token.save
      end

      self.token_obj = _token
    end
  end

  def get_refresh_token
    token_obj.refresh_token
  end

  def set_refresh_token(refresh_token)
    token_obj.refresh_token = refresh_token
    token_obj.save
  end

  def get_expires_on
    tokens = JSON.parse(token_obj.access_tokens)
    return tokens[Constant::Resource::AADGraph]["expiresOn"] rescue nil
  end

  def get_aad_token
    tokens = JSON.parse(token_obj.access_tokens)
    return tokens[Constant::Resource::AADGraph]["value"] rescue ''
  end

  def set_aad_token(aad_token, expires_on)
    _to = JSON.parse(token_obj.access_tokens)
    _to[Constant::Resource::AADGraph] = {"expiresOn" => expires_on, "value" => aad_token}
    token_obj.access_tokens = _to.to_json
    token_obj.save
  end

  def get_ms_token
    tokens = JSON.parse(token_obj.access_tokens)
    return tokens[Constant::Resource::MSGraph]["value"] rescue ''
  end

  def set_ms_token(ms_token, expires_on)
    _to = JSON.parse(token_obj.access_tokens)
    _to[Constant::Resource::MSGraph] = {"expiresOn" => expires_on, "value" => ms_token}
    token_obj.access_tokens = _to.to_json
    token_obj.save
  end
end
