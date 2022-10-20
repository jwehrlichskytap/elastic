module SkytapElastic
  module API
    module Actions

      # Retrieve an indexed template from Elastic
      #
      # @option arguments [String] :id Template ID
      #
      # @see http://www.elastic.org/guide/en/elastic/reference/master/search-template.html
      #
      def delete_template(arguments={})
        method = HTTP_DELETE
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
