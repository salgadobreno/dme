require 'dashboard_init'

class DefaultStateMachine < StateMachine
  def initialize(payload = {})
    super [StateAceptance.new, StateTriage.new, StateExpedition.new], payload
  end
end
