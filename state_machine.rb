class StateMachine
  attr_accessor :machine_states, :operations

  def initialize(*args)
    @machine_states = args[0]
    @operations = args[1]
  end

end
