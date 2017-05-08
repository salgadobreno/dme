require 'test_helper'
require "database_cleaner"

describe State do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @operation = lambda { |x|
      x[:index] ||= 0
      x[:index] += 1
    }
    @validation = lambda { |x|
      x[:index].even? ?  true : x[:error] = 'Valor não é par:' + x[:index].to_s
      false
    }
    state = State.new "state", {operations: [@operation], validations: [@validation]}
    state_machine = StateMachine.new [state]
    am_device = AMDevice.new 000, DateTime.now, 1
    @device = Device.new am_device, state_machine
    @state = state_machine.states.first

    @payload = {}
  end

  after do
    DatabaseCleaner.clean
  end

  it "has name" do
    @state.respond_to?(:name).must_equal true
  end

  it "has Operation/Validation callbacks" do
    @state.respond_to?(:validations).must_equal true
    @state.respond_to?(:operations).must_equal true
  end

  describe "when callbacks are empty/nil" do
    let(:state_nil)   { State.new "state", {operations: nil, validations: nil} }
    let(:state_empty) { State.new "state", {operations: [], validations: []} }

    it "should not explode" do
      state_nil.execute(@payload)
      state_empty.execute(@payload)
    end
  end

  describe "#execute and #validate" do
    it "should call validations/operations on #execute/#validate" do
      @operation.expects :call
      @validation.expects :call

      #Workaround for behavior where the object in state.operations isn't the same
      #in memory as operations one
      @state.stubs(:operations).returns([@operation])
      @state.stubs(:validations).returns([@validation])

      @state.execute @payload
      @state.validate @payload
    end
  end

  describe "database operations" do
    it "should save a new State into the Databse" do
      #@device.save.must_equal true # ???
      @state.save.must_equal true
      #State.first.name.must_equal state.name
      #State.count.must_equal 1
      #NOTE: it is embedded, so no count changes
    end

    describe "Saving and Restoring" do
      before do
        @operation = lambda {|x| $global ||= 0; $global += 1 }
        @validation = lambda {|x| $global_v ||= 0; $global_v += 1 }
        state = State.new "state", {operations: [@operation], validations: [@validation]}
        state_machine = StateMachine.new [state]
        am_device = AMDevice.new 000, DateTime.now, 1
        device = Device.new am_device, state_machine
        @state = state_machine.states.first
      end

      describe "when Operation/Validation is Proc/Lambda" do
        it "should store and restore the Block successfully" do
          @state.execute @payload
          $global.must_equal 1
          @state.validate @payload
          $global_v.must_equal 1
          @state.save.must_equal true
          state_reloaded = Device.last.state_machine.states.select { |st| st == @state }.first
          state_reloaded.execute @payload
          $global.must_equal 2
          state_reloaded.validate @payload
          $global_v.must_equal 2
        end
      end
      describe "when Operation/Validation is a Class" do

        class ExampleOperation < State::Operation
          def call payload
            $c_global ||= 0
            $c_global += 1
          end
        end

        class ExampleValidation < State::Validation
          def call payload
            $c_v_global ||= 0
            $c_v_global += 1
          end
        end

        before do
          @operation = ExampleOperation.new
          @validation = ExampleValidation.new
          state = State.new "state", {operations: [@operation], validations: [@validation]}
          state_machine = StateMachine.new [state]
          am_device = AMDevice.new 000, DateTime.now, 1
          device = Device.new am_device, state_machine
          @state = state_machine.states.first
        end

        it "should serialize and deserialize the Class successfully" do
          @state.execute @payload
          $c_global.must_equal 1
          @state.validate @payload
          $c_v_global.must_equal 1
          @state.save.must_equal true
          state_reloaded = Device.last.state_machine.states.select { |st| st == @state }.first
          state_reloaded.execute @payload
          $c_global.must_equal 2
          state_reloaded.validate @payload
          $c_v_global.must_equal 2
        end
      end
    end
  end
end
