class AMDevice
  include Mongoid::Document

  has_many :devices

  field :serial_number, type: Integer #TODO: Integer vs String
  field :sold_at, type: DateTime
  field :warranty_days, type: DateTime

  def initialize(serial_number, sold_at, warranty_days)
    super(serial_number: serial_number, sold_at: sold_at, warranty_days: warranty_days)
  end
end
