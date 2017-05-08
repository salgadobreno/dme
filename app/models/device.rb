require "mongoid"
require "forwardable"

class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Forwardable

  #TODO: fields as hash?
  #field :serial_number, type: Integer #TODO: Integer vs String
  #field :sold_at, type: DateTime
  #field :warranty_days, type: Integer
  belongs_to :am_device, optional: false, class_name: 'AMDevice'
  embeds_many :device_histories
  embeds_one :state_machine

  def_delegators :am_device, :serial_number
  def_delegators :am_device, :sold_at
  def_delegators :am_device, :warranty_days

  def_delegators :state_machine, :current_state

  validates_presence_of :am_device
  validates_presence_of :state_machine
  #validates_presence_of :serial_number
  #validates_numericality_of :serial_number, only_integer: true
  #validates_presence_of :sold_at
  #validates_presence_of :warranty_days, only_integer: true

  #def initialize(serial_number, sold_at, warranty, state_machine)
  def initialize(am_device, state_machine)
    #raise ArgumentError.new "Serial number is required" if serial_number == nil
    #raise ArgumentError.new "Sold at date is required" if sold_at == nil
    #raise ArgumentError.new "Warranty is required" if warranty == nil
    raise ArgumentError.new "AMDevice is required" if am_device == nil
    raise ArgumentError.new "State Machine is required" if state_machine == nil

    super(
      #serial_number: serial_number,
      #sold_at: sold_at,
      #warranty_days: warranty,
      am_device: am_device,
      state_machine: state_machine
    )
  end

  def forward
    prev_state = current_state.name
    if state_machine.forward
      DeviceHistory.new(self, "State changed to: #{current_state}, from #{prev_state}")
    end
  end
end
