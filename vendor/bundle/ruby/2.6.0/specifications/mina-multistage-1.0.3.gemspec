# -*- encoding: utf-8 -*-
# stub: mina-multistage 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mina-multistage".freeze
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris".freeze]
  s.date = "2016-10-19"
  s.description = "Adds multistage capabilities to Mina".freeze
  s.email = ["Chris@WideEyeLabs.com".freeze]
  s.homepage = "http://endoze.github.io/mina-multistage/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "Adds multistage capabilities to Mina".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mina>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.3.5"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mina>.freeze, ["~> 1.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 1.3.5"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mina>.freeze, ["~> 1.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.3.5"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
