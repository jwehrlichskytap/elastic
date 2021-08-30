module Elastic
  module DSL
    module Search
      module Filters

        # A filter which returns documents matching the criteria defined with a script
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             script script: "doc['clicks'].value % 4 == 0"
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/query-dsl-script-filter.html
        #
        class Script
          include BaseComponent

          option_method :script
          option_method :params
        end

      end
    end
  end
end
