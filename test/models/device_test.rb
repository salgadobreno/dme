require "test/helper/test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe Device do
  before do
    @dt1 = DateTime.now
    @device = Device.new( 100000001,
                         @dt1, 365, nil)

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new Device into the Databse" do
    @device.save.must_equal true
    Device.count.must_be :==, 1
    Device.first.sold_at.to_s.must_equal @dt1.to_s
  end

  it "should not save invalid Device" do
    device = nil
    proc { device = Device.new }.must_raise ArgumentError
  end

  it "should not save a device with non numeric serial number" do
    device = Device.new 'abdc', Time.now, 345, nil
    device.save.must_equal false
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
