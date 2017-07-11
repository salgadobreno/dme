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
end
