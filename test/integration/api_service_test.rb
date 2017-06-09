ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'test_helper'
require 'app/web/app'

describe 'ApiServiceTest' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'gets root' do
    get '/'
    assert last_response.ok?
  end

end
