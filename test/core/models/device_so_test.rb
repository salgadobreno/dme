require "test_helper"
require "mongoid"
require "database_cleaner"

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
    @am_device = AmDevice.new @serial_number, @dt1, @warranty, false
    @am_device.save.must_equal true
    @device = DeviceSo.new @am_device, @state_machine
  end

  after do
    DatabaseCleaner.clean
  end

  describe "database operations" do
    it "should create a new DeviceSo into the Databse" do
      count = DeviceSo.count
      @device.save.must_equal true
      DeviceSo.count.must_be :>, count
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

    it 'should not delete the DeviceLogs for a SerialNumber when DeviceSo is deleted' do
      serial_number = 67890
      am_device = create(:am_device, {serial_number: serial_number})
      @device = create(:device_so, {am_device: am_device})
      @device.forward
      @device.forward
      @device.forward
      @device.device_logs.count.wont_equal 0
      count = @device.device_logs.count
      @device.save.must_equal true
      @device2 = create(:device_so, {am_device: am_device})
      @device2.device_logs.count.must_be :>=, count
    end

    it 'should add an `exit` log when DeviceSo is deleted' do
      @device = create(:device_so)
      count = @device.am_device.device_logs.count
      @device.destroy
      @device.am_device.device_logs.count.must_equal count+1
      @device.am_device.device_logs.last.description.must_match /exit/
    end

    describe ".active scope" do
      before do
        @active = DeviceSo.new @am_device, @state_machine
        @finished = DeviceSo.new @am_device, @state_machine
        @finished.forward
        @finished.forward
        @active.save!
        @finished.save!
      end
      it 'filters finished DeviceServiceOrders' do
        DeviceSo.where(am_device: @am_device).active.to_a.must_include @active
        DeviceSo.where(am_device: @am_device).active.to_a.wont_include @finished
      end
    end
  end

  describe "#forward" do
    it 'should add a DeviceLog' do
      previous_size = @device.device_logs.size
      @device.forward
      @device.device_logs.size.must_be :>=, (previous_size + 1)
    end

    it 'should forward the state_machine state' do
      @device.forward
      @device.current_state.must_equal @state_fim
    end

    describe "when DeviceSo is at the last state" do
      it 'should mark the DeviceSo as terminated' do
        @device.forward
        @device.last_state?.must_equal true
        @device.forward
        @device.finished.must_equal true
        @device.current_state.must_equal StateMachine::DONE_STATE
      end
    end
  end

  describe "#log" do
    it 'adds a log' do
      prev_log_count = @device.device_logs.size
      @device.log "this is a test"
      @device.device_logs.size.must_equal prev_log_count + 1
      @device.device_logs.last.description.must_equal "this is a test"
    end
  end

  describe "#as_json" do
    it 'includes the relevant fields' do
      ["current_state", "previous_state", "sold_at", "serial_number", "warranty_days", "blacklisted", "device_logs"].each do |p|
        @device.as_json.keys.must_include p
      end
    end
  end
end
