require "skytap_elastic/version"

require 'skytap_elastic/transport'
require 'skytap_elastic/api'

module SkytapElastic
  module Transport
    class Client
      include SkytapElastic::API
    end
  end
end
