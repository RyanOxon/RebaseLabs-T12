require 'spec_helper'

describe 'User search exams', type: :system do
  it 'successfully' do
    response = instance_double(Faraday::Response, body: File.read('./spec/support/api_response_exam_details_test.json'),
                                                  status: 200)
    allow(Faraday).to receive(:get).and_return(response)

    visit '/search'

    fill_in id: 'search',	with: 'T9O6AI'
    within('#page-search') do
      click_on 'Buscar'
    end

    expect(page).to have_content('Token: T9O6AI')
    expect(page).to have_content('Paciente: Matheus Barroso')
    expect(page).to have_content('CPF: 066.126.400-90')
    expect(page).to have_content('Data de Nascimento: 1972-03-09')
    expect(page).to have_content('Medico: Sra. Calebe Louzada')
    expect(page).to have_content('CRM: B000B7CDX4')
    expect(page).to have_content('Data do Exame: 2021-11-21')
    expect(page).to have_content('Exames:')
    expect(page).to have_content('hemácias')
    expect(page).to have_content('leucócitos')
    expect(page).to have_content('plaquetas')
    expect(page).to have_content('hdl')
    expect(page).to have_content('ldl')
    expect(page).to have_content('vldl')
    expect(page).to have_content('glicemia')
    expect(page).to have_content('tgo')
    expect(page).to have_content('tgp')
    expect(page).to have_content('eletrólitos')
    expect(page).to have_content('tsh')
    expect(page).to have_content('t4-livre')
    expect(page).to have_content('ácido úrico')
  end

  it 'and token does not exist' do
    response = instance_double(Faraday::Response, body: '[]', status: 404)
    allow(Faraday).to receive(:get).and_return(response)

    visit '/search?token=ABC123'

    expect(page).to have_content('Nenhum exame encontrado com o token ABC123')
  end

  it 'from navbar' do
    response = instance_double(Faraday::Response, body: File.read('./spec/support/api_response_exam_details_test.json'),
                                                  status: 200)
    allow(Faraday).to receive(:get).and_return(response)

    visit '/search'

    within('nav') do
      fill_in id: 'nav-search',	with: 'T9O6AI'
      click_on 'Buscar'
    end

    expect(page).to have_content('Token: T9O6AI')
    expect(page).to have_content('Paciente: Matheus Barroso')
  end
end
