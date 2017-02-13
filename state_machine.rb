class StateMachine
  attr_accessor :machine_states, :operations

  def initialize(*args) #TODO: Separate the arguments to improve readability
    @machine_states = args[0]
    @operations = args[1]
  end

  def execute(op, arg)
    @operations[op].call(arg) #TODO: This magic number is temporary
  end
end
