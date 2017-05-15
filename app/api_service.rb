require 'sinatra'

set :environment, :production

get '/' do
    "<html><body>OK</body></html>"
end

