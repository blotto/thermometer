source "https://rubygems.org"

# Declare your gem's dependencies in thermometer.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'



group :staging, :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'       # faker for fixtures
  gem 'squeel'      # easier model associations
  gem 'coveralls', require: false
end
