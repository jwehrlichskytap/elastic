require "uri"
require "time"
require "timeout"
require "multi_json"
require "faraday"

require "elastic/transport/transport/serializer/multi_json"
require "elastic/transport/transport/sniffer"
require "elastic/transport/transport/response"
require "elastic/transport/transport/errors"
require "elastic/transport/transport/base"
require "elastic/transport/transport/connections/selector"
require "elastic/transport/transport/connections/connection"
require "elastic/transport/transport/connections/collection"
require "elastic/transport/transport/http/faraday"
require "elastic/transport/client"

require "elastic/transport/version"

module Elastic
  module Client

    # A convenience wrapper for {::Elastic::Transport::Client#initialize}.
    #
    def new(arguments={}, &block)
      Elastic::Transport::Client.new(arguments, &block)
    end
    extend self
  end
end
