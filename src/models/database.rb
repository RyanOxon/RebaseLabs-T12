require 'pg'
require 'csv'

class Database
  def initialize(table_name, data_csv)
    @conn = PG.connect(
      host: 'mypg',
      dbname: 'mydb',
      user: 'rebase_labs',
      password: 'labs_password'
    )

    @table = table_name

    populate_table(data_csv)
  end

  def populate_table(data_csv)
    return false if table?(@table)

    @conn.exec("
        CREATE TABLE #{@table}(
          id SERIAL PRIMARY KEY,
          cpf VARCHAR(50) NOT NULL,
          nome_paciente VARCHAR(100) NOT NULL,
          email_paciente VARCHAR(100) NOT NULL,
          data_nascimento_paciente DATE NOT NULL,
          endereco_rua_paciente VARCHAR(255) NOT NULL,
          cidade_paciente VARCHAR(100) NOT NULL,
          estado_paciente VARCHAR(50) NOT NULL,
          crm_medico VARCHAR(20) NOT NULL,
          crm_medico_estado VARCHAR(2) NOT NULL,
          nome_medico VARCHAR(100) NOT NULL,
          email_medico VARCHAR(100) NOT NULL,
          token_resultado_exame VARCHAR(20) NOT NULL,
          data_exame DATE NOT NULL,
          tipo_exame VARCHAR(50) NOT NULL,
          limites_tipo_exame VARCHAR(20) NOT NULL,
          resultado_tipo_exame VARCHAR(20) NOT NULL
        )
      ")
    insert_table(@table, data_csv)
  end

  def table?(table_name)
    result = @conn.exec('SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = $1);', [table_name])
    result.getvalue(0, 0) == 't'
  end

  def insert_table(table_name, csv_file)
    CSV.foreach(csv_file, col_sep: ';') do |row|
      next if row[0] == 'cpf'

      @conn.exec_params(
        "INSERT INTO #{table_name} (cpf, nome_paciente, email_paciente, data_nascimento_paciente,
          endereco_rua_paciente, cidade_paciente, estado_paciente, crm_medico, crm_medico_estado,
          nome_medico, email_medico, token_resultado_exame, data_exame, tipo_exame, limites_tipo_exame,
          resultado_tipo_exame)
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)",
        [
          row[0],
          row[1],
          row[2],
          row[3],
          row[4],
          row[5],
          row[6],
          row[7],
          row[8],
          row[9],
          row[10],
          row[11],
          row[12],
          row[13],
          row[14],
          row[15]
        ]
      )
    end
    true
  end

  def query(query)
    @conn.exec(query)
  end

  def all
    @conn.exec("SELECT * FROM #{@table}").to_a
  end
end
