#this will be the absolute path to lib based on the calling __FILE__
lib = File.expand_path('../app', __FILE__)
#this will include the path in $LOAD_PATH unless it is already included
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
ENV["MONGODB_CFG_PATH"] ||= File.expand_path('../config', __FILE__) + "/mongoid.yml"

require "rake/testtask"
require "mongoid"
require "database_cleaner"
require "date"
require_relative "dashboard_init"
require "app_log"

task default: [:test]

desc "Run all applicaiton tests"
Rake::TestTask.new do |t|
  t.libs.push '.'
  t.pattern = [
    "test/*_test.rb",
    "test/models/*_test.rb",
    "test/functional/*_test.rb"
  ]
end

namespace :db do
  def clean_database
    DatabaseCleaner.clean
    return true
  rescue => error
    error "Error while cleaning the database: #{error}"
    return false
  end

  task :db_config do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    # drop the previous database fixtures
    if not clean_database
      abort "rake aborted!"
    end
  end

  desc "create the project fixtures"
  task :seed => :db_config do
    # exec the fixtures
    devices = []
    dt1 = DateTime.now
    dt2 = DateTime.now + 10
    # TODO: Move this initialization to a fixture file
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

  desc "clean the database"
  task :clean => :db_config do
    clean_database
  end
end

namespace :db do
  $db_conn = nil

  def clean_database
    DatabaseCleaner.clean
    return true
  rescue => error
    error "Error while cleaning the database: #{error}"
    return false

  end

  task :db_config do
    if $db_conn.nil?
      $db_conn = Mongoid.load! ENV["MONGODB_CFG_PATH"], :development
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    # drop the previous database fixtures
    if not clean_database
      abort "rake aborted!"
    end
  end

  desc "create the project fixtures"
  task :seed => :db_config do
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

  desc "clean the database"
  task :clean => :db_config do
    clean_database
  end
end
