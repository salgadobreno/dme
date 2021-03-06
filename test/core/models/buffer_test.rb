require 'test_helper'
require 'date'

DEFAULT_WARRANTY_DAYS = 365

describe Buffer, "A list of Devices in the maintenance lifecycle that executes actions in batch and keeps track of Device states" do
  before do
    @add_index_op = lambda { |x|
      x[:index] ||= 0
      x[:index] += 1
    }
    @even_validation = lambda { |x|
      if x[:index].even?
        true
      else
        x[:error] = 'Valor não é par:' + x[:index].to_s
        false
      end
    }
    @state_inicio = State.new :inicio, {
      :executions => [@add_index_op],
      :validations => [@even_validation]
    }
    @state_fim = State.new :fim, {
      :executions => nil,
      :validations => nil
    }

    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    #TODO: Breno: vou 'configurar' o payload na mao mas teremos que rever essa parte
    @am_device = AmDevice.new 0, Time.now, DEFAULT_WARRANTY_DAYS, false
    @devices = [
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 0})),
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 1})),
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 2})),
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 3})),
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 4})),
      DeviceSo.new(@am_device, StateMachine.new([@state_inicio, @state_fim], {index: 5})),
    ]

    @buffer = Buffer.new @devices
  end

  it "organize devices according to their state" do
    @buffer.devices.must_equal({:inicio => @devices})
  end

  it "batch runs state machine operations" do
    @devices.each {|i| i.expects :forward}
    @buffer.send_forward
  end

  it "keeps track of devices across states" do
    # NOTE: Keeping this code becaus we expect to use the Buffer idea soon
    # @buffer.send_forward
    # @buffer.devices[:inicio].size.must_equal 3
    # @buffer.devices[:fim].size.must_equal 3
  end

  describe "#add, #rm" do
    it 'adds and removes a device' do
      state = @state_fim
      device = DeviceSo.new(@am_device,  StateMachine.new([state], {index: 0}))
      @buffer.add device
      @buffer.devices[:fim].must_include device
      @buffer.rm device
      @buffer.devices[:fim].must_be_nil
    end
  end
end
