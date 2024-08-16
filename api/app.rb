require_relative 'src/database'
require_relative 'src/helpers'
require_relative 'src/import_job'
require 'sinatra'
require 'sinatra/json'
require 'csv'
require 'rack/handler/puma'
require 'fileutils'

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

post '/import' do
  if params[:file] && params[:file][:tempfile] && params[:file][:filename].end_with?('.csv')
    file = params[:file][:tempfile]
    filename = params[:file][:filename]
    upload_path = ENV['RACK_ENV'] == 'test' ? './spec/uploads' : './uploads'
    FileUtils.mkdir_p(upload_path) unless File.directory?(upload_path)
    permanent_path = File.join(upload_path, filename)

    FileUtils.mv(file.path, permanent_path)
    CsvImportJob.perform_async(permanent_path)

    status 200
    json({ message: 'Arquivo será importado em instantes' })
  else
    halt 400, json({ error: 'Erro no arquivo CSV' })
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
