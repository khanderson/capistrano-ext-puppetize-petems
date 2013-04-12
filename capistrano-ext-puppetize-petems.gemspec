$:.push File.expand_path("../lib", __FILE__)

require 'capistrano/ext/puppetize/version'

Gem::Specification.new do |spec|
  spec.name = 'capistrano-ext-puppetize-petems'
  spec.version = Capistrano::Ext::Puppetize::Version::STRING
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Peter M Souter']
  spec.email = ['p.morsou@gmail.com']
  spec.summary = 'Run Puppet manifests in a Capistrano deployment'
  spec.description = 'Capistrano extension to run Puppet manifests contained in the application to be deployed'
  spec.license = 'MIT'

  spec.add_dependency 'capistrano', '>=2.0.0'
  spec.add_dependency 'capistrano-ext'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capistrano-spec'

  spec.require_path = 'lib'
end
