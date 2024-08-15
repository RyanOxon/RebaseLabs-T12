require 'sinatra'
require 'rack/handler/puma'

set :views, File.expand_path('../src/views', __dir__)

get '/exams' do
  erb :exams
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 4000,
    Host: '0.0.0.0'
  )
end
