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
end
