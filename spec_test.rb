require "minitest/autorun"
require_relative "state_machine.rb"

describe StateMachine, "Maintenance interaction cycle definition" do
  before do
    @state_machine = StateMachine.new [:inicio, :fim],
      {:add_index => Proc.new{|x| x.index = x.index + 1}},
      {:even_index => Proc.new{|x| x.index % 2 == 0 ? true : false}}
  end

  describe "when creating a new state machine configuration" do
      it "should load a machine with the basic states" do
        @state_machine.machine_states.must_equal [:inicio, :fim]
      end

      it "should find the add_index operation" do
        @state_machine.operations.must_include :add_index
      end

      it "should perform add_index operation" do
        @state_machine.execute(:add_index).must_equal 1
      end

      it "should find the even_index rule" do
        @state_machine.rules.must_include :even_index
      end

      it "should verify even_index rule" do
        @state_machine.verify(:even_index).must_equal true #analysing 0
        @state_machine.execute(:add_index)
        @state_machine.verify(:even_index).must_equal false #analysing 1
      end
  end
end
