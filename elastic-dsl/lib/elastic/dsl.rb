require 'elastic/dsl/version'

require 'elastic/dsl/utils'
require 'elastic/dsl/search/base_component'
require 'elastic/dsl/search/base_compound_filter_component'
require 'elastic/dsl/search/base_aggregation_component'
require 'elastic/dsl/search/query'
require 'elastic/dsl/search/filter'
require 'elastic/dsl/search/aggregation'
require 'elastic/dsl/search/highlight'
require 'elastic/dsl/search/sort'
require 'elastic/dsl/search/options'
require 'elastic/dsl/search/suggest'

Dir[ File.expand_path('../dsl/search/queries/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/filters/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/aggregations/**/*.rb', __FILE__) ].each   { |f| require f }

require 'elastic/dsl/search'

module Elastic

  # The main module, which can be included into your own class or namespace,
  # to provide the DSL methods.
  #
  # @example
  #
  #     include Elastic::DSL
  #
  #     definition = search do
  #       query do
  #         match title: 'test'
  #       end
  #     end
  #
  #     definition.to_hash
  #     # => { query: { match: { title: "test"} } }
  #
  # @see Search
  # @see http://www.elastic.org/guide/en/elastic/guide/current/query-dsl-intro.html
  #
  module DSL
    def self.included(base)
      base.__send__ :include, Elastic::DSL::Search
    end
  end
end
