require 'dashboard_init'

class StateMachine
  include Mongoid::Document

  embedded_in :device_so
  embeds_many :states
  field :payload, type: Hash
  field :current_state_index, type: Integer
  field :previous_state_index, type: Integer

  NONE_STATE = StateNone.new
  DONE_STATE = StateFinished.new
  DONE_INDEX = -2
  SEGREGATED_STATE = StateSegregated.new
  SEGREGATED_INDEX = -1

  def initialize(states, payload={})
    super(states: states, payload: payload)
    self.current_state = states.first
  end

  def current_state=(state)
    case state
    when SEGREGATED_STATE
      @current_state = SEGREGATED_STATE
      self.current_state_index = SEGREGATED_INDEX
    when DONE_STATE
      @current_state = DONE_STATE
      self.current_state_index = DONE_INDEX
    else
      @current_state = state
      self.current_state_index = self.states.find_index state
    end
  end

  def current_state
    # if @current_state is defined: return current_state
    # else, load it through current_state_index and set @current_state
    # if neither is present we'll let it blow up because this is unexpected state
    # (This is an approach against overly defensive programming in favour of design integrity)
    case current_state_index
    when DONE_INDEX
      return DONE_STATE
    when SEGREGATED_INDEX
      return SEGREGATED_STATE
    else
      return @current_state || self.states[current_state_index]
    end
  end

  def previous_state=(state)
    case state
    when SEGREGATED_STATE
      @previous_state = SEGREGATED_STATE
      self.previous_state_index = SEGREGATED_INDEX
    when DONE_STATE
      @previous_state = DONE_STATE
      self.previous_state_index = DONE_INDEX
    else
      @previous_state = state
      self.previous_state_index = self.states.find_index state
    end
  end

  def previous_state
    case previous_state_index
    when nil
      return NONE_STATE
    when DONE_INDEX
      return DONE_STATE
    when SEGREGATED_INDEX
      return SEGREGATED_STATE
    else
      return @previous_state || self.states[previous_state_index]
    end
  end

  def forward device_so
    begin
      # execute/validate the current state call
      current_state.execute payload, device_so
      next_state = last_state? ? DONE_STATE : states[self.current_state_index + 1]

      if current_state.validate payload, device_so
        APP_LOG.info("#{current_state} is valid.")
        self.previous_state = self.current_state
        self.current_state = next_state
        return true
      else
        APP_LOG.debug("#{current_state} invalid. Sending to the segregated state")
        self.previous_state = self.current_state unless self.current_state == SEGREGATED_STATE
        self.current_state = SEGREGATED_STATE
        return false
      end
    rescue Exception => e
      device_so.log "Error while executing/validating the device in state #{current_state}: #{e.message}"
      self.previous_state = self.current_state unless self.current_state == SEGREGATED_STATE
      self.current_state = SEGREGATED_STATE
      return false
    end
  end

  def last_state?
    current_state.equal?(last_state)
  end

  def inspect
    "#{super} | @states: #{states}, @current_state: #{current_state}"
  end

  private

  def last_state
    states.last
  end
end
