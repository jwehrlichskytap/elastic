module SkytapElastic
  module API
    module Actions

      # Retrieve an indexed script from Elastic
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document
      #
      # @see http://www.elastic.org/guide/en/elastic/reference/master/search-template.html
      #
      def get_template(arguments={})
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        method = HTTP_GET
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
