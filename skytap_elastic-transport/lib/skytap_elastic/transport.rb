require "uri"
require "time"
require "timeout"
require "multi_json"
require "faraday"

require "skytap_elastic/transport/transport/serializer/multi_json"
require "skytap_elastic/transport/transport/sniffer"
require "skytap_elastic/transport/transport/response"
require "skytap_elastic/transport/transport/errors"
require "skytap_elastic/transport/transport/base"
require "skytap_elastic/transport/transport/connections/selector"
require "skytap_elastic/transport/transport/connections/connection"
require "skytap_elastic/transport/transport/connections/collection"
require "skytap_elastic/transport/transport/http/faraday"
require "skytap_elastic/transport/client"
require "skytap_elastic/transport/version"

module SkytapElastic
  module Client

    # A convenience wrapper for {::SkytapElastic::Transport::Client#initialize}.
    #
    def new(arguments={}, &block)
      SkytapElastic::Transport::Client.new(arguments, &block)
    end
    extend self
  end
end
