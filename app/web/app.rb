require 'sinatra'
require 'app/services/app_service'

class App < Sinatra::Application

  configure { set :server, :puma }

  SERVICE = AppService.new

  set :root, 'app/web'

  get '/' do
    render :html, :index
  end

  # List devices
  get '/devices' do
    content_type :json
    SERVICE.list.to_json
  end

  # Show device
  get '/devices/:serial_number' do
    content_type :json
    serial_number = params[:serial_number]
    SERVICE.show(serial_number).to_json
  end

  # Add device
  post '/devices' do
    serial_number = params[:serial_number]
    payload = params[:payload]

    SERVICE.add serial_number, payload
  end

  # Forward device
  post '/devices/:serial_number/forward' do
    serial_number = params[:serial_number]

    SERVICE.fw serial_number
  end

  # Delete device
  delete '/devices/:serial_number' do
    content_type :json
    serial_number = params[:serial_number]
    SERVICE.rm(serial_number)
  end

  get '/items' do
    content_type :json
    ["item#{rand(0..20)}", "item#{rand(0..20)}"].to_json
  end

  get '/examples/items' do
    render :html, :itemsindex
  end

  get '/examples/my-app' do
    render :html, :myappindex
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
