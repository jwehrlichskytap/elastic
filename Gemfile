source 'https://rubygems.org'

gem "bundler", "> 1"
if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  gem "rake", "~> 11.1"
else
  gem "rake", "< 11.0"
end

gem 'skytap_elastic-api',        :path => File.expand_path("../skytap_elastic-api", __FILE__),        :require => false
gem 'skytap_elastic-transport',  :path => File.expand_path("../skytap_elastic-transport", __FILE__),  :require => false
gem 'skytap_elastic-extensions', :path => File.expand_path("../skytap_elastic-extensions", __FILE__), :require => false
gem 'skytap_elastic',            :path => File.expand_path("../skytap_elastic", __FILE__),            :require => false

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
