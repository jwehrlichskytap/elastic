require 'test_helper'

module Elastic
  module Test
    class SearchSuggestTest < ::Test::Unit::TestCase
      subject { Elastic::DSL::Search::Suggest.new :foo }

      context "Search suggest" do
        should "be an empty hash by default" do
          assert_equal({ foo: {} }, subject.to_hash)
        end

        should "contain options" do
          subject = Elastic::DSL::Search::Suggest.new :foo, boo: 'bam'
          assert_equal({ foo: { boo: 'bam' } }, subject.to_hash)
        end
      end
    end
  end
end
