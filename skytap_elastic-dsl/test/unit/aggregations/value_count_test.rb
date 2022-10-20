require 'test_helper'

module SkytapElastic
  module Test
    module Aggregations
      class ValueCountTest < ::Test::Unit::TestCase
        include SkytapElastic::DSL::Search::Aggregations

        context "ValueCount agg" do
          subject { ValueCount.new }

          should "be converted to a Hash" do
            assert_equal({ value_count: {} }, subject.to_hash)
          end

          should "take a Hash" do
            subject = ValueCount.new foo: 'bar'
            assert_equal({ value_count: { foo: 'bar' } }, subject.to_hash)
          end
        end
      end
    end
  end
end
