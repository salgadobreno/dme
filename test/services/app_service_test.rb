require 'test_helper'
require 'app/services/app_service'

describe AppService do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    @am_device = create :am_device
    @service = AppService.new
  end

  after do
    DatabaseCleaner.clean
  end

  describe "#add" do
    it 'should add a new DeviceSo' do
      count = DeviceSo.count
      r = @service.add @am_device.serial_number
      r[:success].must_equal true
      DeviceSo.count.must_equal (count+1)
      DeviceSo.last.serial_number.must_equal @am_device.serial_number
    end

    describe "when serial_number is nonexistent" do
      it 'should return hash with message' do
        r = @service.add "4920409"
        r[:success].wont_equal true
        r[:message].wont_equal nil
      end
    end
  end

  describe "#run_seed" do
    it 'should clear db and setup AmDevices' do
      create :device_so
      create :device_so
      create :device_so
      DeviceSo.count.must_be :>, 0
      DeviceSo.first.tap do |d|
        d.forward
        d.forward
        d.forward
        d.save!
      end
      DeviceLog.count.must_be :>, 0
      r = @service.run_seed
      r[:success].must_equal true
      DeviceSo.count.must_equal 0
      DeviceLog.count.must_equal 0
      AmDevice.count.must_be :>, 0
    end
  end

  describe "#run_light_seed" do
    it 'should clear DeviceSos without erasing DeviceLogs' do
      create :device_so
      create :device_so
      create :device_so
      DeviceSo.count.must_be :>, 0
      DeviceSo.first.tap do |d|
        d.forward
        d.forward
        d.forward
        d.save!
      end
      DeviceLog.count.must_be :>, 0
      r = @service.run_light_seed
      r[:success].must_equal true
      DeviceSo.count.must_equal 0
      DeviceLog.count.wont_equal 0
      AmDevice.count.must_be :>, 0
    end
  end

  describe "#show_log" do
    it 'grabs complete log for a serial_number even if its not in Lab' do
      serial_number = 888888
      am_device = create :am_device, serial_number: serial_number

      dso = create :device_so, am_device: am_device
      dso.forward
      dso.forward
      dso.forward
      dso.destroy #"no longer in lab"

      device_log_count = dso.device_logs.count
      r = @service.show_log serial_number
      r[:success].must_equal true
      r[:data].size.must_equal device_log_count
    end
  end

  describe "#forward_all" do
    it 'forwards all devices in lab' do
      create :device_so
      create :device_so
      create :device_so
      DeviceSo.all.each do |d|
        d.current_state.to_s.must_equal "aceptance"
      end

      @service.forward_all[:success].must_equal true
      DeviceSo.all.each do |d|
        d.current_state.to_s.must_equal "triage"
      end
    end
  end

  describe "#run_complete" do
    it 'forwards all devices in lab until they`re segregated or finished' do
      state_fail = State.new :fail, :validations => [ lambda {|k,v| false } ]
      state_fail.validate({}, nil).must_equal false

      pass1 = create :device_so, state_machine: DefaultStateMachine.new
      pass2 = create :device_so, state_machine: DefaultStateMachine.new
      fail1 = create :device_so, state_machine: StateMachine.new([StateAceptance.new, StateTriage.new, state_fail, StateExpedition.new])

      @service.run_complete[:success].must_equal true

      [pass1, pass2].each do |d|
        d.reload.finished.must_equal true
        d.reload.current_state.to_s.must_equal "expedition" # "finished"
        #TODO NOTE: Breno: I'm still unclear on the `finish line` business logic in this, so I'm leaving it
        #at "expedition" because currently the "finished" would remove the device from the Lab,
        #this would make the app harder to understand ATM
      end
      fail1.reload.current_state.to_s.must_equal "segregated"
    end
  end

  describe "#overview" do
    it 'gets data for the number of devices in each state in the lab' do
      create :device_so, state_machine: StateMachine.new([StateAceptance.new])
      create :device_so, state_machine: StateMachine.new([StateTriage.new])
      create :device_so, state_machine: StateMachine.new([StateExpedition.new])
      create :device_so, state_machine: StateMachine.new([StateSegregated.new])

      r = @service.overview
      r[:success].must_equal true
      r[:data][:aceptance].must_equal 1
      r[:data][:triage].must_equal 1
      r[:data][:expedition].must_equal 1
      r[:data][:segregated].must_equal 1
    end
  end

  describe "#segregated_overview" do
    it 'gets segregated devices and data about previous state' do
      class StateFail < State
      end
      state_fail = StateFail.new "fail"
      #state_fail.stubs(:validate).returns(false)
      StateFail.any_instance.stubs(:validate).returns(false)
      #state_fail = State.new "fail", :validations => [Proc.new {|k,v| false}]
      stm = StateMachine.new [StateAceptance.new, StateTriage.new, state_fail, StateExpedition.new]
      list = []
      list << create(:device_so, state_machine: stm)
      list << create(:device_so, state_machine: stm)
      list << create(:device_so, state_machine: stm)
      list << create(:device_so, state_machine: stm)
      list.each {|d| 5.times { d.reload.forward; d.save! }}
      r = JSON.parse(@service.segregated_overview.to_json)
      r["success"].must_equal true
      r["data"].size.must_equal 4
      r["data"].first["previous_state"].must_equal "fail"
    end
  end
end
