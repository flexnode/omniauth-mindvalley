# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-mindvalley/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '>= 1.2'
  gem.add_dependency 'omniauth', '>= 1'
  gem.add_dependency 'omniauth-oauth2', '>= 1'

  gem.authors = ["Tristan Gomez"]
  gem.email = ["tristan@mindvalley.com"]
  gem.description = %q{An OmniAuth strategy for a Mindvalley account (shamelessly stolen from https://github.com/ZenCocoon/omniauth-testoauth2strategy).}
  gem.summary = %q{n An OmniAuth strategy for a Mindvalley account.}
  gem.homepage = "https://github.com/mindvalley/omniauth-mindvalley"

  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name = "omniauth-mindvalley"
  gem.require_paths = ["lib"]
  gem.version = OmniAuth::Mindvalley::VERSION
end
