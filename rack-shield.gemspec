require_relative 'lib/rack/shield/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-shield'
  spec.version       = Rack::Shield::VERSION
  spec.authors       = ['Matthias Grosser']
  spec.email         = ['mtgrosser@gmx.net']

  spec.summary       = 'Block and unblock evil requests'
  spec.description   = 'Plugin for rack-attack to block and unblock evil requests'
  spec.homepage      = 'https://github.com/mtgrosser/rack-shield'
  spec.licenses      = ['MIT']

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{lib,templates}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']

  spec.require_paths = ['lib']

  spec.add_dependency 'rack-attack'
end
