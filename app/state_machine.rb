require 'app_log'
require 'state'

class StateMachine
  include Mongoid::Document

  embedded_in :device
  embeds_many :states
  field :payload, type: Hash
  field :current_state_index, type: Integer

  def initialize(states, payload={})
    super(states: states, payload: payload)
    self.current_state = states.first
  end

  def current_state=(state)
    @current_state = state
    self.current_state_index = self.states.find_index state
  end

  def current_state
    # se @current_state estiver definido: return current_state
    # se não, obter pelo current_state_index e setar o @current_state
    # se nenhum, deixar que dê erro pois deve ser feito mais robusto depois
    # (e.g.: impedir que esse estado do objeto seja possível antes de chegar aqui)
    return @current_state || self.states[current_state_index]
  end

  def forward
    #TODO: lidar com 'fim'
    # execute/validate the current state call
    current_state.execute payload

    if current_state.validate payload
      APP_LOG.info("#{current_state} is valid.")
      self.current_state = states[self.current_state_index + 1]
      return true
    else
      APP_LOG.debug("#{current_state} invalid.")
      return false
    end
  end

  def has_next?
    !current_state.equal?(last_state)
  end

  def inspect
    "#{super} | @states: #{states}, @current_state: #{current_state}"
  end

  private

  def last_state
    states.last
  end
end
