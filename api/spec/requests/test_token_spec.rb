require 'spec_helper'
require_relative '../../src/database'

RSpec.describe 'GET /tests/:token', type: :request do
  it 'successfully' do
    db = Database.new('tests', 'spec/support/test.csv')

    get '/tests/123456'

    expect(last_response.status).to eq(200)
    response = JSON.parse(last_response.body)
    expect(response['result_token']).to eq('123456')
    expect(response['result_date']).to eq('2020-01-01')
    expect(response['cpf']).to eq('123.456.789-10')
    expect(response['name']).to eq('Testonaldo primeiro')
    expect(response['email']).to eq('testonaldo@daSilva.com')
    expect(response['birthday']).to eq('1990-01-01')
    expect(response['doctor']['crm']).to eq('123456')
    expect(response['doctor']['crm_state']).to eq('TS')
    expect(response['doctor']['name']).to eq('Doutor a Testado')
    expect(response['tests'].size).to eq(2)
    expect(response['tests'][0]['type']).to eq('Teste')
    expect(response['tests'][0]['limits']).to eq('0-10')
    expect(response['tests'][0]['result']).to eq('5')
    expect(response['tests'][1]['type']).to eq('Teste2')

    db.query('DROP TABLE IF EXISTS tests')
  end

  it 'not found' do
    db = Database.new('tests', 'spec/support/test.csv')

    get '/tests/1234567'

    expect(last_response.status).to eq(404)
    expect(JSON.parse(last_response.body)).to eq({ 'error' => 'Token não encontrado' })

    db.query('DROP TABLE IF EXISTS tests')
  end
end
