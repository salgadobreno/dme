require 'sinatra'
configure { set :server, :puma }

set :root, 'app/web'

get '/' do
  render :html, :index
end

get '/items' do
  content_type :json
  ["item#{rand(0..20)}", "item#{rand(0..20)}"].to_json
end
