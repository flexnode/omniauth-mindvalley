require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mindvalley < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => "http://localhost:3002",
        :authorize_path => "/oauth/authorize"
      }

      uid { raw_info["response"]["id"] }

      info do
        {
          :email => raw_info["response"]["email"],
          :first_name => raw_info["response"]['first_name'],
          :last_name => raw_info["response"]['last_name']
          # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/client_api/1/profile').parsed
      end
    end
  end
end
