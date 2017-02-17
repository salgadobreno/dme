class StateMachine

  attr_reader :current_state, :machine_states, :payload

  def initialize(*args)
    @machine_states = args
    @current_state = @machine_states.first
    @payload = {}
  end

  def forward
    # execute/validate the current state call
    @current_state.execute @payload

    if @current_state.validate @payload
      p "valido"
      "current state previo é #{@current_state}"
      "index do current state é #{@machine_states.find_index(@current_state)}"
      @current_state = @machine_states[@machine_states.find_index(@current_state)+1]
      "current state agora é #{@current_state}"
      #TODO: verificação se tá no "end"
    end
  end
end
