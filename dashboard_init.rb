$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/app")
ENV["MONGODB_CFG_PATH"] ||= File.expand_path(File.dirname(__FILE__)) + "/config/mongoid.yml"

if ENV["RACK_ENV"].nil?
  ENV["RACK_ENV"] = "development"
end

if ENV["RACK_ENV"] == "production"
  @db_environment = "production"
elsif ENV["RACK_ENV"] == "test"
  @db_environment = :test
else
  @db_environment = :development
end

require 'pry'
require 'awesome_print'
require 'app/models/state'
require 'app/models/state_machine'
require 'app/models/buffer'
require 'app/app_log'
require 'app/asset_manager/am_device'
require 'app/models/device_so'
require 'app/models/device_log'
require 'app/operations'

# configure the database
Mongoid.load! ENV['MONGODB_CFG_PATH'], @db_environment
