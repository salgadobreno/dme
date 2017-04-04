require "forwardable"

class Device
  extend Forwardable

  attr_reader :serial_number, :events

  def initialize(serial_number, state_machine)
    @serial_number = serial_number
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
