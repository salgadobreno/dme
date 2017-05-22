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
        state_machine.forward(nil).must_equal true
        state_machine.current_state.must_equal state_fim
      end
    end

    describe "when the item is invalid" do
      before do
        state_machine.payload[:index] = 0 # force odd index after +1 op
      end

      it "should remain in the previous state, include error in the payload" do
        state_machine.forward(nil).must_equal false
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

  describe DeviceSo, "A product in the maintenance lifecycle" do
    let(:state_inicio) {
      State.new :inicio, {
        :operations => nil,
        :validations => nil
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
    let(:am_device) { AmDevice.new 1234, Time.now, 365, false }
    let(:device) {
      DeviceSo.new am_device, state_machine
    }

    it "delegates it's state to the state machine" do
      device.current_state.must_equal state_machine.current_state
    end

    it "delegates forwarding of state to the state machine" do
      device.forward
      device.current_state.must_equal state_fim
    end

    it 'registers state change events' do
      device.device_logs.size.must_equal 0
      device.forward
      device.device_logs.size.must_be :>=, 1
    end

    describe "Operations/validations DeviceLogs" do
      let(:state_inicio) {
        State.new :inicio, {
          :operations => [lambda {|payload,device|
            #do stuff
            device.device_logs << DeviceLog.new(device, 'done stuff')
          }],
          :validations => [lambda {|payload,device|
            #check stuff
            device.device_logs << DeviceLog.new(device, 'checked stuff')
          }]
        }
      }

      it "should be capable of adding DeviceLogs to the Device" do
        device.save
        previous_size = device.reload.device_logs.size
        device.forward # should +1 in operation, +1 in validation
        device.device_logs.size.must_be :>=, (previous_size + 2)
      end
    end
  end
end
