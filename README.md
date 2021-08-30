# Elastic

This repository contains Ruby integrations for [Elastic](http://elastic.org):

* a client for connecting to an Elastic cluster,
* a Ruby API for the Elastic's REST API,
* various extensions and utilities.

For integration with Ruby models and Rails applications,
see the <https://github.com/elastic/elastic-rails> project.

## Compatibility

The libraries are compatible with Ruby 1.8.7 and higher.

The library is compatible with Elastic 0.90, 1.x and 2.x -- you have to install and use a matching version, though.

The 1.x versions and the master branch are compatible with Elastic 1.x and 2.x APIs.

To use the **Elastic 0.90** API, install the **0.4.x** gem version or use the corresponding
[`0.4`](https://github.com/elastic/elastic-ruby/tree/0.4) branch.

## Installation

Install the `elastic` package from [Rubygems](https://rubygems.org/gems/elastic):

    gem install elastic

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'elastic', git: 'git://github.com/elastic/elastic-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elastic/elastic-ruby.git
    cd elastic-ruby/elastic
    bundle install
    rake install

## Usage

The [`elastic`](https://github.com/elastic/elastic-ruby/tree/master/elastic)
library is a wrapper for two separate libraries:

* [`elastic-transport`](https://github.com/elastic/elastic-ruby/tree/master/elastic-transport),
  which provides a low-level Ruby client for connecting to an [Elastic](http://elastic.org) cluster
* [`elastic-api`](https://github.com/elastic/elastic-ruby/tree/master/elastic-api),
  which provides a Ruby API for the Elastic RESTful API

```ruby
require 'elastic'

client = Elastic::Client.new log: true

client.transport.reload_connections!

client.cluster.health

client.search q: 'test'

# etc.
```

Both of these libraries are extensively documented.
**Please read the [`elastic-transport`](http://rubydoc.info/gems/elastic-transport)
and the [`elastic-api`](http://rubydoc.info/gems/elastic-api) documentation carefully.**

_Keep in mind, that for optimal performance, you should use a HTTP library which supports persistent
("keep-alive") connections, e.g. [Patron](https://github.com/toland/patron) or
[Typhoeus](https://github.com/typhoeus/typhoeus)._

This repository contains these additional Ruby libraries:

* [`elastic-extensions`](https://github.com/elastic/elastic-ruby/tree/master/elastic-extensions),
   which provides a set of extensions to the base library,
* [`elastic-dsl`](https://github.com/elastic/elastic-ruby/tree/master/elastic-dsl),
  which provides a Ruby API for the [Elastic Query DSL](http://www.elastic.org/guide/en/elastic/reference/current/query-dsl.html),
* [`elastic-watcher`](https://github.com/elastic/elastic-ruby/tree/master/elastic-watcher),
  which provides Ruby API for the [_Watcher_](https://www.elastic.co/products/watcher) plugin.

Please see their respective READMEs for information and documentation.

## Development

[![Build Status](https://travis-ci.org/elastic/elastic-ruby.svg?branch=master)](https://travis-ci.org/elastic/elastic-ruby) [![Code Climate](https://codeclimate.com/github/elastic/elastic-ruby/badges/gpa.svg)](https://codeclimate.com/github/elastic/elastic-ruby)

To work on the code, clone and bootstrap the project first:

```
git clone https://github.com/elastic/elastic-ruby.git
cd elastic-ruby/
rake setup
rake bundle
```

This will clone the Elastic repository into the project, and run `bundle install` in all subprojects.

To run tests, you need to start a testing cluster on port 9250,
or provide a different one in the `TEST_CLUSTER_PORT` environment variable.

There's a Rake task to start the testing cluster:

```
rake test:cluster:start
```

You can configure the port, path to the startup script,
number of nodes, and other settings with environment variables:

```
TEST_CLUSTER_COMMAND=./tmp/builds/elastic-2.0.0-SNAPSHOT/bin/elastic \
TEST_CLUSTER_PORT=9250 \
TEST_CLUSTER_NODES=2 \
TEST_CLUSTER_NAME=my_cluster \
TEST_CLUSTER_PARAMS='-Xms500m -Xmx500m -D es.index.store.type=niofs' \
TEST_CLUSTER_TIMEOUT=120 \
rake test:cluster:start
```

To run tests against unreleased Elastic versions, you can use the `rake elastic:build`
Rake task to build Elastic from the cloned source
(use `rake elastic:update` to update the repository):

**Note:** If you have gems from the `elastic` family installed system-wide,
          and want to use development ones, prepend the command with `bundle exec`.

```
rake elastic:build
```

You can pass a branch name (tag, commit, ...) as the Rake task variable:

```
rake elastic:build[origin/1.x]
```

To run all the tests in all the subprojects, use the Rake task:

```
time rake test:all
```

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
