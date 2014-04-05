# -*- encoding: utf-8 -*-
# stub: capistrano3-ext-puppetize 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano3-ext-puppetize"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Simply Business", "Peter M Souter", "Karl Anderson"]
  s.date = "2014-04-05"
  s.description = "Capistrano extension to run Puppet manifests contained in the application to be deployed"
  s.email = ["Karl.Anderson@propelr.net"]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Run Puppet manifests in a Capistrano deployment"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<capistrano-ext>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<capistrano-spec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, [">= 2.0.0"])
      s.add_dependency(%q<capistrano-ext>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<capistrano-spec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 2.0.0"])
    s.add_dependency(%q<capistrano-ext>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<capistrano-spec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
