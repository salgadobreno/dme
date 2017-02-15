require "minitest/autorun"
require "mocha/mini_test"
require_relative "state_machine.rb"

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
      @payload = {}
      @add_index_op = lambda { |x|
        x[:index] ||= 0
        x[:index] += 1
      }
      @even_validation = lambda { |x|
        if x[:index].even?
          true
        else
          x[:error] = "Valor não é par: #{x[:index]}"
          false
        end
      }
      @state_inicio = State.new :inicio, {
        :execution => [@add_index_op],
        :validation => [@even_validation]
      }
      @state_fim = State.new :fim, {
        :execution => nil,
        :validation => nil
      }

      @state_machine = StateMachine.new @state_inicio, @state_fim
  end

  describe "when creating a new state machine configuration" do
    it "should load a machine with the basic states" do
      @state_machine.machine_states.must_equal [@state_inicio, @state_fim]
    end

    it "should be at the initial state" do
      @state_machine.current_state.must_equal @state_inicio
    end

    describe "when the item is valid" do
      before do
        @state_machine.payload[:index] = 1 # force even index after +1 op
      end

      it "should move to next state successfully" do
        @state_machine.forward
        @state_machine.current_state.must_equal @state_fim
      end
    end

    describe "when the item is invalid" do
      before do
        @state_machine.payload[:index] = 0 # force odd index after +1 op
      end

      it "should remain in the previous state" do
        @state_machine.forward
        @state_machine.current_state.must_equal @state_inicio
      end

      it "should include error in the payload" do
        @state_machine.forward
        refute @state_machine.payload[:error] == nil
      end
    end

    #it "should execute the operation and the validation" do
      #@proc_add_index.expects :call
      #@proc_validation.expects :call
      #@state_machine.forward
    #end
  end
end
