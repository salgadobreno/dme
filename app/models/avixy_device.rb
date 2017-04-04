require 'mongoid'
#require 'models/device_history'

class AvixyDevice 
  include Mongoid::Document

  field :serial_number, type: String
  field :sold_at, type: DateTime
  field :warranty_days, type: Integer

  has_many :device_histories # TODO: optional
end
