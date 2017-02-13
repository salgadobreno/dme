class StateMachine
  attr_accessor :machine_states, :operations

  def initialize(*args) #TODO: Separate the arguments to improve readability
    @machine_states = args[0]
    @operations = args[1]
    @index = 0
  end

  def execute(op)
    @operations[op].call(self)
  end
  end
end
