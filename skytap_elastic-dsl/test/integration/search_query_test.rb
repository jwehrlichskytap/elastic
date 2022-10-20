require 'test_helper'

module SkytapElastic
  module Test
    class QueryIntegrationTest < ::SkytapElastic::Test::IntegrationTestCase
      include SkytapElastic::DSL::Search

      context "Queries integration" do
        startup do
          SkytapElastic::Extensions::Test::Cluster.start(nodes: 1) if ENV['SERVER'] and not SkytapElastic::Extensions::Test::Cluster.running?
        end

        setup do
          @client.indices.create index: 'test'
          @client.index index: 'test', type: 'd', id: '1', body: { title: 'Test', tags: ['one'] }
          @client.index index: 'test', type: 'd', id: '2', body: { title: 'Rest', tags: ['one', 'two'] }
          @client.indices.refresh index: 'test'
        end

        context "for match query" do
          should "find the document" do
            response = @client.search index: 'test', body: search { query { match title: 'test' } }.to_hash

            assert_equal 1, response['hits']['total']
          end
        end

        context "for query_string query" do
          should "find the document" do
            response = @client.search index: 'test', body: search { query { query_string { query 'te*' } } }.to_hash

            assert_equal 1, response['hits']['total']
          end
        end

        context "for the bool query" do
          should "find the document" do
            response = @client.search index: 'test', body: search {
                query do
                  bool do
                    must   { terms tags: ['one'] }
                    should { match title: 'Test' }
                  end
                end
              }.to_hash

            assert_equal 2, response['hits']['total']
            assert_equal 'Test', response['hits']['hits'][0]['_source']['title']
          end
        end

      end
    end
  end
end