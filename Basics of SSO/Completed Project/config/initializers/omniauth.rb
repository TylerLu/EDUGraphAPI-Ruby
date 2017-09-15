module OmniAuth
  module Strategies
    autoload :AzureOAuth2, Rails.root.join('lib', 'omniauth', 'strategies', 'azure_oauth2') 
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :AzureOAuth2, {
    client_id: Settings.AAD.ClientId, 
    client_secret: Settings.AAD.ClientSecret, 
    provider_ignores_state: true,
    callback_paths: [ 
      '/auth/azure_oauth2/callback'
    ]
  }
end