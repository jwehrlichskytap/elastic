# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skytap_elastic/version'

Gem::Specification.new do |s|
  s.name          = "skytap_elastic"
  s.version       = SkytapElastic::VERSION
  s.authors       = ["Karel Minarik"]
  s.email         = ["karel.minarik@elastic.org"]
  s.summary       = "Ruby integrations for Elastic"
  s.homepage      = "http://github.com/elastic/skytap_elastic-ruby"
  s.license       = "Apache 2"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.extra_rdoc_files  = [ "README.md", "LICENSE.txt" ]
  s.rdoc_options      = [ "--charset=UTF-8" ]

  s.add_dependency "skytap_elastic-transport", '2.0.2'
  s.add_dependency "skytap_elastic-api",       '2.0.2'

  s.add_development_dependency "bundler", "> 1"

  if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
    s.add_development_dependency "rake", "~> 11.1"
  else
    s.add_development_dependency "rake", "< 11.0"
  end

  if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
    s.add_development_dependency "skytap_elastic-extensions"
  end

  s.add_development_dependency "ansi"
  s.add_development_dependency "shoulda-context"
  s.add_development_dependency "mocha"
  s.add_development_dependency "turn"
  s.add_development_dependency "yard"
  s.add_development_dependency "pry"
  s.add_development_dependency "ci_reporter", "~> 1.9"

  # Prevent unit test failures on Ruby 1.8
  if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
    s.add_development_dependency "test-unit", '~> 2'
    s.add_development_dependency "json"
  end

  if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
    s.add_development_dependency "minitest", "~> 4.0"
    s.add_development_dependency "ruby-prof" unless defined?(JRUBY_VERSION) || defined?(Rubinius)
    s.add_development_dependency "require-prof" unless defined?(JRUBY_VERSION) || defined?(Rubinius)
    s.add_development_dependency "simplecov"
    s.add_development_dependency "simplecov-rcov"
    s.add_development_dependency "cane"
  end

  if defined?(RUBY_VERSION) && RUBY_VERSION > '2.2'
    s.add_development_dependency "test-unit", '~> 2'
  end

  s.description = <<-DESC.gsub(/^    /, '')
    Ruby integrations for Elastic (client, API, etc.)
  DESC
end
