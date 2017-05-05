require "test_helper"
require "mongoid"
require "database_cleaner"
require "date"

describe DeviceLog do
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

  it "should create a new DeviceLog registry in the database" do
    model = DeviceLog.new(@device, "Entrando na manutencao")
    model.wont_be_nil
    model.save.must_equal true
    DeviceLog.count.must_be :==, 1
    DeviceLog.first.description.must_equal model.description
  end

  it "should not create an invalid Device history Log" do
    proc{ DeviceLog.new }.must_raise ArgumentError
  end
end
