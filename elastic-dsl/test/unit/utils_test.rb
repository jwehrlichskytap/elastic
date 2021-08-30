require 'test_helper'

module Elastic
  module Test
    class UtilsTest < ::Test::Unit::TestCase
      context "Utils" do
        should "convert a string to camelcase" do
          assert_equal 'Foo', Elastic::DSL::Utils.__camelize('foo')
        end

        should "convert an underscored string to camelcase" do
          assert_equal 'FooBar', Elastic::DSL::Utils.__camelize('foo_bar')
        end

        should "convert a symbol" do
          assert_equal 'FooBar', Elastic::DSL::Utils.__camelize(:foo_bar)
        end
      end
    end
  end
end
