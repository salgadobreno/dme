require "test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe DeviceSo do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @dt1 = DateTime.now
    @serial_number = 100000001
    @warranty = 365

    @state_inicio = State.new :inicio, { :operation => nil, :validation => nil }
    @state_fim = State.new :fim, { :operation => nil, :validation => nil }
    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    @am_device = AmDevice.new @serial_number, @dt1, @warranty
    @am_device.save.must_equal true
    @device = DeviceSo.new @am_device, @state_machine
  end

  after do
    DatabaseCleaner.clean
  end

  describe "database operations" do

    it "should create a new DeviceSo into the Databse" do
      @device.save.must_equal true
      DeviceSo.count.must_be :==, 1
      DeviceSo.first.sold_at.to_s.must_equal @dt1.to_s
    end

    it 'requires AmDevice' do
      proc { device = DeviceSo.new(nil, @state_machine) }.must_raise ArgumentError
    end

    it 'requires StateMachine' do
      proc { device = DeviceSo.new(@am_device, nil) }.must_raise ArgumentError
    end

    it "should not save invalid DeviceSo" do
      proc { device = DeviceSo.new }.must_raise ArgumentError
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

      device = DeviceSo.new(@am_device, state_machine)
      device.save.must_equal true
      dev_restored = DeviceSo.last
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
    it 'should add a DeviceHistory' do
      @device.device_histories.size.must_equal 0
      @device.forward
      @device.device_histories.size.must_equal 1
    end
  end
end
