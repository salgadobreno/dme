require_relative 'app_log'

class StateMachine

  attr_reader :current_state, :machine_states, :payload

  def initialize(states, payload={})
    @machine_states = states
    @current_state = @machine_states.first
    @payload = payload
  end

  def forward
    #TODO: lidar com 'fim'
    # execute/validate the current state call
    @current_state.execute @payload

    if @current_state.validate @payload
      APP_LOG.info("#{@current_state} is valid.")
      @current_state = @machine_states[@machine_states.find_index(@current_state)+1]
      return true
    else
      APP_LOG.debug("#{@current_state} invalid.")
      return false
    end
  end

  def has_next?
    !current_state.equal?(last_state)
  end

  private

  def last_state
    @machine_states.last
  end
end
