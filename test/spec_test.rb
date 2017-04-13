require 'test_helper'
require 'date'

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
        :operation => [@add_index_op],
        :validation => [@even_validation]
      }
      @state_fim = State.new :fim, {
        :operation => nil,
        :validation => nil
      }

      @state_machine = StateMachine.new [@state_inicio, @state_fim]
  end

  describe "when creating a new state machine configuration" do
    it "should load a machine with the basic states" do
      @state_machine.machine_states.must_equal [@state_inicio, @state_fim]
    end

    it "should be at the initial state" do
      @state_machine.current_state.must_equal @state_inicio
    end

    it 'should answer #has_next?' do
      @state_machine.has_next?.must_equal true
    end

    describe "when the item is valid" do
      before do
        @state_machine.payload[:index] = 1 # force even index after +1 op
      end

      it "should move to next state successfully" do
        @state_machine.forward.must_equal true
        @state_machine.current_state.must_equal @state_fim
      end
    end

    describe "when the item is invalid" do
      before do
        @state_machine.payload[:index] = 0 # force odd index after +1 op
      end

      it "should remain in the previous state" do
        @state_machine.forward.must_equal false
        @state_machine.current_state.must_equal @state_inicio
      end

      it "should include error in the payload" do
        @state_machine.forward
        refute @state_machine.payload[:error] == nil
      end
    end

    describe "when the StateMachine is finished" do
      it 'should ???' do
        skip "TODO"
      end
    end

    describe "when its in the initial state" do
      it 'should still answer has_next?' do
        skip "TODO"
      end
    end

  end

  describe Device, "A product in the maintenance lifecycle" do
    before do
      # device will receive the configured state machine
      @state_inicio = State.new :inicio, {
        :operation => nil,
        :validation => nil
      }
      @state_fim = State.new :fim, {
        :operation => nil,
        :validation => nil
      }

      @state_machine = StateMachine.new [@state_inicio, @state_fim]
      @device = Device.new(1234,
                           Time.now,
                           365,
                           @state_machine
                          )
    end

    it "delegates it's state to the state machine" do
      @device.current_state.must_equal @state_machine.current_state
    end

    it "delegates forwarding of state to the state machine" do
      @device.forward
      @device.current_state.must_equal @state_fim
    end

    it 'registers state events' do
      @device.events.size.must_equal 0
      @device.forward
      @device.events.size.must_equal 1
    end
  end

end
