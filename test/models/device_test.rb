require "test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe Device do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @dt1 = DateTime.now
    @serial_number = 100000001
    @warranty = 365

    @state_inicio = State.new :inicio, { :operation => nil, :validation => nil }
    @state_fim = State.new :fim, { :operation => nil, :validation => nil }
    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    @device = Device.new(@serial_number, @dt1, @warranty, @state_machine)
  end

  after do
    DatabaseCleaner.clean
  end

  describe "database operations" do

    it "should create a new Device into the Databse" do
      @device.save.must_equal true
      Device.count.must_be :==, 1
      Device.first.sold_at.to_s.must_equal @dt1.to_s
    end

    it 'requires serial number' do
      proc { device = Device.new(nil, @sold_at, @warranty, @state_machine) }.must_raise ArgumentError
    end

    it 'requires StateMachine' do
      proc { device = Device.new(@serial_number, @sold_at, @warranty, nil) }.must_raise ArgumentError
    end

    it 'requires sold at' do
      proc { device = Device.new(@serial_number, nil, @warranty, @state_machine) }.must_raise ArgumentError
    end

    it 'requires warranty' do
      proc { device = Device.new(@serial_number, @sold_at, nil, @state_machine) }.must_raise ArgumentError
    end

    it "should not save invalid Device" do
      device = nil
      proc { device = Device.new }.must_raise ArgumentError
    end

    it "should not save a device with non numeric serial number" do
      proc { device = Device.new 'abdc', Time.now, 345, nil }.must_raise ArgumentError
    end

    it 'should save and restore the state_machine' do
      #TODO: State && [nil] && storing
      inicio = State.new :inicio, {
        :operation => [],
        :validation => []
      }
      fim = State.new :fim, {
        :operation => [],
        :validation => []
      }
      state_machine = StateMachine.new [inicio, fim]

      device = Device.new(100000001, @dt1, 365, state_machine)
      device.save.must_equal true
      dev_restored = Device.last
      dev_restored[:state_machine].must_equal device[:state_machine]
    end

    it 'fills created_at after saving' do
      @device.created_at.must_be_nil
      @device.save.must_equal true
      @device.created_at.wont_be_nil
    end

    it 'fills updated_at after saving' do
      @device.updated_at.must_be_nil
      @device.save.must_equal true
      @device.updated_at.wont_be_nil
    end
  end

  describe "#forward" do
    it 'should add a DeviceLog' do
      @device.device_logs.size.must_equal 0
      @device.forward
      @device.device_logs.size.must_equal 1
      el_device_log @device.device_logs.last
      @device.save.must_equal true
      device_reload = Device.last
      device_reload.device_logs.last.must_equal el_device_log
    end
  end
end
