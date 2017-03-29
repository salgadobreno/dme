require "irb"
require "minitest/autorun"
require "mocha/mini_test"
require "app/state_machine"
require "app/state"
require "app/item"
require "app/buffer"

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
        :execution => [@add_index_op],
        :validation => [@even_validation]
      }
      @state_fim = State.new :fim, {
        :execution => nil,
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

    describe "when the item is valid" do
      before do
        @state_machine.payload[:index] = 1 # force even index after +1 op
      end

      it "should move to next state successfully" do
        @state_machine.forward
        @state_machine.current_state.must_equal @state_fim
      end
    end

    describe "when the item is invalid" do
      before do
        @state_machine.payload[:index] = 0 # force odd index after +1 op
      end

      it "should remain in the previous state" do
        @state_machine.forward
        @state_machine.current_state.must_equal @state_inicio
      end

      it "should include error in the payload" do
        @state_machine.forward
        refute @state_machine.payload[:error] == nil
      end
    end
  end

  describe Item, "An Item in the maintenance lifecycle" do
    before do
      # item will receive the configured state machine
      @state_inicio = State.new :inicio, {
        :execution => nil,
        :validation => nil
      }
      @state_fim = State.new :fim, {
        :execution => nil,
        :validation => nil
      }

      @state_machine = StateMachine.new [@state_inicio, @state_fim]
      @item = Item.new 1234, @state_machine
    end

    it "delegates it's state to the state machine" do
      @item.current_state.must_equal @state_machine.current_state
    end

    it "delegates forwarding of state to the state machine" do
      @item.forward
      @item.current_state.must_equal @state_fim
    end
  end

  describe Buffer, "A list of items that executes actions in batch and keeps track of Item states" do
    before do
      #TODO: Breno: vou 'configurar' o payload na mao mas teremos que rever essa parte
      @items = [
        Item.new(0, StateMachine.new([@state_inicio, @state_fim], {index: 0})),
        Item.new(1, StateMachine.new([@state_inicio, @state_fim], {index: 1})),
        Item.new(2, StateMachine.new([@state_inicio, @state_fim], {index: 2})),
        Item.new(3, StateMachine.new([@state_inicio, @state_fim], {index: 3})),
        Item.new(4, StateMachine.new([@state_inicio, @state_fim], {index: 4})),
        Item.new(5, StateMachine.new([@state_inicio, @state_fim], {index: 5})),
      ]

      @buffer = Buffer.new @items
    end

    it "organizes items according to their state" do
      @buffer.items.must_equal({:inicio => @items}) # name of @state_inicio
    end

    it "batch runs state machine operations" do
      @items.each {|i| i.expects :forward}
      @buffer.send_forward
    end

    it "keeps track of items across states" do
      @buffer.send_forward
      #state_inicio_name = @state_inicio.name
      #state_fim_name = @state_inicio.name
      @buffer.items[:inicio].size.must_equal 3
      @buffer.items[:fim].size.must_equal 3
    end
  end
end

