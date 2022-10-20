# encoding: UTF-8

require 'test_helper'

module SkytapElastic
  module Test
    class APITest < ::Test::Unit::TestCase

      context "The API module" do

        should "access the settings" do
          assert_not_nil SkytapElastic::API.settings
        end

        should "allow to set settings" do
          assert_nothing_raised { SkytapElastic::API.settings[:foo] = 'bar' }
          assert_equal 'bar', SkytapElastic::API.settings[:foo]
        end

        should "have default serializer" do
          assert_equal MultiJson, SkytapElastic::API.serializer
        end

      end

    end
  end
end
