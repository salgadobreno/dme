$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)) + "/app")

require 'irb'
require 'awesome_print'
require 'app/state'
require 'app/state_machine'
require 'app/buffer'
require 'app/device'
require 'app/mock_db'
require 'app/app_log'
