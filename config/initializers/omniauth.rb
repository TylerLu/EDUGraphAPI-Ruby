module OmniAuth
  module Strategies
    autoload :AzureOAuth2, Rails.root.join('lib', 'omniauth', 'strategies', 'azure_oauth2') 
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :AzureOAuth2, {
    client_id: Settings.edu_graph_api.app_id, 
    client_secret: Settings.edu_graph_api.default_key, 
    provider_ignores_state: true,
    callback_paths: [ 
      '/auth/azure_oauth2/callback',
      '/link/azure_oauth2/callback',
      '/admin'
    ]
  }
end