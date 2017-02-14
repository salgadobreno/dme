class State
  def initialize(name, state_options)
  end

  def execute
  end

  def validate
    return true
  end
end

class StateMachine
  attr_reader :current_state
  attr_accessor :machine_states, :operations, :rules, :index

  def initialize(*args)
    @machine_states = args
    @current_state = @machine_states.first
  end

  def forward
    # execute/validate the current state call
    @current_state.execute

    if @current_state.validate
      @current_state = @machine_states[@machine_states.find_index(@current_state)+1]
    end
  end
end
