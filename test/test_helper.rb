$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..")))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'minitest/autorun'
require 'mocha/mini_test'
require 'dashboard_init'
require 'factory_girl'

class Minitest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

class Minitest::Spec
  include FactoryGirl::Syntax::Methods
end

FactoryGirl.find_definitions
