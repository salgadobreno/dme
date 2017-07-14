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
    @am_device = AmDevice.new('100000001', dt1, 365, false)
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

  it 'requires the Asset Manager Device' do
    dl = DeviceLog.new(nil, @device, "teste")
    dl.valid?.must_equal false
  end

  it 'does not require the Device from Service Order' do
    dl = DeviceLog.new(@am_device, nil, "teste")
    dl.valid?.must_equal true
  end

  describe ".device_so_logs scope" do
    it 'return the logs for a DeviceSo' do
      am_device = create :am_device
      dso = create :device_so, am_device: am_device
      dso.log "teste"
      dso.log "teste"
      dso.log "teste"
      dso.save
      dso.destroy
      dso2 = create :device_so, am_device: am_device
      dso2.log "chave"
      dso2.save

      logs = DeviceLog.device_so_logs(dso2)
      logs.count.wont_be :>, 2
      logs.last.description.must_match /chave/
    end
  end
end
