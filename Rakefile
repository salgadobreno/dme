require "rake/testtask"
require "mongoid"
require "database_cleaner"
require "date"

task default: [:test]

desc "Run all applicaiton tests"
Rake::TestTask.new do |t|
  t.libs.push '.'
  t.pattern = "test/*_test.rb"
end

namespace :db do
  $db_conn = nil

  task :db_config do
    if $db_conn.nil?
      $db_conn = Mongoid.load! "#{File.expand_path(File.dirname(__FILE__))}/test/mongoid.yml", :development
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end
  end

  desc "create the project fixtures"
  task :seed => :db_config do
    class AvixyDevice 
      include Mongoid::Document

      field :serial_number, type: String
      field :sold_at, type: DateTime
      field :warranty_days, type: Integer
    end

    # drop the previous database fixtures
    DatabaseCleaner.clean

    # exec the fixtures
    devices = []
    dt1 = DateTime.now
    dt2 = DateTime.now + 10
    devices << AvixyDevice.new(:serial_number => '100000001', :sold_at => dt1, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000002', :sold_at => dt1, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000003', :sold_at => dt1, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000004', :sold_at => dt1, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000005', :sold_at => dt1, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000006', :sold_at => dt2, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000007', :sold_at => dt2, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000008', :sold_at => dt2, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000009', :sold_at => dt2, :warranty_days => 365)
    devices << AvixyDevice.new(:serial_number => '100000010', :sold_at => dt2, :warranty_days => 365)
    devices.each{|s| s.save!}
  end
end
