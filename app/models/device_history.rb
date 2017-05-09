require 'mongoid'

class DeviceHistory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String

  embedded_in :device_so

  validates_presence_of :description

  def initialize(device, event_description)
    raise ArgumentError.new 'A Device should be informed' if device == nil
    raise ArgumentError.new 'A description should be informed' if event_description == nil
    super(device_so: device, description: event_description)
  end
end
