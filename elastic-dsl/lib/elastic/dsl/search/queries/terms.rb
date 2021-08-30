module Elastic
  module DSL
    module Search
      module Queries

        # A query which returns documents matching the specified terms
        #
        # @note The specified terms are *not analyzed* (lowercased, stemmed, etc)
        #
        # @example
        #
        #     search do
        #       query do
        #         terms categories: ['World', 'Opinion']
        #       end
        #     end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/query-dsl-common-terms-query.html
        #
        class Terms
          include BaseComponent
        end

      end
    end
  end
end
