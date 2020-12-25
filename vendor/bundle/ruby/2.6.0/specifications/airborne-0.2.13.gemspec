# -*- encoding: utf-8 -*-
# stub: airborne 0.2.13 ruby lib

Gem::Specification.new do |s|
  s.name = "airborne".freeze
  s.version = "0.2.13"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alex Friedman".freeze, "Seth Pollack".freeze]
  s.date = "2017-05-24"
  s.email = ["a.friedman07@gmail.com".freeze, "seth@sethpollack.net".freeze]
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "RSpec driven API testing framework".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["< 3.0", ">= 1.7.3"])
      s.add_runtime_dependency(%q<rack-test>.freeze, ["~> 0.6", ">= 0.6.2"])
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 0"])
    else
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_dependency(%q<rest-client>.freeze, ["< 3.0", ">= 1.7.3"])
      s.add_dependency(%q<rack-test>.freeze, ["~> 0.6", ">= 0.6.2"])
      s.add_dependency(%q<rack>.freeze, [">= 0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, ["~> 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
    s.add_dependency(%q<rest-client>.freeze, ["< 3.0", ">= 1.7.3"])
    s.add_dependency(%q<rack-test>.freeze, ["~> 0.6", ">= 0.6.2"])
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, ["~> 0"])
  end
end
