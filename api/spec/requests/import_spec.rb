require 'spec_helper'


RSpec.describe 'POST /import', type: :request do
  after(:each) do
    Sidekiq::Worker.clear_all
    FileUtils.rm_rf(Dir['spec/uploads/*'])
  end

  it 'successfully' do
    file = Rack::Test::UploadedFile.new('spec/support/test.csv', 'text/csv')
    post '/import', file: file

    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Arquivo será importado em instantes')
    expect(CsvImportJob.jobs.size).to eq(1)
    expect(CsvImportJob).to have_enqueued_sidekiq_job('./spec/uploads/test.csv')
  end

  it 'only accepts CSV files' do
    file = Rack::Test::UploadedFile.new('spec/support/test.txt', 'text/plain')
    post '/import', file: file

    expect(last_response.status).to eq(400)
    expect(last_response.body).to include('Erro no arquivo CSV')
    expect(CsvImportJob.jobs.size).to eq(0)
  end

  it 'requires a file' do
    post '/import'

    expect(last_response.status).to eq(400)
    expect(last_response.body).to include('Erro no arquivo CSV')
    expect(CsvImportJob.jobs.size).to eq(0)
  end
end