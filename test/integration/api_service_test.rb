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

  it 'gets root' do
    get '/'
    assert last_response.ok?
  end

  describe '#add' do
    before do
      @am_device = AmDevice.new 1234, Date.today, 365, false
      @am_device.save

      @params = {serial_number: 1234}
    end
    it 'includes new DeviceSo from an Existing AmDevice' do
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
  end
end
