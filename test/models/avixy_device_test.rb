require "test/helper/test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe AvixyDevice do
  before do
    @dt1 = DateTime.now
    @avixy_device = AvixyDevice.new(:serial_number => 100000001,
                                      :sold_at => @dt1, :warranty_days => 365)

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new AvixyDevice into the Databse" do
    @avixy_device.save.must_equal true
    AvixyDevice.count.must_be :==, 1
    AvixyDevice.first.sold_at.to_s.must_equal @dt1.to_s
  end

  it "should not save invalid AvixyDevice" do
    device = AvixyDevice.new
    device.save.must_equal false
  end

  it "should not save a device with non numeric serial number" do
    device = AvixyDevice.new :serial_number => 'abdc'
    device.save.must_equal false
  end
end
