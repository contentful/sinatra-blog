require 'sinatra/base'

class App < Sinatra::Base
  get "/" do
    "Hello, Anynines!"
  end
end
