ENV["MONGODB_CFG_PATH"] ||= File.expand_path('../../config', __FILE__) + "/mongoid.yml"

require "dashboard_init"
require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require "mongoid"
require "database_cleaner"
require "models/avixy_device.rb"
require "models/device_history.rb"
require "date"

describe AvixyDevice do
  $db_conn = nil

  before do
    if $db_conn.nil?
      $db_conn = Mongoid.load! ENV['MONGODB_CFG_PATH'], :development
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  # TODO: Move all db config to Rakefile?
  after do
    DatabaseCleaner.clean
  end

  it "shoudl create a new AvixyDevice into the Databse" do
    dt1 = DateTime.now
    @avixy_device = AvixyDevice.new(:serial_number => '100000001', :sold_at => dt1, :warranty_days => 365)
    @avixy_device.save.must_equal true
    AvixyDevice.count.must_be :==, 1
    AvixyDevice.first.sold_at.to_s.must_equal dt1.to_s
  end
end
