require 'skytap_elastic/extensions/test/cluster'

namespace :elastic do
  desc "Start Elastic cluster for tests"
  task :start do
    SkytapElastic::Extensions::Test::Cluster.start
  end

  desc "Stop Elastic cluster for tests"
  task :stop do
    SkytapElastic::Extensions::Test::Cluster.stop
  end
end
