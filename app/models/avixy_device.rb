require 'mongoid'
#require 'models/device_history'

class AvixyDevice 
  include Mongoid::Document

  field :serial_number, type: Integer
  field :sold_at, type: DateTime
  field :warranty_days, type: Integer

  has_many :device_histories

  validates_presence_of :serial_number
  validates_numericality_of :serial_number, only_integer: true
  validates_presence_of :sold_at
  validates_presence_of :warranty_days, only_integer: true
end
