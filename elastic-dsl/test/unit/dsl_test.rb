require 'test_helper'

module Elastic
  module Test
    class DSLTest < ::Test::Unit::TestCase
      context "The DSL" do
        class DummyDSLReceiver
          include Elastic::DSL
        end

        should "include the module in receiver" do
          assert_contains DummyDSLReceiver.included_modules, Elastic::DSL
          assert_contains DummyDSLReceiver.included_modules, Elastic::DSL::Search
        end
      end
    end
  end
end
