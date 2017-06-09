require 'sinatra'
require 'app/services/app_service'

configure { set :server, :puma }

SERVICE = AppService.new

set :root, 'app/web'

get '/' do
  render :html, :index
end

get '/items' do
  content_type :json
  ["item#{rand(0..20)}", "item#{rand(0..20)}"].to_json
end

get '/devices' do
  content_type :json
  [SERVICE.list].to_json
end

get '/devices/show/:id' do
  content_type :json
  @device = SERVICE.show params[:id]

  if @device
    @device.to_json
  end
end

post 'devices/add' do
  "Tried to add serial_number: '{params[:serial_number]'"
end

