require 'test_helper'

module SkytapElastic
  module Test
    class DSLTest < ::Test::Unit::TestCase
      context "The DSL" do
        class DummyDSLReceiver
          include SkytapElastic::DSL
        end

        should "include the module in receiver" do
          assert_contains DummyDSLReceiver.included_modules, SkytapElastic::DSL
          assert_contains DummyDSLReceiver.included_modules, SkytapElastic::DSL::Search
        end
      end
    end
  end
end
