Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :azure_activedirectory, Settings.edu_graph_api.app_id, 'common'
  provider :azure_oauth2, 
    { client_id: Settings.edu_graph_api.app_id, 
      client_secret: Settings.edu_graph_api.default_key, provider_ignores_state: true }
  
end