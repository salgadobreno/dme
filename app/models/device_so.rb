require "mongoid"
require "forwardable"

#Device Service Order
class DeviceSo
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Forwardable

  belongs_to :am_device, optional: false
  embeds_one :state_machine

  def_delegators :am_device, :serial_number
  def_delegators :am_device, :sold_at
  def_delegators :am_device, :warranty_days
  def_delegators :am_device, :device_histories

  def_delegators :state_machine, :current_state

  validates_presence_of :am_device
  validates_presence_of :state_machine

  def initialize(am_device, state_machine)
    raise ArgumentError.new "AmDevice is required" if am_device == nil
    raise ArgumentError.new "State Machine is required" if state_machine == nil

    super(
      am_device: am_device,
      state_machine: state_machine
    )
  end

  def forward
    prev_state = current_state.name
    if state_machine.forward
      dh = DeviceHistory.new(am_device, "State changed to: #{current_state}, from #{prev_state}")
      dh.save!
    end
  end
end
