require 'sinatra'
require 'rack/handler/puma'
require 'faraday'
require 'json'

configure do
  set :layout, :layout
end

get '/' do
  redirect '/tests'
end

get '/tests' do
  @page = params[:page] ? params[:page].to_i : 1
  @exams = JSON.parse(Faraday.get('http://api:3000/tests').body)
  @sliced_exams = @exams[(@page - 1) * 10, 10]
  erb :tests
end

get '/search' do
  @tests = JSON.parse(Faraday.get("http://api:3000/tests/#{params[:token]}").body) if params[:token]
  erb :search
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 4000,
    Host: '0.0.0.0'
  )
end
