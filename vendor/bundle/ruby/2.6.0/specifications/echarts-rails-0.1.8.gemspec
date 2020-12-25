# -*- encoding: utf-8 -*-
# stub: echarts-rails 0.1.8 ruby lib

Gem::Specification.new do |s|
  s.name = "echarts-rails".freeze
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Echo Han".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-10-16"
  s.description = "Wrappers of ECharts Javascript Chart Libary for Rails 3.1+".freeze
  s.email = ["echohn@gmail.com".freeze]
  s.homepage = "https://github.com/echohn/echarts-rails".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "Wrappers of ECharts Javascript Chart Libary for Rails 3.1+".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.10"])
      s.add_development_dependency(%q<rails>.freeze, [">= 3.1"])
      s.add_development_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 1.10"])
      s.add_dependency(%q<rails>.freeze, [">= 3.1"])
      s.add_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 1.10"])
    s.add_dependency(%q<rails>.freeze, [">= 3.1"])
    s.add_dependency(%q<rake>.freeze, [">= 10.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
