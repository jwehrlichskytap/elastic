# encoding: UTF-8

require 'test_helper'

module Elastic
  module Test
    class APITest < ::Test::Unit::TestCase

      context "The API module" do

        should "access the settings" do
          assert_not_nil Elastic::API.settings
        end

        should "allow to set settings" do
          assert_nothing_raised { Elastic::API.settings[:foo] = 'bar' }
          assert_equal 'bar', Elastic::API.settings[:foo]
        end

        should "have default serializer" do
          assert_equal MultiJson, Elastic::API.serializer
        end

      end

    end
  end
end
