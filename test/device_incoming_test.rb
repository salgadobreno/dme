require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require "app/state_machine"
require "app/state"
require "app/item"
require "app/buffer"

class SingleDeviceStm < StateMachine
  def initialize
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
    @item = Item.new 122321123, SingleDeviceStm.new
  end

  describe "out of laboratory" do
    it "should receive a device with an serial number" do
      @device = Item.new 122321123, SingleDeviceStm.new
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

  descrive "device enters the triage" do
    it "should identify the device" do

    end

    it "should " do

    end
  end
end

