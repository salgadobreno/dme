require 'sinatra'
require 'sinatra/respond_with'
require 'app/services/app_service'

class App < Sinatra::Application

  configure { set :server, :puma }

  SERVICE = AppService.new

  set :root, 'app/web'

  #if url is '/anything.json' -> set accept header to json
  before /.*/ do
    if request.url.match(/.json$/)
      request.accept.unshift('application/json')
      request.path_info = request.path_info.gsub(/.json$/,'')
    end
  end

  #read post body params into params[] hash
  before do
    if request.request_method == "POST"
      body_parameters = request.body.read
      params.merge!(JSON.parse(body_parameters)) rescue JSON::ParserError #body not valid JSON, ignore
    end
  end

  get '/' do
    render :html, :deviceaddindex
  end

  get '/devicelistindex' do
    render :html, :devicelistindex
  end

  # List devices
  get '/devices' do
    respond_to do |format|
      format.json { SERVICE.list.to_json }
      format.html { render :html, :devicelist }
    end
  end

  # Create device
  post '/devices' do
    serial_number = params[:serial_number]
    payload = params[:payload]

    SERVICE.add serial_number, payload
  end

  # Add device
  get '/devices/new' do
    render :html, :deviceadd
  end

  # Show device
  get '/devices/:serial_number' do
    serial_number = params[:serial_number]

    respond_to do |format|
      format.json { SERVICE.show(serial_number).to_json }
      format.html { render :html, :device }
    end
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
