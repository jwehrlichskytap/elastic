require 'test_helper'

module Elastic
  module Test
    module Queries
      class TermTest < ::Test::Unit::TestCase
        include Elastic::DSL::Search::Queries

        subject { Term.new message: 'test' }

        context "Term Query" do
          should "take a concrete value" do
            @subject = Term.new message: 'test'

            assert_equal({:term=>{:message=>"test"}}, @subject.to_hash)
          end

          should "take a Hash" do
            @subject = Term.new message: { query: 'test', boost: 2 }

            assert_equal({:term=>{:message=>{:query=>"test", :boost=>2}}}, @subject.to_hash)
          end
        end
      end
    end
  end
end
