require "test/helper/test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe DeviceHistory do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    dt1 = DateTime.now
    @avixy_device = AvixyDevice.new(:serial_number => '100000001', :sold_at => dt1, :warranty_days => 365)
    @avixy_device.save
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new DeviceHistory registry in the database" do
    model = DeviceHistory.new(:avixy_device => @avixy_device,
                              :description => "Entrando na manutencao",
                              :registered_at => DateTime.now)
    model.wont_be_nil
    model.save.must_equal true
    DeviceHistory.count.must_be :==, 1
    DeviceHistory.first.description.must_equal model.description
  end

  it "should not save an invalid history log" do
    DeviceHistory.new.save.must_equal false
  end
end
