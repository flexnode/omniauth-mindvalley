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
          :last_name => user_info["response"]['last_name'],
          :sso => {
            :id => session_info["id"],
            :secret => session_info["secret"]
          }
          # and anything else you want to return to your API consumers
        }
      end

      def user_info
        @user_info ||= access_token.get('/client_api/1/profile').parsed
      end

      def session_info
        params = { ip: request.ip, agent: request.user_agent }
        @session_info ||= access_token.post('/sso/sessions', params: params).parsed
      end
    end
  end
end
