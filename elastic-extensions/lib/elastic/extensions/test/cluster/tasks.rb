require 'elastic/extensions/test/cluster'

namespace :elastic do
  desc "Start Elastic cluster for tests"
  task :start do
    Elastic::Extensions::Test::Cluster.start
  end

  desc "Stop Elastic cluster for tests"
  task :stop do
    Elastic::Extensions::Test::Cluster.stop
  end
end
