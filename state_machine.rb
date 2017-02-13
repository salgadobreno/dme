
class StateMachine
  attr_accessor :machine_states

  def initialize(*args)
    @machine_states = args
  end
end
