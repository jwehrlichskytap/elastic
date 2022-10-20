module SkytapElastic
  module DSL
    module Search
      module Queries

        # A query which matches all documents
        #
        # @example
        #
        #     search do
        #       query do
        #         match_all
        #       end
        #     end
        #
        # @see http://www.elastic.org/guide/en/elastic/reference/current/query-dsl-match-all-query.html
        #
        class MatchAll
          include BaseComponent

          option_method :boost
        end

      end
    end
  end
end
