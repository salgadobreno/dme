require 'dashboard_init'

class StateMachine
  include Mongoid::Document

  embedded_in :device_so
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
    # if @current_state is defined: return current_state
    # else, load it through current_state_index and set @current_state
    # if neither is present we'll let it blow up because this is unexpected state
    # (This is an approach against overly defensive programming in favour of design integrity)
    return @current_state || self.states[current_state_index]
  end

  def forward device_so
    #TODO: deal with 'end'
    # execute/validate the current state call
    current_state.execute payload, device_so

    if current_state.validate payload, device_so
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
