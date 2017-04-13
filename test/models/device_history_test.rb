require "test/helper/test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe DeviceHistory do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    dt1 = DateTime.now
    @device = Device.new('100000001', dt1, 365, nil)
    @device.save
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new DeviceHistory registry in the database" do
    model = DeviceHistory.new(@device, "Entrando na manutencao")
    model.wont_be_nil
    model.save.must_equal true
    DeviceHistory.count.must_be :==, 1
    DeviceHistory.first.description.must_equal model.description
  end

  it "should not create an invalid history log" do
    proc{ DeviceHistory.new }.must_raise ArgumentError
  end
end
