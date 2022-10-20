require 'test_helper'

class SkytapElastic::Transport::Transport::SerializerTest < Test::Unit::TestCase

  context "Serializer" do

    should "use MultiJson by default" do
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      SkytapElastic::Transport::Transport::Serializer::MultiJson.new.load('{}')
      SkytapElastic::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end
