source 'https://rubygems.org'

gem "bundler", "> 1"
if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  gem "rake", "~> 11.1"
else
  gem "rake", "< 11.0"
end

gem 'elastic-api',        :path => File.expand_path("../elastic-api", __FILE__),        :require => false
gem 'elastic-transport',  :path => File.expand_path("../elastic-transport", __FILE__),  :require => false
gem 'elastic-extensions', :path => File.expand_path("../elastic-extensions", __FILE__), :require => false
gem 'elastic',            :path => File.expand_path("../elastic", __FILE__),            :require => false

gem "pry"
gem "ansi"
gem "shoulda-context"
gem "mocha"
gem "turn"
gem "yard"
gem "ci_reporter", "~> 1.9"

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  gem "ruby-prof"    unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  gem "require-prof" unless defined?(JRUBY_VERSION) || defined?(Rubinius)
  gem "simplecov"
  gem "simplecov-rcov"
  gem "cane"
end

if defined?(RUBY_VERSION) && RUBY_VERSION > '2.2'
  gem "test-unit", '~> 2'
end
