$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/app")
ENV["MONGODB_CFG_PATH"] ||= File.expand_path(File.dirname(__FILE__)) + "/config/mongoid.yml"

if ENV["RACK_ENV"].nil?
  ENV["RACK_ENV"] = "development"
end

if ENV["RACK_ENV"] == "production"
  @db_environment = :production
elsif ENV["RACK_ENV"] == "test"
  @db_environment = :test
else
  @db_environment = :development
end

require 'pry'
require 'awesome_print'
require 'app/core/models/state'
require 'app/core/operations'
require 'app/core/models/device_so'
require 'app/core/states'
require 'app/core/models/state_machine'
require 'app/core/models/buffer'
require 'app/lib/app_log'
require 'app/core/asset_manager/am_device'
require 'app/core/models/device_log'
require 'app/core/state_machines'

# configure the database
Mongoid.load! ENV['MONGODB_CFG_PATH'], @db_environment
