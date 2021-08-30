module Elastic
  module DSL
    module Search
      module Aggregations

        # Defines a single bucket with documents matching the provided filter,
        # usually to define scope for a nested aggregation
        #
        # @example
        #
        #    search do
        #      aggregation :clicks_for_tag_one do
        #        filter terms: { tags: ['one'] } do
        #          aggregation :sum_clicks do
        #            sum field: 'clicks'
        #          end
        #        end
        #      end
        #    end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/search-aggregations-bucket-filters-aggregation.html
        #
        class Filter
          include BaseAggregationComponent
        end

      end
    end
  end
end
