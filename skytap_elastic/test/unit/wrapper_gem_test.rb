require 'test_helper'

module SkytapElastic
  module Test
    class WrapperGemTest < ::Test::Unit::TestCase

      context "Wrapper gem" do

        should "require all neccessary subgems" do
          assert defined? SkytapElastic::Client
          assert defined? SkytapElastic::API
        end

        should "mix the API into the client" do
          SkytapElastic::Transport
          client = SkytapElastic::Client.new

          assert_respond_to client, :search
          assert_respond_to client, :cluster
          assert_respond_to client, :indices
        end

      end

    end
  end
end
