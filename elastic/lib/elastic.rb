require "elastic/version"

require 'elastic/transport'
require 'elastic/api'

module Elastic
  module Transport
    class Client
      include Elastic::API
    end
  end
end
