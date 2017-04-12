require 'test_helper'
require "database_cleaner"

describe State do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  let(:operation) {
    lambda { |x|
      x[:index] ||= 0
      x[:index] += 1
    }
  }
  let(:validation) {
    lambda { |x|
      x[:index].even? ?  true : x[:error] = "Valor não é par: #{x[:index]}"; false
    }
  }
  let(:state) { State.new "state", {execution: [operation], validation: [validation]} }
  let(:payload) { {} }

  it "has name" do
    state.respond_to?(:name).must_equal true
  end

  it "has Operation/Validation callbacks" do
    state.respond_to?(:validations).must_equal true
    state.respond_to?(:operations).must_equal true
  end

  describe "when callbacks are empty/nil" do
    let(:state_nil)   { State.new "state", {operations: nil, validations: nil} }
    let(:state_empty) { State.new "state", {operations: [], validations: []} }
    let(:state_not_empty_but_nil) { State.new "state", {operations: [nil], validations: [nil]} }

    it "should not explode" do
      state_nil.execute(payload)
      state_empty.execute(payload)
      state_not_empty_but_nil.execute(payload)
    end
  end

  describe "#execute" do
    it "should call operations" do
      operation.expects(:call)
      state.execute payload
    end
  end

  describe "#validate" do
    it "should call validations" do
      validation.expects :call
      state.validate payload
    end
  end

  describe "database operations" do
    it "should save a new State into the Databse" do
      state.save.must_equal true
      State.count.must_equal 1
      State.first.name.must_equal state.name
    end

    describe "Saving and Restoring" do
      let(:operation) {
        lambda {|x| $global ||= 0; $global += 1 }
      }
      let(:validation) {
        lambda {|x| $global_v ||= 0; $global_v += 1 }
      }
      describe "when Operation/Validation is Proc/Lambda" do
        it "should store and restore the Block successfully" do
          state.execute payload
          $global.must_equal 1
          state.validate payload
          $global_v.must_equal 1
          state.save.must_equal true
          state_reloaded = State.all.last
          state_reloaded.execute payload
          $global.must_equal 2
          state_reloaded.validate payload
          $global_v.must_equal 2
        end
      end
      describe "when Operation/Validation is a Class" do
        it "should serialize and deserialize the Class successfully"
      end
    end
  end
end
