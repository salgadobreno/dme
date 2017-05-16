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
    @am_device = AmDevice.new('100000001', dt1, 365)
    @device = DeviceSo.new(@am_device, @state_machine)
    @device.save
  end

  after do
    DatabaseCleaner.clean
  end

  it "should create a new DeviceLog registry in the database" do
    model = DeviceLog.new(@device, "Entrando na manutencao")
    model.wont_be_nil
    model.save.must_equal true
  end

  it "should not create an invalid history log" do
    proc{ DeviceLog.new }.must_raise ArgumentError
  end
end
