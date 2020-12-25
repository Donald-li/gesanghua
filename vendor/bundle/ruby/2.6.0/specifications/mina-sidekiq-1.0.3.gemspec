# -*- encoding: utf-8 -*-
# stub: mina-sidekiq 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mina-sidekiq".freeze
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Joerg Thalheim".freeze]
  s.date = "2017-11-05"
  s.description = "Adds tasks to aid in the deployment of Sidekiq".freeze
  s.email = ["joerg@higgsboson.tk".freeze]
  s.homepage = "http://github.com/Mic92/mina-sidekiq".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "Tasks to deploy Sidekiq with mina.".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mina>.freeze, [">= 1.0.2"])
      s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mina>.freeze, [">= 1.0.2"])
      s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mina>.freeze, [">= 1.0.2"])
    s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
  end
end
