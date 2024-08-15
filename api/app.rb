require_relative 'src/models/database'
require 'sinatra'
require 'sinatra/json'
require 'csv'
require 'rack/handler/puma'

database = if ENV['RACK_ENV'] == 'test'
             Database.new('tests', 'spec/support/test.csv')
           else
             Database.new('medical_records', './api/db/data.csv')
           end

get '/tests' do
  json database.all
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
