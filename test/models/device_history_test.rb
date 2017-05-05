require "test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe DeviceHistory do
  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    dt1 = DateTime.now
    @state_inicio = State.new :inicio, { :operation => nil, :validation => nil }
    @state_fim = State.new :fim, { :operation => nil, :validation => nil }
    @state_machine = StateMachine.new [@state_inicio, @state_fim]
    @device = Device.new('100000001', dt1, 365, @state_machine)
    @device.save
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new DeviceHistory registry in the database" do
    model = DeviceHistory.new(@device, "Entrando na manutencao")
    model.wont_be_nil
    model.save.must_equal true
    #DeviceHistory.count.must_be :==, 1
    #DeviceHistory.first.description.must_equal model.description
    #NOTE: embedded so no DeviceHistory.count changes
  end

  it "should not create an invalid history log" do
    proc{ DeviceHistory.new }.must_raise ArgumentError
  end
end
