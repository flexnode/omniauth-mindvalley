require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Mindvalley < OmniAuth::Strategies::OAuth2
      case Rails.env
      when 'production'
        option :client_options, {
          :site => 'http://accounts.mindvalley.com',
          :authorize_url => 'http://accounts.mindvalley.com/oauth/authorize',
          :token_url => 'http://accounts.mindvalley.com/oauth/token'
        }
      else
        option :client_options, {
          :site => 'http://0.0.0.0:3000',
          :authorize_url => 'http://0.0.0.0:3000/oauth/authorize',
          :token_url => 'http://0.0.0.0:3000/oauth/token'
        }
      end

      uid { raw_info['id'] }

      info do
        {
          'email' => raw_info['email'],
          'first_name' => raw_info['first_name']
        }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('/me').body)
      end
    end
  end
end