#this will be the absolute path to lib based on the calling __FILE__
lib = File.expand_path('../app', __FILE__)
#this will include the path in $LOAD_PATH unless it is already included
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rake/testtask"
require "mongoid"
require "database_cleaner"
require "date"
require "models/avixy_device"

task default: [:test]

def cli_colored_text(color_code, text)
  "\e[#{color_code}#{text}\e[0m"
end

def error(text)
  puts cli_colored_text("1;31m", text)
end

def warning(text)
  puts cli_colored_text("1;33m", text)
end

def success(text)
  puts cli_colored_text("1;32m", text)
end

def puts_result(text)
  puts cli_colored_text("1;36m", text)
end

desc "Run all applicaiton tests"
Rake::TestTask.new do |t|
  t.libs.push '.'
  t.pattern = "test/*_test.rb"
end

namespace :db do
  $db_conn = nil

  def clean_database
    begin
      DatabaseCleaner.clean
    rescue => error
      error "Error while cleaning the database: #{error}"
      abort
    end
  end

  task :db_config do
    if $db_conn.nil?
      $db_conn = Mongoid.load! "#{File.expand_path(File.dirname(__FILE__))}/test/mongoid.yml", :development
    end

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    # drop the previous database fixtures
    clean_database
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
