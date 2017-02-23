require "forwardable"

class Item
  extend Forwardable

  def initialize(item_id, state_machine)
    @item_id = item_id
    @state_machine = state_machine
  end

  def_delegators :@state_machine, :current_state
  def_delegators :@state_machine, :forward

end
