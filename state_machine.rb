require 'logger'

class StateMachine

  attr_reader :current_state, :machine_states, :payload

  def initialize(*args)
    @machine_states = args
    @current_state = @machine_states.first
    @payload = {}
    @log = Logger.new(STDOUT)
  end

  def forward
    # execute/validate the current state call
    @current_state.execute @payload

    if @current_state.validate @payload
      @log.info("#{@current_state.name} is valid.")
      @current_state = @machine_states[@machine_states.find_index(@current_state)+1]
    else
      @log.debug("Error validating the state #{@current_state.name}.")
    end
  end
end
