# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "render_csv"
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Brown"]
  s.date = "2014-03-26"
  s.description = "Adds a custom CSV renderer to Rails applications"
  s.email = ["github@lette.us"]
  s.homepage = "http://github.com/beerlington/render_csv"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Adds a custom CSV renderer to Rails applications"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 2.12"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3"])
      s.add_development_dependency(%q<json>, [">= 1.6"])
    else
      s.add_dependency(%q<rails>, [">= 3.0"])
      s.add_dependency(%q<rspec-rails>, [">= 2.12"])
      s.add_dependency(%q<sqlite3>, [">= 1.3"])
      s.add_dependency(%q<json>, [">= 1.6"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0"])
    s.add_dependency(%q<rspec-rails>, [">= 2.12"])
    s.add_dependency(%q<sqlite3>, [">= 1.3"])
    s.add_dependency(%q<json>, [">= 1.6"])
  end
end
