require 'app_log'
require 'state'

class StateMachine
  include Mongoid::Document

  embeds_many :states, cascade_callbacks: true

  attr_reader :current_state, :machine_states, :payload

  after_initialize { p "after initialize" }
  after_build { p "after build" }
  after_find {
    APP_LOG.info "after find"
    @machine_states = states
    @current_state = @machine_states.first
    @payload = {}
  }

  def initialize(states, payload={})
    @machine_states = states
    @current_state = @machine_states.first
    @payload = payload

    super(states: states)
    APP_LOG.info "initialize"
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

  def inspect
    "#{super} | machine_states: #{@machine_states}, current_state: #{@current_state}"
  end

  private

  def last_state
    @machine_states.last
  end
end
