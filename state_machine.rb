class State
  attr_reader :name

  def initialize(name, state_options)
    @name = name

    # register callbacks
    @validation_callbacks = state_options[:validation]
    @execution_callbacks = state_options[:execution]
  end

  def execute(payload)
    unless @execution_callbacks.nil? || @validation_callbacks.empty?
      @execution_callbacks.each {|eb| eb.call(payload)}
    end
  end

  def validate(payload)
    r = nil

    if @validation_callbacks.nil? || @validation_callbacks.empty?
      r = true
    else
      # chama all? em array de Boolean, se algum falhar, retorna falso
      r = @validation_callbacks.map { |validation|
        validation.call(payload)
      }.all?
    end

    return r
  end

end

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
