require 'test_helper'
require "database_cleaner"

describe StateMachine do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end
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
        x[:error] = 'Valor não é par: ' + x[:index].to_s
        false
      end
    }
  }
  let(:state_inicio) {
    State.new :inicio, {
      :operation => [add_index_op],
      :validation => [even_validation]
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

  describe "database operations" do
    let(:even_validation) {
      lambda {|x| true}
    }
    it "should save a new State into the Databse" do
      state_machine.save.must_equal true
      StateMachine.count.must_equal 1
    end

    it "should restore current state" do
      #binding.irb
      state_machine.forward.must_equal true
      prev_curr_state = state_machine.current_state

      state_machine.save.must_equal true
      stm_restored = StateMachine.last
      stm_restored.current_state.must_equal prev_curr_state
    end

  end
  #it "requires name"
  #it "has Operation/Validation callbacks"
  #describe "when callbacks are empty/nil" do
    #it "should not explode"
  #end
  #describe "#execute" do
    #it "should call operations"
  #end
  #describe "#validate" do
    #it "should call validations"
  #end
  #describe "Saving and Restoring" do
    #describe "when Operation/Validation is Proc/Lambda" do
      #it "should store and restore the Block successfully"
    #end
    #describe "when Operation/Validation is a Class" do
      #it "should serialize and deserialize the Class successfully"
    #end
  #end
end
