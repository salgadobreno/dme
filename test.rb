require "minitest/autorun"

class StateMachine
  def initialize(*args)
    @machine_states = args
  end
end

class TestStateMachine < Minitest::Test
  def test_should_test_thruth
    assert StateMachine.new :start, :end
  end
end

# class Operation
# end
#
# class Condition
# end
#
