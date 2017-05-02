$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..")))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'minitest/autorun'
require 'mocha/mini_test'
require 'dashboard_init'

module MiniTest
  module Assertions
    def refute_raises *exp
      begin
        yield
      rescue MiniTest::Skip => e
        return e if exp.include? MiniTest::Skip
        raise e
      rescue Exception => e
        exp = exp.first if exp.size == 1
        flunk "unexpected exception raised: #{e}"
      end

    end
  end
  module Expectations
    infect_an_assertion :refute_raises, :wont_raise
  end
end
