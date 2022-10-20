require 'skytap_elastic/dsl/version'

require 'skytap_elastic/dsl/utils'
require 'skytap_elastic/dsl/search/base_component'
require 'skytap_elastic/dsl/search/base_compound_filter_component'
require 'skytap_elastic/dsl/search/base_aggregation_component'
require 'skytap_elastic/dsl/search/query'
require 'skytap_elastic/dsl/search/filter'
require 'skytap_elastic/dsl/search/aggregation'
require 'skytap_elastic/dsl/search/highlight'
require 'skytap_elastic/dsl/search/sort'
require 'skytap_elastic/dsl/search/options'
require 'skytap_elastic/dsl/search/suggest'

Dir[ File.expand_path('../dsl/search/queries/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/filters/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/aggregations/**/*.rb', __FILE__) ].each   { |f| require f }

require 'skytap_elastic/dsl/search'

module SkytapElastic

  # The main module, which can be included into your own class or namespace,
  # to provide the DSL methods.
  #
  # @example
  #
  #     include SkytapElastic::DSL
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
      base.__send__ :include, SkytapElastic::DSL::Search
    end
  end
end
