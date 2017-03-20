$LOAD_PATH.unshift(File.expand_path('.'))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require 'app/mock_db'
require 'app/state'
require 'app/device'
require 'app/state_machine'

TEST_STORE_LOCATION = './tmpdb'

describe MockDB do
  before do
    @mock_db = MockDB.new

    @state_inicio = State.new :inicio, {
      :execution => [],
      :validation => []
    }
    @state_fim = State.new :fim, {
      :execution => [],
      :validation => []
    }
    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    @device = Device.new 1234, @state_machine
  end

  #after do
    #if File.exists? TEST_STORE_LOCATION
      #File.delete TEST_STORE_LOCATION
    #end
  #end

  it 'has a Device list' do
    @mock_db.devices.must_equal []
    @mock_db << @device
    @mock_db.devices.must_equal [@device]
  end

  describe "#store" do
    it 'saves to specified file' do
      @mock_db << @device
      refute @mock_db.devices.empty?
      @mock_db.store TEST_STORE_LOCATION
      File.exist?(TEST_STORE_LOCATION).must_equal(true)
    end
  end

  describe "#restore" do
    it 'restores list from specified file' do
      @mock_db << @device
      @mock_db.devices.must_equal [@device]
      @mock_db.store TEST_STORE_LOCATION
      mock_db_restored = MockDB.restore TEST_STORE_LOCATION
      mock_db_restored.devices.must_equal [@device]
    end
  end
end
