require 'spec_helper'
require_relative '../../src/database'

RSpec.describe 'GET /tests', type: :request do
  it 'successfully' do
    db = Database.new('tests', 'spec/support/test.csv')

    get '/tests'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)
    expect(json.size).to eq(3)
    expect(json[0].keys.size).to eq(17)
    expect(json[0]['id']).to eq('1')
    expect(json[0]['cpf']).to eq('123.456.789-10')
    expect(json[0]['patient_name']).to eq('Testonaldo primeiro')
    expect(json[0]['patient_email']).to eq('testonaldo@daSilva.com')
    expect(json[0]['patient_birthday']).to eq('1990-01-01')
    expect(json[0]['patient_address']).to eq('123 Rua Teste')
    expect(json[0]['patient_city']).to eq('Teste')
    expect(json[0]['patient_state']).to eq('TS')
    expect(json[0]['doctor_crm']).to eq('123456')
    expect(json[0]['doctor_crm_state']).to eq('TS')
    expect(json[0]['doctor_name']).to eq('Doutor a Testado')
    expect(json[0]['doctor_email']).to eq('a@testado.com')
    expect(json[0]['result_token']).to eq('123456')
    expect(json[0]['result_date']).to eq('2020-01-01')
    expect(json[0]['test_type']).to eq('Teste')
    expect(json[0]['test_limits']).to eq('0-10')
    expect(json[0]['test_result']).to eq('5')
    expect(json[1].keys.size).to eq(17)
    expect(json[1]['id']).to eq('2')
    expect(json[1]['cpf']).to eq('123.456.789-10')
    expect(json[2].keys.size).to eq(17)
    expect(json[2]['patient_name']).to eq('Testonalda segunda')
    expect(json[2]['patient_email']).to eq('testonalda@daSilva.com')

    db.query('DROP TABLE IF EXISTS tests')
  end
end
