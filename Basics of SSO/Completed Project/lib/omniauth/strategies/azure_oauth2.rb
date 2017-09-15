require 'omniauth/strategies/oauth2'
require 'jwt'

module OmniAuth
  module Strategies

    class AzureOAuth2 < OmniAuth::Strategies::OAuth2

      BASE_AZURE_URL = 'https://login.microsoftonline.com'

      option :name, 'azure_oauth2'
      option :tenant_id, 'common'
      option :resource, 'https://graph.windows.net'
      option :callback_paths, []

      args [:tenant_id]

      def client
        
        options.client_id = options.client_id
        options.client_secret = options.client_secret
        options.tenant_id = options.tenant_id

        options.callback_path = request.params['callback_path'] if request.params['callback_path']

        options.authorize_params.prompt = request.params['prompt'] if request.params['prompt']
        options.authorize_params.login_hint = request.params['login_hint'] if request.params['login_hint']   

        options.client_options.authorize_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/authorize"
        options.client_options.token_url = "#{BASE_AZURE_URL}/#{options.tenant_id}/oauth2/token"

        options.token_params.resource = options.resource

        super
      end

      uid {
        raw_info['sub']
      }

      info do
        {
          name: raw_info['name'],
          nickname: raw_info['unique_name'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
          email: raw_info['email'] || raw_info['upn'],
          oid: raw_info['oid'],
          tid: raw_info['tid']
        }
      end

      def callback_url
        full_host + script_name + callback_path
      end

      def raw_info
        # it's all here in JWT http://msdn.microsoft.com/en-us/library/azure/dn195587.aspx
        @raw_info ||= ::JWT.decode(access_token.token, nil, false).first
      end

      def on_callback_path?
        options[:callback_paths].include? current_path or super
      end

      protected

      def build_access_token
        options.callback_path = current_path
        super
      end

      def ssl?
        request.env['HTTP_X_ARR_SSL'] || super
      end

    end
  end
end