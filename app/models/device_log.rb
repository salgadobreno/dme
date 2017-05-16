require 'mongoid'

class DeviceLog
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String

  belongs_to :am_device, optional: false #ref to a Device's complete history
  belongs_to :device_so, optional: true #ref to the Service Order this log came from

  validates_presence_of :description

  def initialize(*args)
    # 2 args: device_so, event_description
    # 3 args: am_device, device_so, event_description
    case args.size
    when 2
      device_so = args[0]
      event_description = args[1]
      raise ArgumentError.new 'A Device should be informed' if device_so == nil
      raise ArgumentError.new 'A description should be informed' if event_description == nil
      super(am_device: device_so.am_device, device_so: device_so, description: event_description)
    when 3
      am_device = args[0]
      device_so = args[1]
      event_description = args[2]
      super(am_device: am_device, device_so: device_so, description: event_description)
    else
      raise ArgumentError.new "Wrong number of arguments (give 2 or 3)"
    end
  end
end
