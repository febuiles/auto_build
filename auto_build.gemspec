$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "auto_build/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "auto_build"
  s.version     = AutoBuild::VERSION
  s.authors     = ["Federico Builes"]
  s.email       = ["federico.builes@gmail.com"]
  s.homepage    = "https://github.com/febuiles/auto_build"
  s.summary     = "Automatically initialize associations in Rails models"
  s.description = "Automatically initialize associations in Rails models"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.1.0"

  s.add_development_dependency "sqlite3"
end
