# -*- encoding: utf-8 -*-
# stub: second_level_cache 2.3.3 ruby lib

Gem::Specification.new do |s|
  s.name = "second_level_cache".freeze
  s.version = "2.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Hooopo".freeze]
  s.date = "2017-04-28"
  s.description = "Write Through and Read Through caching library inspired by CacheMoney and cache_fu, support  ActiveRecord 4.".freeze
  s.email = ["hoooopo@gmail.com".freeze]
  s.homepage = "https://github.com/hooopo/second_level_cache".freeze
  s.rubygems_version = "3.0.9".freeze
  s.summary = "SecondLevelCache is a write-through and read-through caching library inspired by Cache Money and cache_fu, support only Rails3 and ActiveRecord.  Read-Through: Queries by ID, like current_user.articles.find(params[:id]), will first look in cache store and then look in the database for the results of that query. If there is a cache miss, it will populate the cache.  Write-Through: As objects are created, updated, and deleted, all of the caches are automatically kept up-to-date and coherent.".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.0.0", "< 5.2"])
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.0.0", "< 5.2"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 1.3.0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 5.0.0", "< 5.2"])
      s.add_dependency(%q<activerecord>.freeze, [">= 5.0.0", "< 5.2"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.3.0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 5.0.0", "< 5.2"])
    s.add_dependency(%q<activerecord>.freeze, [">= 5.0.0", "< 5.2"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.3.0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
  end
end
