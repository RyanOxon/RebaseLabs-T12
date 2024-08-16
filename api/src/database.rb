require 'pg'
require 'csv'

class Database
  def initialize(table_name, data_csv = nil)
    @conn = PG.connect(
      host: 'myPG',
      dbname: 'mydb',
      user: 'rebase_labs',
      password: 'labs_password'
    )

    @table = table_name

    populate_table(data_csv)
  end

  def populate_table(data_csv)
    return false if table?(@table) || data_csv.nil?

    @conn.exec("
        CREATE TABLE #{@table}(
          id SERIAL PRIMARY KEY,
          cpf VARCHAR(50) NOT NULL,
          patient_name VARCHAR(100) NOT NULL,
          patient_email VARCHAR(100) NOT NULL,
          patient_birthday DATE NOT NULL,
          patient_address VARCHAR(255) NOT NULL,
          patient_city VARCHAR(100) NOT NULL,
          patient_state VARCHAR(50) NOT NULL,
          doctor_crm VARCHAR(20) NOT NULL,
          doctor_crm_state VARCHAR(2) NOT NULL,
          doctor_name VARCHAR(100) NOT NULL,
          doctor_email VARCHAR(100) NOT NULL,
          result_token VARCHAR(20) NOT NULL,
          result_date DATE NOT NULL,
          test_type VARCHAR(50) NOT NULL,
          test_limits VARCHAR(20) NOT NULL,
          test_result VARCHAR(20) NOT NULL
        )
      ")
    insert_table(data_csv)
  end

  def table?(table_name)
    result = @conn.exec('SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = $1);', [table_name])
    result.getvalue(0, 0) == 't'
  end

  def insert_table(csv_file)
    CSV.foreach(csv_file, col_sep: ';') do |row|
      next if row[0] == 'cpf'

      @conn.exec_params(
        "INSERT INTO #{@table} (cpf, patient_name, patient_email, patient_birthday, patient_address, patient_city,
        patient_state, doctor_crm, doctor_crm_state, doctor_name, doctor_email, result_token,
        result_date, test_type, test_limits, test_result)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)", row
      )
    end
    true
  rescue StandardError => e
    p "Erro ao inserir dados no banco: #{e.message}"
    p e.backtrace # Opcional: imprime a stack trace para ajudar na depuração
    false
  end

  def query(query)
    @conn.exec(query)
  end

  def all
    @conn.exec("SELECT * FROM #{@table}").to_a
  end

  def find_by_token(token)
    @conn.exec_params("SELECT * FROM #{@table} WHERE result_token = $1", [token]).to_a
  end
end
