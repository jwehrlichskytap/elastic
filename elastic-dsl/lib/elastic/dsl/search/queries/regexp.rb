module Elastic
  module DSL
    module Search
      module Queries

        # A query which matches documents matching a regular expression
        #
        # @example
        #
        #     search do
        #       query do
        #         regexp :path do
        #           value '^/usr/?.*/var'
        #         end
        #       end
        #     end
        #
        # @see http://elastic.org/guide/en/elastic/reference/current/query-dsl-regexp-query.html
        #
        class Regexp
          include BaseComponent

          option_method :value
          option_method :boost
          option_method :flags
        end

      end
    end
  end
end
