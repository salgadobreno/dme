class AMDevice
  include Mongoid::Document

  field :serial_number, type: Integer #TODO: Integer vs String
  field :warranty_days, type: DateTime
  field :sold_at, type: DateTime

  def initialize(serial_number, warranty_days, sold_at)
    super(serial_number: serial_number, warranty_days: warranty_days, sold_at: sold_at)
  end
end
