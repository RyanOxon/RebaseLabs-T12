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
  @exams = JSON.parse(Faraday.get('http://api:3000/tests').body)
  @page = params[:page] ? params[:page].to_i : 1
  @sliced_exams = @exams[(@page - 1) * 10, 10]
  erb :tests
end

get '/search' do
  response = Faraday.get("http://api:3000/tests/#{params[:token]}") if params[:token]
  @tests = JSON.parse(response.body) if response && response.status == 200

  erb :search
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 4000,
    Host: '0.0.0.0'
  )
end
