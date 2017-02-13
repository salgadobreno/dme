require "minitest/autorun"
require_relative "state_machine.rb"

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
    @state_machine = StateMachine.new [:inicio, :fim], {:add_index => Proc.new{|x| x+1}}
  end

  describe "when creating a new state machine configuration" do
      it "should load a machine with the basic states" do
        @state_machine.machine_states.must_equal [:inicio, :fim]
        # state_machine = StateMachine.new :inicio, :fim
        # assert_equal state_machine.machine_states, [:inicio]
      end

      it "should find the add_index operation" do
        @state_machine.operations.must_include :add_index
      end

      it "should perform add_index operation" do
        @state_machine.execute(:add_index).must_equal 1
      end
  end
end
