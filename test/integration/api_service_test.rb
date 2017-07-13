ENV['RACK_ENV'] = 'test'

require 'mongoid'
require "database_cleaner"
require 'rack/test'
require 'test_helper'
require 'app/web/app'

describe App do
  include Rack::Test::Methods

  before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  after do
    DatabaseCleaner.clean
  end

  def app
    App
  end

  describe "REST API" do
    it 'GET /' do
      get '/'
      last_response.ok?.must_equal true
    end

    describe "GET /devices" do
      before do
        @device_1 = create :device_so
        @device_2 = create :device_so
      end
      it 'lists the devices' do
        get '/devices'
        last_response.ok?.must_equal true
        response_hash = JSON.parse(last_response.body)
        response_hash.size.must_equal 2
      end
    end

    describe "GET /am_devices" do
      before do
        @am_device_1 = create :am_device
        @am_device_2 = create :am_device
      end
      it 'lists the devices' do
        get '/am_devices'
        last_response.ok?.must_equal true
        response_hash = JSON.parse(last_response.body)
        response_hash.size.must_equal 2
      end
    end

    describe 'GET /devices/:id' do
      before do
        @device = create :device_so
      end
      it 'shows requested device' do
        get "/devices/#{@device.serial_number}"
        last_response.ok?.must_equal true
        response_hash = JSON.parse(last_response.body)
        #verify response
        @device.serial_number.must_equal response_hash["data"]["serial_number"]
      end
    end

    describe 'DELETE /devices/:id' do
      before do
        @device = create :device_so
      end
      it 'deletes DeviceSo :id' do
        device_count = DeviceSo.count
        delete "/devices/#{@device.serial_number}"
        last_response.ok?.must_equal true
        (device_count-1).must_equal DeviceSo.count
      end
    end

    describe '/devices/:id/forward' do
      before do
        @state_inicio = State.new :inicio
        @state_fim = State.new :fim
        @state_machine = StateMachine.new [@state_inicio, @state_fim]
        @device = create(:device_so, state_machine: @state_machine)
      end
      it 'forwards Device' do
        @device.current_state.must_equal @state_inicio
        post "/devices/#{@device.serial_number}/forward"
        last_response.ok?.must_equal true
        @device.reload.current_state.must_equal @state_fim
      end
    end

    describe 'POST /devices' do
      before do
        @am_device = AmDevice.new 1234, Date.today, 365, false
        @am_device.save

        @params = {serial_number: 1234}
      end

      it 'adds new DeviceSo from an Existing AmDevice' do
        count = DeviceSo.count

        post '/devices', @params

        last_response.ok?.must_equal true
        DeviceSo.count.must_equal count+1
	DeviceSo.last.serial_number.must_equal 1234
      end

      it 'can receive key values and they are included in the payload' do
        count = DeviceSo.count

        payload_args = {payload: {
          teste: 'teste',
          teste2: 'teste2'
        }}

        post '/devices', @params.merge(payload_args)

        last_response.ok?.must_equal true
        DeviceSo.count.must_equal count+1
        DeviceSo.last.payload.keys.must_include "teste"
        DeviceSo.last.payload.keys.must_include "teste2"
      end

      describe "Exceptions" do
        #TODO: complete test
        it 'returns error message when the SerialNumber doesnt match the AssetManager'
      end
    end

    describe "POST /devices/seed.json" do
      it 'clears the DeviceSos and populates the AmDevices' do
        @dso = create :device_so
        DeviceSo.count.must_be :>=, 1
        post '/devices/seed.json'

        last_response.ok?.must_equal true
        DeviceSo.count.must_equal 0
        AmDevice.count.must_be :>, 0
      end
    end

    describe "POST /devices/light_seed" do
      it 'clears the DeviceSos without wiping DeviceLogs' do
        @dso = create :device_so
        DeviceSo.count.must_be :>, 0
        DeviceSo.last.tap do |d|
          d.forward
          d.forward
          d.forward
          d.save!
        end
        DeviceLog.count.must_be :>, 0
        post '/devices/light_seed.json'

        last_response.ok?.must_equal true
        DeviceSo.count.must_equal 0
        AmDevice.count.must_be :>, 0
        DeviceLog.count.must_be :>, 0
      end
    end
  end
end
