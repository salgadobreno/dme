require "minitest/autorun"
require_relative "state_machine.rb"

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
      @state_inicio = State.new :inicio, {
        :execute => [Proc.new {puts "inicio"}],
        :validation => nil
      }

      @state_fim = State.new :fim, {
        :execute => nil,
        :validation => [Proc.new {return true}]
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

    it "should forward to the next state" do
      @state_machine.forward
      @state_machine.current_state.must_equal @state_fim
    end
  end
end
