require 'test_helper'

class Elastic::Transport::Transport::SerializerTest < Test::Unit::TestCase

  context "Serializer" do

    should "use MultiJson by default" do
      ::MultiJson.expects(:load)
      ::MultiJson.expects(:dump)
      Elastic::Transport::Transport::Serializer::MultiJson.new.load('{}')
      Elastic::Transport::Transport::Serializer::MultiJson.new.dump({})
    end

  end

end
