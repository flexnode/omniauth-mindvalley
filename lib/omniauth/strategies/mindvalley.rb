require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mindvalley < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => "http://localhost:3002",
        :authorize_path => "/oauth/authorize"
      }

      uid { user_info["response"]["id"] }

      info do
        {
          :id => user_info["response"]["id"],
          :email => user_info["response"]["email"],
          :first_name => user_info["response"]['first_name'],
          :last_name => user_info["response"]['last_name']
          # and anything else you want to return to your API consumers
        }
      end

      def user_info
        @user_info ||= access_token.get('/client_api/1/profile').parsed
      end

      def session_info
        access_token.post('/sso/session', {:id => uid })
      end
    end
  end
end
