# -*- encoding: utf-8 -*-
# stub: migration_comments 0.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "migration_comments".freeze
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pinny".freeze]
  s.date = "2016-05-31"
  s.description = "Add schema comments in your migrations, see them in model annotations and db/schema.rb dump".freeze
  s.email = ["pinny@mwitz.com".freeze]
  s.homepage = "https://github.com/pinnymz/migration_comments".freeze
  s.rubygems_version = "3.0.9".freeze
  s.summary = "Comments for your migrations".freeze

  s.installed_by_version = "3.0.9" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 4.2.0"])
      s.add_development_dependency(%q<annotate>.freeze, ["~> 2.7.0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest-byebug>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 4.2.0"])
      s.add_dependency(%q<annotate>.freeze, ["~> 2.7.0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<mysql2>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<minitest-byebug>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 4.2.0"])
    s.add_dependency(%q<annotate>.freeze, ["~> 2.7.0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<mysql2>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<minitest-byebug>.freeze, [">= 0"])
  end
end
