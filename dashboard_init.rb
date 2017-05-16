$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/app")
ENV["MONGODB_CFG_PATH"] ||= File.expand_path(File.dirname(__FILE__)) + "/config/mongoid.yml"

@db_environment = :development
if ENV["APP_ENV"].nil?
  ENV["APP_ENV"] = "test"
end

if ENV["APP_ENV"] == "test"
  @db_environment = :development
elsif ENV["APP_ENV"] == "development"
  @db_environment = :development
else
  @db_environment = :production
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
