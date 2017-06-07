require 'dashboard_init'

class DefaultStateMachine < StateMachine
  def initialize
    super [StateAceptance.new, StateTriage.new, StateExpedition.new]
  end
end
