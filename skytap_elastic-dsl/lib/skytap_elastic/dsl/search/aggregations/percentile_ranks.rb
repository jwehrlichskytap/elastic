module SkytapElastic
  module DSL
    module Search
      module Aggregations

        # A multi-value metrics aggregation which calculates percentile ranks on numeric values
        #
        # @example
        #
        #     search do
        #       aggregation :load_time_outliers do
        #         percentile_ranks do
        #           field 'load_time'
        #           values [ 15, 30 ]
        #         end
        #       end
        #     end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/search-aggregations-metrics-percentile-rank-aggregation.html
        #
        class PercentileRanks
          include BaseComponent

          option_method :field
          option_method :values
          option_method :script
          option_method :params
          option_method :compression
        end

      end
    end
  end
end
