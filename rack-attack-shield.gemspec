lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/attack/shield/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-attack-shield'
  spec.version       = Rack::Attack::Shield::VERSION
  spec.authors       = ['Matthias Grosser']
  spec.email         = ['mtgrosser@gmx.net']

  spec.summary       = 'Block and unblock evil requests'
  spec.description   = 'Plugin for rack-attack to block and unblock evil requests'
  spec.homepage      = 'https://github.com/mtgrosser/rack-attack-shield'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{lib,templates}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
