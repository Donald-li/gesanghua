# -*- encoding: utf-8 -*-
# stub: wx_pay 0.21.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wx_pay".freeze
  s.version = "0.21.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jasl".freeze]
  s.date = "2020-07-23"
  s.description = "An unofficial simple wechat pay gem".freeze
  s.email = ["jasl9187@hotmail.com".freeze]
  s.homepage = "https://github.com/jasl/wx_pay".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "An unofficial simple wechat pay gem".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 2.0.0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.2"])
      s.add_development_dependency(%q<rake>.freeze, [">= 12.3.3"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5"])
    else
      s.add_dependency(%q<rest-client>.freeze, [">= 2.0.0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 3.2"])
      s.add_dependency(%q<rake>.freeze, [">= 12.3.3"])
      s.add_dependency(%q<webmock>.freeze, ["~> 2.3"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5"])
    end
  else
    s.add_dependency(%q<rest-client>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 3.2"])
    s.add_dependency(%q<rake>.freeze, [">= 12.3.3"])
    s.add_dependency(%q<webmock>.freeze, ["~> 2.3"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5"])
  end
end
