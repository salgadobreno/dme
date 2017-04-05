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

require 'irb'
require 'awesome_print'
require 'app/state'
require 'app/state_machine'
require 'app/buffer'
require 'app/device'
require 'app/mock_db'
require 'app/app_log'


# configure the database
Mongoid.load! ENV['MONGODB_CFG_PATH'], @db_environment

