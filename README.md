Usage and Installation
======================

In your Gemfile:
----------------

    gem 'omniauth-mindvalley', :git => 'git://github.com/mindvalley/omniauth-mindvalley.git'

In a file called oauth.yml in your config folder:
-------------------------------------------------

    production:
      mindvalley:
        consumer_key: your_production_key
        consumer_secret: your_production_secret

    development:
      mindvalley:
        consumer_key: your_development_key
        consumer_secret: your_development_secret


In an initializer:
------------------

    OAUTH = YAML.load_file(File.join(Rails.root, "config", "oauth.yml"))

    # load all the possible oauth strategies
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :mindvalley, OAUTH[Rails.env]['mindvalley']['consumer_key'],
        OAUTH[Rails.env]['mindvalley']['consumer_secret']
    end

