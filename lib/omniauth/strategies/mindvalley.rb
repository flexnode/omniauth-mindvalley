require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Mindvalley < OmniAuth::Strategies::OAuth2
      option :client_options, {
               :site => endpoint,
               :authorize_path => "/oauth/authorize"
             }

      def self.endpoint
        if ENV['OMNIAUTH_SSO_ENDPOINT'].to_s != ''
          ENV['OMNIAUTH_SSO_ENDPOINT'].to_s
        elsif development_environment?
          ENV['OMNIAUTH_SSO_ENDPOINT'] || 'http://localhost:3002'
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
          '/oauth/sso/v1/passports'
        end
      end


      def self.passports_path
        if ENV['OMNIAUTH_SSO_PASSPORTS_PATH'].to_s != ''
          ENV['OMNIAUTH_SSO_PASSPORTS_PATH'].to_s
        else
          # We know this namespace is not occupied because /oauth is owned by Doorkeeper
          '/oauth/sso/v1/passports'
        end
      end

      option :name, :mindvalley

      uid { raw_info['id'] if raw_info }

      info do
        {
          :email => raw_info["response"]["email"],
          :first_name => raw_info["response"]['first_name'],
          :last_name => raw_info["response"]['last_name'],
          # and anything else you want to return to your API consumers

          # Passport
          id:     uid,
          state:  raw_info['state'],
          secret: raw_info['secret'],
          user:   raw_info['user']
        }
      end

      def raw_info
        params = { ip: request.ip, agent: request.user_agent }
        @raw_info ||= access_token.get('/client_api/1/profile').parsed
      end
    end
  end
end
