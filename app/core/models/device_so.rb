require "mongoid"
require "forwardable"

#Device Service Order
class DeviceSo
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Forwardable

  belongs_to :am_device, optional: false
  has_many :device_logs, autosave: true
  embeds_one :state_machine
  field :finished, type: Boolean, default: false

  def_delegators :am_device, :serial_number
  def_delegators :am_device, :sold_at
  def_delegators :am_device, :warranty_days
  def_delegators :am_device, :blacklisted

  def_delegators :state_machine, :current_state
  def_delegators :state_machine, :last_state?
  def_delegators :state_machine, :payload

  validates_presence_of :am_device
  validates_presence_of :state_machine

  before_create { |device|
    device.log 'Device: ' + device.serial_number.to_s + ' entry.'
  }

  scope :active, ->{ where(finished: false) }
  scope :finished, ->{ where(finished: true) }

  def initialize(am_device, state_machine)
    raise ArgumentError.new "AmDevice is required" if am_device == nil
    raise ArgumentError.new "State Machine is required" if state_machine == nil

    super(
      am_device: am_device,
      state_machine: state_machine
    )
  end

  def forward
    prev_state = current_state
    if state_machine.forward self
      if state_machine.last_state?
        self.finished = true
        log "Device: #{serial_number} exit."
        return true
      else
        log "State changed from: #{prev_state.name}, from #{current_state.name}"
        return true
      end
    else
      return false
    end
  end

  def log(message)
    self.device_logs << DeviceLog.new(self, message)
  end

  def as_json(options={})
    super(options.merge({methods: :serial_number}))
  end
end