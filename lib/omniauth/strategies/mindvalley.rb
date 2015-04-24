require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mindvalley < OmniAuth::Strategies::OAuth2
      option :client_options, {
               :site => "http://localhost:3002",
               :authorize_path => "/oauth/authorize"
             }


      def self.endpoint
        if ENV['OMNIAUTH_SSO_ENDPOINT'].to_s != ''
          ENV['OMNIAUTH_SSO_ENDPOINT'].to_s
        elsif development_environment?
          ENV['OMNIAUTH_SSO_ENDPOINT'] || 'http://localhost:3000'
        elsif test_environment?
          'https://sso.example.com'
        else
          fail 'You must set OMNIAUTH_SSO_ENDPOINT to point to the SSO OAuth server'
        end
      end


      def self.development_environment?
        defined?(Rails) && Rails.env.development?
      end

      def self.test_environment?
        defined?(Rails) && Rails.env.test? || ENV['RACK_ENV'] == 'test'
      end

      def self.passports_path
        if ENV['OMNIAUTH_SSO_PASSPORTS_PATH'].to_s != ''
          ENV['OMNIAUTH_SSO_PASSPORTS_PATH'].to_s
        else
          # We know this namespace is not occupied because /oauth is owned by Doorkeeper
          #'/oauth/sso/v1/passports'
          '/oauth/authorize'
        end
      end



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
