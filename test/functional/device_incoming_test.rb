require "test_helper"
require "date"

DEFAULT_WARRANTY_DAYS = 365

# TODO: This test should be user to test
# the first two basic state of the maintenance
# the device pre-triage and post triage (triaged - device accepted or not)
# THIS IS A FUNCTIONAL TEST - Move it to the proper folder

class SingleDeviceStm < StateMachine
  def initialize
    @add_index_op = nil
    @even_validation = nil

    @state_inicio = State.new :inicio, {
      :execution => [@add_index_op],
      :validation => [@even_validation]
    }
    @state_fim = State.new :fim, {
      :execution => nil,
      :validation => nil
    }

    super [@state_inicio, @state_fim]
  end
end

describe "Scenario receiving a single device" do
  before do
    @am_device = AMDevice.new(122321123, Time.now, DEFAULT_WARRANTY_DAYS)
    @device = Device.new(@am_device, SingleDeviceStm.new)
  end

  describe "out of laboratory" do
    it "should receive a device with an serial number" do
      # This test seems to be doing nothing
      #@device = Device.new(122321123,
        #Time.now,
        #DEFAULT_WARRANTY_DAYS,
        #SingleDeviceStm.new)
    end

    it "should find the SLA for the received device" do
    end

    it "should verify if it is a Avixy device" do
    end

    it "should verify the input invoice" do
    end

    it "should verify if the received device is validated with the cargo" do
    end

    it "should create a received registry log" do
    end

    it "should group the received items for triage" do
    end
  end

  describe "device enters the triage" do
    it "should identify the device" do

    end
  end
end

