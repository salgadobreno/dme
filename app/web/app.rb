require 'sinatra'
require 'app/services/app_service'

class App < Sinatra::Base

  configure { set :server, :puma }

  SERVICE = AppService.new

  set :root, 'app/web'

  get '/' do
    render :html, :index
  end

  post '/devices' do
    serial_number = params[:serial_number]
    payload = params[:payload]

    SERVICE.add serial_number, payload
  end

  #get '/devices' do
  #content_type :json
  #[SERVICE.list].to_json
  #end

  #get '/devices/show/:id' do
  #content_type :json
  #@device = SERVICE.show params[:id]

  #if @device
  #@device.to_json
  #end
  #end

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

end
