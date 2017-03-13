require "forwardable"

class Device
  extend Forwardable

  attr_reader :events

  def initialize(item_id, state_machine)
    @item_id = item_id
    @state_machine = state_machine
    @events = []
  end

  def_delegators :@state_machine, :current_state

  def forward
    prev_state = current_state.name
    if @state_machine.forward
      @events << "State changed to: %s, from %s" % [current_state, prev_state]
    end
  end

end
