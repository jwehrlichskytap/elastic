# Elastic

The `elastic` library provides a Ruby client and API for [Elastic](http://elastic.org).

Features overview:

* Pluggable logging and tracing
* Plugabble connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand
* Consistent API support for the whole Elastic API
* Extensive documentation and examples
* Emphasis on modularity and extendability of both the client and API libraries

(For integration with Ruby models and Rails applications,
see the <https://github.com/elastic/elastic-rails> project.)

## Compatibility

The library is compatible with Ruby 1.8.7 and higher.

The library is compatible with Elastic 0.90 and 1.0 -- you have to install and use a matching version, though.

The 1.x versions and the master branch are compatible with **Elastic 1.0** API.

To use the **Elastic 0.90** API, install the **0.4.x** gem version or use the corresponding
[`0.4`](https://github.com/elastic/elastic-ruby/tree/0.4) branch.

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install elastic

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elastic', git: 'git://github.com/elastic/elastic-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elastic/elastic-ruby.git
    cd elastic-ruby/elastic
    bundle install
    rake install

## Usage

This library is a wrapper for two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-ruby/tree/master/elastic-transport),
  which provides a low-level Ruby client for connecting to an [Elastic](http://elastic.org) cluster
* [`elastic-api`](https://github.com/elastic/elastic-ruby/tree/master/elastic-api),
  which provides a Ruby API for the Elastic RESTful API

Install the `elastic` package and use the API directly:

```ruby
require 'elastic'

client = Elastic::Client.new log: true

client.cluster.health

client.transport.reload_connections!

client.search q: 'test'

# etc.
```

Please refer to the specific library documentation for details:

* **Transport**:
   [[README]](https://github.com/elastic/elastic-ruby/blob/master/elastic-transport/README.md)
   [[Documentation]](http://rubydoc.info/gems/elastic-transport/file/README.markdown)

* **API**:
   [[README]](https://github.com/elastic/elastic-ruby/blob/master/elastic-api/README.md)
   [[Documentation]](http://rubydoc.info/gems/elastic-api/file/README.markdown)

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2013 Elastic <http://www.elastic.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
