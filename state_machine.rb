class StateMachine
  attr_accessor :machine_states, :operations, :rules, :index

  def initialize(*args) #TODO: Separate the arguments to improve readability
    @machine_states = args[0]
    @operations = args[1]
    @rules = args[2]
    @index = 0
  end

  def execute(op)
    @operations[op].call(self)
  end

  def verify(rule)
    @rules[rule].call(self)
  end
end
