require 'mongoid'

class DeviceLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String

  belongs_to :am_device

  validates_presence_of :description

  def initialize(am_device, event_description)
    raise ArgumentError.new 'A Device should be informed' if am_device == nil
    raise ArgumentError.new 'A description should be informed' if event_description == nil
    super(am_device: am_device, description: event_description)
  end
end
