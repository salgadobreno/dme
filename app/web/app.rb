require 'sinatra'
require 'sinatra/respond_with'
require 'app/services/app_service'

class App < Sinatra::Application

  configure { set :server, :puma }


  set :root, 'app/web'

  def initialize(app=nil, service=AppService.new)
    super(app)
    APP_LOG.info("App initialized, service=#{service}")
    @service = service
  end

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
    render :html, :devicelist
  end

  # List devices
  get '/devices/?' do
    respond_to do |format|
      format.json { @service.list.to_json }
      format.html { render :html, :devicelist }
    end
  end

  # List AmDevices
  get '/am_devices/?' do
    respond_to do |format|
      format.json { @service.am_device_list.to_json }
    end
  end

  # Create device
  post '/devices/?' do
    serial_number = params[:serial_number]
    payload = params[:payload]

    r = @service.add serial_number, payload
    respond_to do |format|
      format.json { r.merge({redirect: "/devices/#{serial_number}"}).to_json }
    end
  end

  # Add device
  get "/devices/new/?:serial_number?" do
    render :html, :deviceadd
  end

  # Show log
  get "/devices/show_log/?:serial_number?" do
    render :html, :device_log
  end

  get '/devices/:serial_number/device_logs' do
    r = @service.show_log params[:serial_number]
    respond_to do |format|
      format.json { r.to_json }
    end
  end
    respond_to do |format|
      format.json { r.to_json }
    end
  end

  # Show device
  get "/devices/:serial_number" do
    serial_number = params[:serial_number]

    respond_to do |format|
      format.json { @service.show(serial_number).to_json }
      format.html { render :html, :device }
    end
  end

  # Forward device
  post "/devices/:serial_number/forward/?" do
    serial_number = params[:serial_number]

    r = @service.fw serial_number
    respond_to do |format|
      format.json { r.merge({redirect: "/devices/#{serial_number}"}).to_json }
    end
  end

  # Delete device
  delete "/devices/:serial_number" do
    content_type :json
    serial_number = params[:serial_number]
    r = @service.rm(serial_number)
    respond_to do |format|
      format.json { r.merge({redirect: '/devices'}).to_json }
    end
  end

  post '/devices/seed' do
    r = @service.run_seed
    respond_to do |format|
      format.json { r.to_json }
    end
  end

  post '/devices/light_seed' do
    r = @service.run_light_seed
    respond_to do |format|
      format.json { r.to_json }
    end
  end

  post '/devices/forward_all' do
    r = @service.forward_all
    respond_to do |format|
      format.json { r.merge(redirect:'/').to_json }
    end
  end

  #TODO: need a better name for this
  post '/devices/run_complete' do
    r = @service.run_complete
    respond_to do |format|
      format.json { r.merge(redirect:'/').to_json }
    end
  end

  #routes of the react examples
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
