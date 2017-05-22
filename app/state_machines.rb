require 'dashboard_init'

class DefaultStateMachine < StateMachine
  def initialize
    super [StateRecebimento.new, StateTriagem.new, StateExpedicao.new]
  end
end
