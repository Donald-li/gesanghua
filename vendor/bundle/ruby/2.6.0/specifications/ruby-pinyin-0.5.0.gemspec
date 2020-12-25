# -*- encoding: utf-8 -*-
# stub: ruby-pinyin 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-pinyin".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Xie".freeze]
  s.date = "2016-04-21"
  s.description = "Pinyin is a romanization system (phonemic notation) of Chinese characters, this gem helps you to convert Chinese characters into pinyin form.".freeze
  s.email = ["jan.h.xie@gmail.com".freeze]
  s.homepage = "https://github.com/janx/ruby-pinyin".freeze
  s.licenses = ["BSD".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "Convert Chinese characters into pinyin.".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rmmseg-cpp-new>.freeze, ["~> 0.3.1"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.4"])
    else
      s.add_dependency(%q<rmmseg-cpp-new>.freeze, ["~> 0.3.1"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.4"])
    end
  else
    s.add_dependency(%q<rmmseg-cpp-new>.freeze, ["~> 0.3.1"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.4"])
  end
end
