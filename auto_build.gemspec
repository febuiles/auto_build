$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auto_build/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auto_build"
  s.version     = AutoBuild::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AutoBuild."
  s.description = "TODO: Description of AutoBuild."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
end
