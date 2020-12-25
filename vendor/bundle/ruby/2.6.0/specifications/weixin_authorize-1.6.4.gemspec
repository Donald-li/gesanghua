# -*- encoding: utf-8 -*-
# stub: weixin_authorize 1.6.4 ruby lib

Gem::Specification.new do |s|
  s.name = "weixin_authorize".freeze
  s.version = "1.6.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["lanrion".freeze]
  s.date = "2015-12-25"
  s.description = "weixin api authorize access_token".freeze
  s.email = ["huaitao-deng@foxmail.com".freeze]
  s.homepage = "https://github.com/lanrion/weixin_authorize".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.9".freeze
  s.summary = "weixin api authorize access_token".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
      s.add_runtime_dependency(%q<redis>.freeze, [">= 3.1.0"])
      s.add_runtime_dependency(%q<carrierwave>.freeze, [">= 0.10.0"])
      s.add_runtime_dependency(%q<mini_magick>.freeze, [">= 3.7.0"])
      s.add_runtime_dependency(%q<yajl-ruby>.freeze, [">= 1.2.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<redis-namespace>.freeze, [">= 0"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
      s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8.2"])
      s.add_development_dependency(%q<pry-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
      s.add_dependency(%q<redis>.freeze, [">= 3.1.0"])
      s.add_dependency(%q<carrierwave>.freeze, [">= 0.10.0"])
      s.add_dependency(%q<mini_magick>.freeze, [">= 3.7.0"])
      s.add_dependency(%q<yajl-ruby>.freeze, [">= 1.2.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<redis-namespace>.freeze, [">= 0"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
      s.add_dependency(%q<coveralls>.freeze, ["~> 0.8.2"])
      s.add_dependency(%q<pry-rails>.freeze, [">= 0"])
      s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
    s.add_dependency(%q<redis>.freeze, [">= 3.1.0"])
    s.add_dependency(%q<carrierwave>.freeze, [">= 0.10.0"])
    s.add_dependency(%q<mini_magick>.freeze, [">= 3.7.0"])
    s.add_dependency(%q<yajl-ruby>.freeze, [">= 1.2.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<redis-namespace>.freeze, [">= 0"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.10.0"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8.2"])
    s.add_dependency(%q<pry-rails>.freeze, [">= 0"])
    s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
  end
end
