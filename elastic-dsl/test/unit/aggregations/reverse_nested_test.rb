require 'test_helper'

module Elastic
  module Test
    module Aggregations
      class ReverseNestedTest < ::Test::Unit::TestCase
        include Elastic::DSL::Search::Aggregations

        context "ReverseNested aggregation" do
          subject { ReverseNested.new }

          should "be converted to a Hash" do
            assert_equal({ reverse_nested: {} }, subject.to_hash)
          end
          
        end
      end
    end
  end
end
