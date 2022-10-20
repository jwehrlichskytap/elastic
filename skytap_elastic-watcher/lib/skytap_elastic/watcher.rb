require "skytap_elastic/watcher/version"

Dir[ File.expand_path('../watcher/api/actions/**/*.rb', __FILE__) ].each   { |f| require f }

module SkytapElastic
  module Watcher
    def self.included(base)
      base.__send__ :include, SkytapElastic::API::Watcher
    end
  end
end

module SkytapElastic
  module API
    module Watcher
      module Actions; end

        # Client for the "watcher" namespace (includes the {Watcher::Actions} methods)
        #
        class WatcherClient
          include SkytapElastic::API::Common::Client,
                  SkytapElastic::API::Common::Client::Base,
                  SkytapElastic::API::Watcher::Actions
        end

        # Proxy method for {WatcherClient}, available in the receiving object
        #
        def watcher
          @watcher ||= WatcherClient.new(self)
        end
    end
  end
end

SkytapElastic::API.__send__ :include, SkytapElastic::API::Watcher

SkytapElastic::Transport::Client.__send__ :include, SkytapElastic::API::Watcher if defined?(SkytapElastic::Transport::Client)
