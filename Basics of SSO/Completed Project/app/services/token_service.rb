class TokenService
    
  def initialize()
  end

  def cache_tokens(o365_user_id, resource, refresh_token, access_token, jwt_exp)
    cache = TokenCache.find_or_create_by(o365_userId: o365_user_id)
    cache.refresh_token = refresh_token
    access_tokens = cache.access_tokens ? JSON.parse(cache.access_tokens) : {}
    access_tokens[resource] = { 
      expiresOn: get_expires_on(jwt_exp), 
      value: access_token 
    }
    cache.access_tokens = access_tokens.to_json();
    cache.save();
  end

  def get_access_token(o365_user_id, resource)
    cache = TokenCache.find_by_o365_userId(o365_user_id)
    if !cache
      raise Exceptions::RefreshTokenError
    end
    # parse access_tokens
    access_tokens = JSON.parse(cache.access_tokens)
    access_token = access_tokens[resource]
    if access_token
      expires_on = DateTime.parse(access_token['expiresOn'])
      utc_now = DateTime.now.new_offset(0)
      if utc_now < expires_on - 5.0 / 60 / 24
        return access_token['value']
      end
    end
    # refresh token and cache
    auth_result = refresh_token(cache.refresh_token, resource)
    access_tokens[resource] = { 
      expiresOn: get_expires_on(auth_result.expires_on), 
      value: auth_result.access_token }
    cache.access_tokens = access_tokens.to_json()
    cache.refresh_token = auth_result.refresh_token
    cache.save()
    #
    return auth_result.access_token;
  end

  def clear_token_cache
    caches = TokenCache.all();
    caches.each do |cache|
      cache.destroy()
    end
  end

  private def refresh_token(refresh_token, resource)
		authentication_context = ADAL::AuthenticationContext.new
		client_credential = ADAL::ClientCredential.new(Settings.AAD.ClientId, Settings.AAD.ClientSecret)
    begin
       authentication_context.acquire_token_with_refresh_token(refresh_token, client_credential, resource)
    rescue
      raise Exceptions::RefreshTokenError
    end
  end

  private def get_expires_on(jwt_exp)
    return DateTime.new(1970, 1, 1) + jwt_exp * 1.0 / (60 * 60 * 24)
  end

end