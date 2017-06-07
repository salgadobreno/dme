require 'test_helper'
require "database_cleaner"

describe StateMachine do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @payload = {}
    @add_index_op = lambda { |x,d|
      x[:index] ||= 0
      x[:index] += 1
    }
    @even_validation = lambda { |x,d|
      if x[:index].even?
        true
      else
        x[:error] = 'Valor não é par: ' + x[:index].to_s
        false
      end
    }
    @state_inicio = State.new :inicio, {
      :operation => [@add_index_op],
      :validation => [@even_validation]
    }
    @state_fim = State.new :fim, {
      :operation => nil,
      :validation => nil
    }
    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    @am_device = AmDevice.new @serial_number, @dt1, @warranty, false
    @device = DeviceSo.new @am_device, @state_machine
  end

  after do
    DatabaseCleaner.clean
  end

  describe "database operations" do
    it "should restore current state" do
      prev_curr_state = @state_machine.current_state
      @state_machine.forward(@device).must_equal true
      curr_state_after_forward = @state_machine.current_state
      (prev_curr_state != curr_state_after_forward).must_equal true

      @state_machine.save.must_equal true
      stm_restored = DeviceSo.last.state_machine
      stm_restored.current_state.must_equal curr_state_after_forward
    end
  end

  describe "alternative state procedures" do
    it "set to segregated state when forward fails" do
      @state_inicio.stubs(:validate).returns(false)
      @state_machine.forward(@device).must_equal false
      @state_machine.current_state.must_equal StateMachine::SEGREGATED_STATE
    end

    it "treat error and send to the segregated state" do
      @state_inicio.stubs(:validate).raises(Exception, 'undefined error')
      @state_machine.forward(@device).must_equal false
      @state_machine.current_state.must_equal StateMachine::SEGREGATED_STATE
      @am_device.device_logs.last.description.must_match /undefined error/
    end    
  end
  
end
