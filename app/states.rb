require 'dashboard_init'

class StateRecebimento < State
  def initialize
    super :recebimento, {}
  end
end

class StateTriagem < State
  def initialize
    super :triagem, {}
  end
end

class StateExpedicao < State
  def initialize
    super :expedicao, {}
  end
end

class StateSegregado < State
  def initialize
    super :segregado, {}
  end
end
