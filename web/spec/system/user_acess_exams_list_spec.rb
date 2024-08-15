require 'spec_helper'

describe 'User access exams list', type: :system do
  it 'successfully' do
    response = instance_double(Faraday::Response, body: File.read('./spec/support/api_response_2entries_test.json'))
    allow(Faraday).to receive(:get).and_return(response)

    visit '/tests'

    expect(page).to have_content('Lista de Exames')
    expect(page).to have_content('Testonaldo primeiro')
    expect(page).to have_content('Testonalda segunda')
    expect(page).to have_selector('a.btn.disabled', text: 'Anterior')
    expect(page).to have_selector('a.btn.disabled', text: 'Próximo')
  end

  it 'successfully with pagination' do
    response = instance_double(Faraday::Response, body: File.read('./spec/support/api_response_12entries_test.json'))
    allow(Faraday).to receive(:get).and_return(response)

    visit '/tests'
    click_on 'Próximo'

    expect(page).to have_content('Lista de Exames')
    expect(page).to have_content('Testonaldo décimo primeiro')
    expect(page).to have_content('Testonalda décima segunda')
    expect(page).to have_selector('a.btn', text: 'Anterior')
    expect(page).to have_selector('a.btn.disabled', text: 'Próximo')
  end
end
