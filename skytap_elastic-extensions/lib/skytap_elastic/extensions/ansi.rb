# encoding: utf-8

require 'skytap_elastic/extensions'

require 'ansi'
require 'ansi/table'
require 'ansi/terminal'

require 'delegate'
require 'skytap_elastic/transport/transport/response'

require 'skytap_elastic/extensions/ansi/helpers'
require 'skytap_elastic/extensions/ansi/actions'
require 'skytap_elastic/extensions/ansi/response'

module SkytapElastic
  module Extensions

    # This extension provides a {ResponseBody#to_ansi} method for the Elastic response body,
    # which colorizes and formats the output with the `ansi` gem.
    #
    # @example Display formatted search results
    #
    #     require 'skytap_elastic/extensions/ansi'
    #     puts SkytapElastic::Client.new.search.to_ansi
    #
    # @example Display a table with the output of the `_analyze` API
    #
    #     require 'skytap_elastic/extensions/ansi'
    #     puts SkytapElastic::Client.new.indices.analyze(text: 'Quick Brown Fox Jumped').to_ansi
    #
    module ANSI
    end

  end
end
