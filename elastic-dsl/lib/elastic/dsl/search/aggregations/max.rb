module Elastic
  module DSL
    module Search
      module Aggregations

        # A single-value metric aggregation which returns the maximum value from numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :max_clicks do
        #         max field: 'clicks'
        #       end
        #     end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/search-aggregations-metrics-max-aggregation.html
        #
        class Max
          include BaseComponent
        end

      end
    end
  end
end
