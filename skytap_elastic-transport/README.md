# SkytapElastic::Transport

**This library is part of the [`skytap_elastic-ruby`](https://github.com/elastic/skytap_elastic-ruby/) package;
please refer to it, unless you want to use this library standalone.**

----

The `skytap_elastic-transport` library provides a low-level Ruby client for connecting
to an [Elastic](http://elastic.org) cluster.

It handles connecting to multiple nodes in the cluster, rotating across connections,
logging and tracing requests and responses, maintaining failed connections,
discovering nodes in the cluster, and provides an abstraction for
data serialization and transport.

It does not handle calling the Elastic API;
see the [`skytap_elastic-api`](https://github.com/elastic/skytap_elastic-ruby/tree/master/skytap_elastic-api) library.

The library is compatible with Ruby 1.8.7 or higher and with Elastic 0.90 and 1.0.

Features overview:

* Pluggable logging and tracing
* Plugabble connection selection strategies (round-robin, random, custom)
* Pluggable transport implementation, customizable and extendable
* Pluggable serializer implementation
* Request retries and dead connections handling
* Node reloading (based on cluster state) on errors or on demand

For optimal performance, use a HTTP library which supports persistent ("keep-alive") connections,
such as [Typhoeus](https://github.com/typhoeus/typhoeus).
Just require the library (`require 'typhoeus'; require 'typhoeus/adapters/faraday'`) in your code,
and it will be automatically used; currently these libraries will be automatically detected and used:
[Patron](https://github.com/toland/patron),
[HTTPClient](https://rubygems.org/gems/httpclient) and
[Net::HTTP::Persistent](https://rubygems.org/gems/net-http-persistent).

For detailed information, see example configurations [below](#transport-implementations).

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install skytap_elastic-transport

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://gembundler.com):

    gem 'skytap_elastic-transport', git: 'git://github.com/elastic/skytap_elastic-ruby.git'

or install it from a source code checkout:

    git clone https://github.com/elastic/skytap_elastic-ruby.git
    cd skytap_elastic-ruby/skytap_elastic-transport
    bundle install
    rake install

## Example Usage

In the simplest form, connect to Elastic running on <http://localhost:9200>
without any configuration:

    require 'elastic/transport'

    client = SkytapElastic::Client.new
    response = client.perform_request 'GET', '_cluster/health'
    # => #<SkytapElastic::Transport::Transport::Response:0x007fc5d506ce38 @status=200, @body={ ... } >

Full documentation is available at <http://rubydoc.info/gems/skytap_elastic-transport>.

## Configuration

The client supports many configurations options for setting up and managing connections,
configuring logging, customizing the transport library, etc.

### Setting Hosts

To connect to a specific Elastic host:

    SkytapElastic::Client.new host: 'search.myserver.com'

To connect to a host with specific port:

    SkytapElastic::Client.new host: 'myhost:8080'

To connect to multiple hosts:

    SkytapElastic::Client.new hosts: ['myhost1', 'myhost2']

Instead of Strings, you can pass host information as an array of Hashes:

    SkytapElastic::Client.new hosts: [ { host: 'myhost1', port: 8080 }, { host: 'myhost2', port: 8080 } ]

**NOTE:** When specifying multiple hosts, you probably want to enable the `retry_on_failure` option to
          perform a failed request on another node (see the _Retrying on Failures_ chapter).

Common URL parts -- scheme, HTTP authentication credentials, URL prefixes, etc -- are handled automatically:

    SkytapElastic::Client.new url: 'https://username:password@api.server.org:4430/search'

You can pass multiple URLs separated by a comma:

    SkytapElastic::Client.new urls: 'http://localhost:9200,http://localhost:9201'

Another way to configure the URL(s) is to export the `ELASTICSEARCH_URL` variable.

The client will automatically round-robin across the hosts
(unless you select or implement a different [connection selector](#connection-selector)).

### Authentication

You can pass the authentication credentials, scheme and port in the host configuration hash:

    SkytapElastic::Client.new hosts: [
      { host: 'my-protected-host',
        port: '443',
        user: 'USERNAME',
        password: 'PASSWORD',
        scheme: 'https'
      } ]

... or simply use the common URL format:

    SkytapElastic::Client.new url: 'https://username:password@example.com:9200'

To pass a custom certificate for SSL peer verification to Faraday-based clients,
use the `transport_options` option:

    SkytapElastic::Client.new url: 'https://username:password@example.com:9200',
                              transport_options: { ssl: { ca_file: '/path/to/cacert.pem' } }

### Logging

To log requests and responses to standard output with the default logger (an instance of Ruby's {::Logger} class),
set the `log` argument:

    SkytapElastic::Client.new log: true

To trace requests and responses in the _Curl_ format, set the `trace` argument:

    SkytapElastic::Client.new trace: true

You can customize the default logger or tracer:

    client.transport.logger.formatter = proc { |s, d, p, m| "#{s}: #{m}\n" }
    client.transport.logger.level = Logger::INFO

Or, you can use a custom {::Logger} instance:

    SkytapElastic::Client.new logger: Logger.new(STDERR)

You can pass the client any conforming logger implementation:

    require 'logging' # https://github.com/TwP/logging/

    log = Logging.logger['skytap_elastic']
    log.add_appenders Logging.appenders.stdout
    log.level = :info

    client = SkytapElastic::Client.new logger: log

### Setting Timeouts

For many operations in Elastic, the default timeouts of HTTP libraries are too low.
To increase the timeout, you can use the `request_timeout` parameter:

    SkytapElastic::Client.new request_timeout: 5*60

You can also use the `transport_options` argument documented below.

### Randomizing Hosts

If you pass multiple hosts to the client, it rotates across them in a round-robin fashion, by default.
When the same client would be running in multiple processes (eg. in a Ruby web server such as Thin),
it might keep connecting to the same nodes "at once". To prevent this, you can randomize the hosts
collection on initialization and reloading:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], randomize_hosts: true

### Retrying on Failures

When the client is initialized with multiple hosts, it makes sense to retry a failed request
on a different host:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: true

You can specify how many times should the client retry the request before it raises an exception
(the default is 3 times):

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], retry_on_failure: 5

### Reloading Hosts

Elastic by default dynamically discovers new nodes in the cluster. You can leverage this
in the client, and periodically check for new nodes to spread the load.

To retrieve and use the information from the
[_Nodes Info API_](http://www.elastic.org/guide/reference/api/admin-cluster-nodes-info/)
on every 10,000th request:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_connections: true

You can pass a specific number of requests after which the reloading should be performed:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_connections: 1_000

To reload connections on failures, use:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], reload_on_failure: true

The reloading will timeout if not finished under 1 second by default. To change the setting:

    SkytapElastic::Client.new hosts: ['localhost:9200', 'localhost:9201'], sniffer_timeout: 3

**NOTE:** When using reloading hosts ("sniffing") together with authentication, just pass the scheme,
          user and password with the host info -- or, for more clarity, in the `http` options:

    SkytapElastic::Client.new host: 'localhost:9200',
                              http: { scheme: 'https', user: 'U', password: 'P' },
                              reload_connections: true,
                              reload_on_failure: true

### Connection Selector

By default, the client will rotate the connections in a round-robin fashion, using the
{SkytapElastic::Transport::Transport::Connections::Selector::RoundRobin} strategy.

You can implement your own strategy to customize the behaviour. For example,
let's have a "rack aware" strategy, which will prefer the nodes with a specific
[attribute](https://github.com/elastic/elastic/blob/1.0/config/elastic.yml#L81-L85).
Only when these would be unavailable, the strategy will use the other nodes:

    class RackIdSelector
      include SkytapElastic::Transport::Transport::Connections::Selector::Base

      def select(options={})
        connections.select do |c|
          # Try selecting the nodes with a `rack_id:x1` attribute first
          c.host[:attributes] && c.host[:attributes][:rack_id] == 'x1'
        end.sample || connections.to_a.sample
      end
    end

    SkytapElastic::Client.new hosts: ['x1.search.org', 'x2.search.org'], selector_class: RackIdSelector

### Transport Implementations

By default, the client will use the [_Faraday_](https://rubygems.org/gems/faraday) HTTP library
as a transport implementation.

It will auto-detect and use an _adapter_ for _Faraday_ based on gems loaded in your code,
preferring HTTP clients with support for persistent connections.

To use the [_Patron_](https://github.com/toland/patron) HTTP, for example, just require it:

    require 'patron'

Then, create a new client, and the _Patron_  gem will be used as the "driver":

    client = SkytapElastic::Client.new

    client.transport.connections.first.connection.builder.handlers
    # => [Faraday::Adapter::Patron]

    10.times do
      client.nodes.stats(metric: 'http')['nodes'].values.each do |n|
        puts "#{n['name']} : #{n['http']['total_opened']}"
      end
    end

    # => Stiletoo : 24
    # => Stiletoo : 24
    # => Stiletoo : 24
    # => ...

To use a specific adapter for _Faraday_, pass it as the `adapter` argument:

    client = SkytapElastic::Client.new adapter: :net_http_persistent

    client.transport.connections.first.connection.builder.handlers
    # => [Faraday::Adapter::NetHttpPersistent]

To pass options to the
[`Faraday::Connection`](https://github.com/lostisland/faraday/blob/master/lib/faraday/connection.rb)
constructor, use the `transport_options` key:

    client = SkytapElastic::Client.new transport_options: {
      request: { open_timeout: 1 },
      headers: { user_agent:   'MyApp' },
      params:  { :format => 'yaml' },
      ssl:     { verify: false }
    }

To configure the _Faraday_ instance directly, use a block:

    require 'typhoeus'
    require 'typhoeus/adapters/faraday'

    client = SkytapElastic::Client.new(host: 'localhost', port: '9200') do |f|
      f.response :logger
      f.adapter  :typhoeus
    end

You can use any standard Faraday middleware and plugins in the configuration block,
for example sign the requests for the [AWS Elastic service](https://aws.amazon.com/skytap_elastic-service/):

    require 'faraday_middleware/aws_signers_v4'

    client = SkytapElastic::Client.new url: 'https://search-my-cluster-abc123....es.amazonaws.com' do |f|
      f.request :aws_signers_v4,
                credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_ACCESS_KEY']),
                service_name: 'es',
                region: 'us-east-1'
    end

You can also initialize the transport class yourself, and pass it to the client constructor
as the `transport` argument:

    require 'typhoeus'
    require 'typhoeus/adapters/faraday'

    transport_configuration = lambda do |f|
      f.response :logger
      f.adapter  :typhoeus
    end

    transport = SkytapElastic::Transport::Transport::HTTP::Faraday.new \
      hosts: [ { host: 'localhost', port: '9200' } ],
      &transport_configuration

    # Pass the transport to the client
    #
    client = SkytapElastic::Client.new transport: transport

Instead of passing the transport to the constructor, you can inject it at run time:

    # Set up the transport
    #
    faraday_configuration = lambda do |f|
      f.instance_variable_set :@ssl, { verify: false }
      f.adapter :excon
    end

    faraday_client = SkytapElastic::Transport::Transport::HTTP::Faraday.new \
      hosts: [ { host: 'my-protected-host',
                 port: '443',
                 user: 'USERNAME',
                 password: 'PASSWORD',
                 scheme: 'https'
              }],
      &faraday_configuration

    # Create a default client
    #
    client = SkytapElastic::Client.new

    # Inject the transport to the client
    #
    client.transport = faraday_client

You can also use a bundled [_Curb_](https://rubygems.org/gems/curb) based transport implementation:

    require 'curb'
    require 'elastic/transport/transport/http/curb'

    client = SkytapElastic::Client.new transport_class: SkytapElastic::Transport::Transport::HTTP::Curb

    client.transport.connections.first.connection
    # => #<Curl::Easy http://localhost:9200/>

It's possible to customize the _Curb_ instance by passing a block to the constructor as well
(in this case, as an inline block):

    transport = SkytapElastic::Transport::Transport::HTTP::Curb.new \
      hosts: [ { host: 'localhost', port: '9200' } ],
      & lambda { |c| c.verbose = true }

    client = SkytapElastic::Client.new transport: transport

You can write your own transport implementation easily, by including the
{SkytapElastic::Transport::Transport::Base} module, implementing the required contract,
and passing it to the client as the `transport_class` parameter -- or injecting it directly.

### Serializer Implementations

By default, the [MultiJSON](http://rubygems.org/gems/multi_json) library is used as the
serializer implementation, and it will pick up the "right" adapter based on gems available.

The serialization component is pluggable, though, so you can write your own by including the
{SkytapElastic::Transport::Transport::Serializer::Base} module, implementing the required contract,
and passing it to the client as the `serializer_class` or `serializer` parameter.

### Exception Handling

The library defines a [number of exception classes](https://github.com/elastic/skytap_elastic-ruby/blob/master/skytap_elastic-transport/lib/elastic/transport/transport/errors.rb)
for various client and server errors, as well as unsuccessful HTTP responses,
making it possible to `rescue` specific exceptions with desired granularity.

The highest-level exception is {SkytapElastic::Transport::Transport::Error}
and will be raised for any generic client *or* server errors.

{SkytapElastic::Transport::Transport::ServerError} will be raised for server errors only.

As an example for response-specific errors, a `404` response status will raise
an {SkytapElastic::Transport::Transport::Errors::NotFound} exception.

Finally, {SkytapElastic::Transport::Transport::SnifferTimeoutError} will be raised
when connection reloading ("sniffing") times out.

## Development and Community

For local development, clone the repository and run `bundle install`. See `rake -T` for a list of
available Rake tasks for running tests, generating documentation, starting a testing cluster, etc.

Bug fixes and features must be covered by unit tests. Integration tests are written in Ruby 1.9 syntax.

Github's pull requests and issues are used to communicate, send bug reports and code contributions.

## The Architecture

* {SkytapElastic::Transport::Client} is composed of {SkytapElastic::Transport::Transport}

* {SkytapElastic::Transport::Transport} is composed of {SkytapElastic::Transport::Transport::Connections},
  and an instance of logger, tracer, serializer and sniffer.

* Logger and tracer can be any object conforming to Ruby logging interface,
  ie. an instance of [`Logger`](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/logger/rdoc/Logger.html),
  [_log4r_](https://rubygems.org/gems/log4r), [_logging_](https://github.com/TwP/logging/), etc.

* The {SkytapElastic::Transport::Transport::Serializer::Base} implementations handle converting data for Elastic
  (eg. to JSON). You can implement your own serializer.

* {SkytapElastic::Transport::Transport::Sniffer} allows to discover nodes in the cluster and use them as connections.

* {SkytapElastic::Transport::Transport::Connections::Collection} is composed of
  {SkytapElastic::Transport::Transport::Connections::Connection} instances and a selector instance.

* {SkytapElastic::Transport::Transport::Connections::Connection} contains the connection attributes such as hostname and port,
  as well as the concrete persistent "session" connected to a specific node.

* The {SkytapElastic::Transport::Transport::Connections::Selector::Base} implementations allow to choose connections
  from the pool, eg. in a round-robin or random fashion. You can implement your own selector strategy.

## Development

To work on the code, clone and bootstrap the main repository first --
please see instructions in the main [README](../README.md#development).

To run tests, launch a testing cluster -- again, see instructions
in the main [README](../README.md#development) -- and use the Rake tasks:

```
time rake test:unit
time rake test:integration
```

Unit tests have to use Ruby 1.8 compatible syntax, integration tests
can use Ruby 2.x syntax and features.

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
