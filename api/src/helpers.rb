module Helpers
  def build_tests_data(result)
    result.map do |test|
      {
        test_type: test['test_type'],
        test_limits: test['test_limits'],
        test_result: test['test_result']
      }
    end
  end

  def build_response(result, tests_data)
    {
      result_token: result[0]['result_token'],
      result_date: result[0]['result_date'],
      cpf: result[0]['cpf'],
      name: result[0]['patient_name'],
      email: result[0]['patient_email'],
      birthday: result[0]['patient_birthday'],
      doctor: {
        crm: result[0]['doctor_crm'],
        crm_state: result[0]['doctor_crm_state'],
        name: result[0]['doctor_name']
      },
      tests: tests_data
    }
  end
end
