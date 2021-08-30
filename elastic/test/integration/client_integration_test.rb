require 'test_helper'
require 'logger'

module Elastic
  module Test
    class ClientIntegrationTest < Elastic::Test::IntegrationTestCase
      startup do
        Elastic::Extensions::Test::Cluster.start(nodes: 2) if ENV['SERVER'] and not Elastic::Extensions::Test::Cluster.running?
      end

      shutdown do
        Elastic::Extensions::Test::Cluster.stop if ENV['SERVER'] and Elastic::Extensions::Test::Cluster.running?
      end

      context "Elastic client" do
        setup do
          @port  = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i
          system "curl -X DELETE http://localhost:#{@port}/_all > /dev/null 2>&1"

          @logger =  Logger.new(STDERR)
          @logger.formatter = proc do |severity, datetime, progname, msg|
            color = case severity
              when /INFO/ then :green
              when /ERROR|WARN|FATAL/ then :red
              when /DEBUG/ then :cyan
              else :white
            end
            ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
          end

          @client = Elastic::Client.new host: "localhost:#{@port}", logger: (ENV['QUIET'] ? nil : @logger)
        end

        should "perform the API methods" do
          assert_nothing_raised do
            # Index a document
            #
            @client.index index: 'test-index', type: 'test-type', id: '1', body: { title: 'Test' }

            # Refresh the index
            #
            @client.indices.refresh index: 'test-index'

            # Search
            #
            response = @client.search index: 'test-index', body: { query: { match: { title: 'test' } } }

            assert_equal 1,      response['hits']['total']
            assert_equal 'Test', response['hits']['hits'][0]['_source']['title']

            # Delete the index
            #
            @client.indices.delete index: 'test-index'
          end
        end

      end
    end
  end
end
