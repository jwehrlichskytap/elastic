require "elastic/watcher/version"

Dir[ File.expand_path('../watcher/api/actions/**/*.rb', __FILE__) ].each   { |f| require f }

module Elastic
  module Watcher
    def self.included(base)
      base.__send__ :include, Elastic::API::Watcher
    end
  end
end

module Elastic
  module API
    module Watcher
      module Actions; end

        # Client for the "watcher" namespace (includes the {Watcher::Actions} methods)
        #
        class WatcherClient
          include Elastic::API::Common::Client,
                  Elastic::API::Common::Client::Base,
                  Elastic::API::Watcher::Actions
        end

        # Proxy method for {WatcherClient}, available in the receiving object
        #
        def watcher
          @watcher ||= WatcherClient.new(self)
        end
    end
  end
end

Elastic::API.__send__ :include, Elastic::API::Watcher

Elastic::Transport::Client.__send__ :include, Elastic::API::Watcher if defined?(Elastic::Transport::Client)
