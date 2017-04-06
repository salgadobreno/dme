require 'mongoid'
require 'models/avixy_device'

class DeviceHistory
  include Mongoid::Document

  field :description, type: String
  field :registered_at, type: DateTime

  belongs_to :avixy_device

  validates_presence_of :description
  validates_presence_of :registered_at
end
