require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require "app/state_machine"
require "app/state"
require "app/device"
require "app/buffer"

describe MockDB do
  before do
    @mock_db = MockDB.new
  end

  it 'has a list of devices' do
    @mock_db.list.must_equal []
  end

  describe "#add" do
    it 'includes device on list' do
      stm = StateMachine.new []
      device = Device.new 342342, stm

      @mock_db.add device
    end
  end

  describe "#persist" do
    it 'stores the Device list ' do
      
    end
  end

  describe "#rm" do

  end
end
