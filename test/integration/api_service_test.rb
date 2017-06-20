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
      assert last_response.ok?
    end

    describe "GET /devices" do
      before do
        @device_1 = create :device_so
        @device_2 = create :device_so
      end
      it 'lists the devices' do
        get '/devices'
        assert last_response.ok?
        response_hash = JSON.parse(last_response.body)
        assert response_hash.size, 2
      end
    end

    describe 'GET /devices/:id' do
      before do
        @device = create :device_so
      end
      it 'shows requested device' do
        get "/devices/#{@device.serial_number}"
        assert last_response.ok?
        response_hash = JSON.parse(last_response.body)
        assert response_hash["serial_number"], @device.serial_number
      end
    end

    describe 'DELETE /devices/:id' do
      before do
        @device = create :device_so
      end
      it 'deletes DeviceSo :id' do
        device_count = DeviceSo.count
        delete "/devices/#{@device.serial_number}"
        assert last_response.ok?
        assert DeviceSo.count, (device_count-1)
      end
    end

    describe '/devices/:id/forward' do
      #TODO
      it 'forwards Device'
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

        assert last_response.ok?
        DeviceSo.count.must_equal count+1
      end

      it 'can receive key values and they are included in the payload' do
        count = DeviceSo.count

        payload_args = {payload: {
          teste: 'teste',
          teste2: 'teste2'
        }}

        post '/devices', @params.merge(payload_args)

        assert last_response.ok?
        DeviceSo.count.must_equal count+1
        DeviceSo.last.payload.keys.must_include "teste"
        DeviceSo.last.payload.keys.must_include "teste2"
      end

      describe "Exceptions" do
        #TODO: complete test
        it 'returns error message when the SerialNumber doesnt match the AssetManager'
      end
    end
  end
end
