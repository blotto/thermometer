$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "thermometer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "thermometer"
  s.version     = Thermometer::VERSION
  s.authors     = ["Nick Newell"]
  s.email       = ["blotto@gmail.com"]
  s.homepage    = "https://gitlab.com/u/blotto"
  s.summary     = "Thermometer measures heat on your ActiveRecord Models."
  s.description = "Thermometer measures heat on your ActiveRecord Models.  This initial release is for Rails 4, not yet tested for Rails 3"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0"

  s.add_development_dependency "sqlite3"
end
