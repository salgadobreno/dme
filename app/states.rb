require 'dashboard_init'

class StateAceptance < State
  def initialize
    super :aceptance, {validations: [BlacklistValidation.new]}
  end
end

class StateTriage < State
  def initialize
    super :triage, {validations: [WarrantyCheckValidation.new]}
  end
end

class StateExpedition < State
  def initialize
    super :expedition, {}
  end
end

class StateSegregated < State
  def initialize
    super :segregated, {validations: [BetterCallAlineValidation.new]}
  end
end
