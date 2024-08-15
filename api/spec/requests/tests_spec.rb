require 'spec_helper'
require_relative '../../src/models/database'

RSpec.describe 'GET /tests', type: :request do
  before(:each) do
    @db = Database.new('tests', 'spec/support/test.csv')
  end

  after(:each) do
    @db.query('DROP TABLE IF EXISTS tests')
  end

  it 'successfully' do
    get '/tests'

    expect(last_response.status).to eq(200)
    json = JSON.parse(last_response.body)
    expect(json.size).to eq(2)
    expect(json[0].keys.size).to eq(17)
    expect(json[0]['id']).to eq('1')
    expect(json[0]['cpf']).to eq('123.456.789-10')
    expect(json[0]['nome_paciente']).to eq('Testonaldo primeiro')
    expect(json[0]['email_paciente']).to eq('testonaldo@daSilva.com')
    expect(json[0]['data_nascimento_paciente']).to eq('1990-01-01')
    expect(json[0]['endereco_rua_paciente']).to eq('123 Rua Teste')
    expect(json[0]['cidade_paciente']).to eq('Teste')
    expect(json[0]['estado_paciente']).to eq('TS')
    expect(json[0]['crm_medico']).to eq('123456')
    expect(json[0]['crm_medico_estado']).to eq('TS')
    expect(json[0]['nome_medico']).to eq('Doutor a Testado')
    expect(json[0]['email_medico']).to eq('a@testado.com')
    expect(json[0]['token_resultado_exame']).to eq('123456')
    expect(json[0]['data_exame']).to eq('2020-01-01')
    expect(json[0]['tipo_exame']).to eq('Teste')
    expect(json[0]['limites_tipo_exame']).to eq('0-10')
    expect(json[0]['resultado_tipo_exame']).to eq('5')
    expect(json[1].keys.size).to eq(17)
    expect(json[1]['id']).to eq('2')
    expect(json[1]['cpf']).to eq('123.456.789-11')
    expect(json[1]['nome_paciente']).to eq('Testonalda segunda')
    expect(json[1]['email_paciente']).to eq('testonalda@daSilva.com')
  end
end
