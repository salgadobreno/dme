require "minitest/autorun"
require_relative "test.rb"

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
    @state_machine = StateMachine.new :inicio, :fim
  end

  describe "when creating a new state machine configuration" do
      it "should load a machine with the basic states" do
        @state_machine.machine_states.must_equal [:inicio, :fim]
        # state_machine = StateMachine.new :inicio, :fim
        # assert_equal state_machine.machine_states, [:inicio]
      end
  end
end
