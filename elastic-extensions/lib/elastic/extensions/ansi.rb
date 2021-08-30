# encoding: utf-8

require 'elastic/extensions'

require 'ansi'
require 'ansi/table'
require 'ansi/terminal'

require 'delegate'
require 'elastic/transport/transport/response'

require 'elastic/extensions/ansi/helpers'
require 'elastic/extensions/ansi/actions'
require 'elastic/extensions/ansi/response'

module Elastic
  module Extensions

    # This extension provides a {ResponseBody#to_ansi} method for the Elastic response body,
    # which colorizes and formats the output with the `ansi` gem.
    #
    # @example Display formatted search results
    #
    #     require 'elastic/extensions/ansi'
    #     puts Elastic::Client.new.search.to_ansi
    #
    # @example Display a table with the output of the `_analyze` API
    #
    #     require 'elastic/extensions/ansi'
    #     puts Elastic::Client.new.indices.analyze(text: 'Quick Brown Fox Jumped').to_ansi
    #
    module ANSI
    end

  end
end
