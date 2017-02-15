class State
  attr_reader :name

  def initialize(name, state_options)
    @name = name
    @state_options = state_options
  end

  def execute
    @execute_blocks = @state_options[:execute]
    @execute_blocks.each {|eb| eb.call}
  end

  def validate
    @validation_blocks = @state_options[:validation]

    validated = true

    unless @validation_blocks.nil?
      @validation_blocks.each do |vproc|
        validated = vproc.call
      end
    end

    return validated
  end
end

class StateMachine
  attr_reader :current_state
  attr_accessor :machine_states

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
