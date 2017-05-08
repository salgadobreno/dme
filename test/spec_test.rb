require 'test_helper'
require 'date'

describe StateMachine, "Maintenance interaction cycle definition" do

  let(:payload) {
    {}
  }
  let(:add_index_op) {
    lambda { |x|
      x[:index] ||= 0
      x[:index] += 1
    }
  }
  let(:even_validation) {
    lambda { |x|
      if x[:index].even?
        true
      else
        x[:error] = 'Valor não é par:' + x[:index].to_s
        false
      end
    }
  }
  let(:state_inicio) {
    State.new :inicio, {
      :operations => [add_index_op],
      :validations => [even_validation]
    }
  }
  let(:state_fim) {
    State.new :fim, {
      :operation => nil,
      :validation => nil
    }
  }
  let(:state_machine) {
    StateMachine.new [state_inicio, state_fim]
  }

  describe "when creating a new state machine configuration" do
    it "should load a machine with the basic states" do
      state_machine.states.must_equal [state_inicio, state_fim]
    end

    it "should be at the initial state" do
      state_machine.current_state.must_equal state_inicio
    end

    it 'should answer #has_next?' do
      state_machine.has_next?.must_equal true
    end

    describe "when the item is valid" do
      before do
        state_machine.payload[:index] = 1 # force even index after +1 op
      end

      it "should move to next state successfully" do
        state_machine.forward.must_equal true
        state_machine.current_state.must_equal state_fim
      end
    end

    describe "when the item is invalid" do
      before do
        state_machine.payload[:index] = 0 # force odd index after +1 op
      end

      it "should remain in the previous state, include error in the payload" do
        state_machine.forward.must_equal false
        state_machine.current_state.must_equal state_inicio
        state_machine.payload[:error].wont_equal nil
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
    let(:state_inicio) {
      State.new :inicio, {
        :operation => nil,
        :validation => nil
      }
    }
    let(:state_fim) {
      State.new :fim, {
        :operation => nil,
        :validation => nil
      }
    }
    let(:state_machine) {
      StateMachine.new [state_inicio, state_fim]
    }
    let(:am_device) { AMDevice.new 1234, Time.now, 365 }
    let(:device) {
      Device.new am_device, state_machine
    }

    it "delegates it's state to the state machine" do
      device.current_state.must_equal state_machine.current_state
    end

    it "delegates forwarding of state to the state machine" do
      device.forward
      device.current_state.must_equal state_fim
    end

    it 'registers state events' do
      #TODO: must update with DeviceHistory
      device.device_histories.size.must_equal 0
      device.forward
      device.device_histories.size.must_equal 1
    end
  end
end
