# -*- encoding: utf-8 -*-
# stub: rucaptcha 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rucaptcha".freeze
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jason Lee".freeze]
  s.date = "2016-12-01"
  s.email = "huacnlee@gmail.com".freeze
  s.homepage = "https://github.com/huacnlee/rucaptcha".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.0.9".freeze
  s.summary = "This is a Captcha gem for Rails Application. It run ImageMagick command to draw Captcha image.".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.2"])
    else
      s.add_dependency(%q<railties>.freeze, [">= 3.2"])
    end
  else
    s.add_dependency(%q<railties>.freeze, [">= 3.2"])
  end
end
