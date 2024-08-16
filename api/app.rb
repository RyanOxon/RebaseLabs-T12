require_relative 'src/database'
require_relative 'src/helpers'
require 'sinatra'
require 'sinatra/json'
require 'csv'
require 'rack/handler/puma'

helpers Helpers

database = if ENV['RACK_ENV'] == 'test'
             Database.new('tests', 'spec/support/test.csv')
           else
             Database.new('medical_records', './api/db/data.csv')
           end

get '/tests' do
  json database.all
end

get '/tests/:token' do
  result = database.find_by_token(params[:token])

  if result.any?
    response = build_response(result)
    json response
  else
    halt 404, json({ error: 'Token não encontrado' })
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
