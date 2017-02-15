require "minitest/autorun"
require "mocha/mini_test"
require_relative "state_machine.rb"

class DevicePackage
  attr_reader :errors
  attr_accessor :index

  def initialize
    @index = 0
  end
end

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
      @device_package = DevicePackage.new
      @proc_add_index = Proc.new {|x| x.index = x.index + 1}
      @proc_filter_index = Proc.new {|x| x.index % 2 == 0 ? true : false}
      @proc_validation = Proc.new {|x| x.errors.nil? ? true : false }
      @state_inicio = State.new :inicio, {
        :payload => @device_package,
        :execute => [@proc_add_index],
        :validation => [@proc_validation]
      }

      @state_fim = State.new :fim, {
        :payload => @device_package,
        :execute => [@proc_filter_index],
        :validation => [@proc_validation]
      }

      @state_machine = StateMachine.new @state_inicio, @state_fim
  end

  describe "when creating a new state machine configuration" do
    it "should load a machine with the basic states" do
      @state_machine.machine_states.must_equal [@state_inicio, @state_fim]
    end

    it "should verify the initial state" do
      @state_machine.current_state.must_equal @state_inicio
    end

    it "should execute the operation and the validation" do
      @proc_add_index.expects :call
      @proc_validation.expects :call
      @state_machine.forward
    end

    it "should forward to the next state" do
      @proc_filter_index.expects :call
      @state_machine.forward
      @state_machine.current_state.must_equal @state_fim
      @state_machine.forward # to run the execute of the last state
    end
  end
end
