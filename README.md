# RebaseLabs-T12
Projeto pessoal para os desafios propostos durante as aulas da Rebase Labs.
A ideia central é construir um app web sem o auxilio do Rails!

O app tem como objetivo manter controle de uma listagem de exames medicos

### Stacks

- Docker
- Ruby
- Javascript
- HTML
- CSS

### Configuração

Considerando que o Docker ja esteja instalado basta rodar para inciar o aplicativo

```bash
docker compose up
```

Existem ao todo 7 containers
- API
- WEB
- PostgreSQL
- Redis
- Sidekiq
- Test API
- Test WEB


O resultado dos testes vem sempre junto aos logs do container, caso não deseje ver os logs utilize `-d` junto ao comando de inicialização

Para rodar os testes novamente após a inicialização, execute:

```bash
docker start -i apiTest
docker start -i webTest
```

## Apps
### API

O banco de dados do sistema é gerenciado por uma web api Sinatra, na sua inicialização o banco de dados é populado pelo arquivo `api/db/data.csv` e fica exposto na URL `localhost:3000`

#### Endpoints
- ` GET '/tests'` retorna uma lista completa de todos os registros na tabela medical_records, sem formatação

 Exemplo de resposta
``` json
[
  {
    "id": "1",
    "cpf": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthday": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_crm_state": "PI",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "result_token": "IQCZ17",
    "result_date": "2021-08-05",
    "test_type": "hemácias",
    "test_limits": "45-52",
    "test_result": "97"
  },
  {
    "id": "2",
    "cpf": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthday": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_crm_state": "PI",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "result_token": "IQCZ17",
    "result_date": "2021-08-05",
    "test_type": "leucócitos",
    "test_limits": "9-61",
    "test_result": "89"
  },
  ...
]
```

- `GET 'tests/:token'` Passando um token valido como parâmetro para tests, retorna um json formatado com todas as informações do exame relacionado ao token

Exemplo de resposta
```json
{
  "result_token": "IQCZ17",
  "result_date": "2021-08-05",
  "cpf": "048.973.170-88",
  "name": "Emilly Batista Neto",
  "email": "gerald.crona@ebert-quigley.com",
  "birthday": "2001-03-11",
  "doctor": {
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "name": "Maria Luiza Pires"
  },
  "tests": [
    {
      "type": "hemácias",
      "limits": "45-52",
      "result": "97"
    },
    {
      "type": "leucócitos",
      "limits": "9-61",
      "result": "89"
    },
    {
      "type": "plaquetas",
      "limits": "11-93",
      "result": "97"
    },
    ...
  ]
```

- `POST '/import' @file=***.csv` Recebe um arquivo csv e popula o banco de dados com ele a partir de um job Sidekiq

Exemplo de respostas


```json
status: 200
  { 
    "message": "Arquivo será importado em instantes" 
  }

# Caso arquivo vazio ou fora do formato suportado
status 400
    { 
    "error": "Erro no arquivo CSV" 
  }

```

### Web

A aplicação web consiste de consumir os endpoints da API e apresentar de uma forma amigável ao usuário, fica exposta na URL `localhost:4000/`

#### Rotas

Toda aplicação possui por padrão uma navbar com botoes para navegar entre Home (Landing Page), buscar exame e importar csv. Nela existe também um form para buscar exame por token, como um atalho para o usuário. O mesmo nao aparece quando ja se está na pagina de busca.

- `'/tests'` Landing page da aplicação, nela temos uma lista de todas as entradas de exames atualmente no banco de dados da aplicação, sendo mostrado de 10 em 10 com um sistema de paginação por rota

- `'/search'` Pagina de busca de exame a partir de um token. O token precisa ser digitado corretamente, caso contrario uma mensagem 'Nenhum exame encontrado com o token ***' é mostrada. Com um token corretamente digitado todas as informações relacionadas a ele sao expostas na tela de forma organizada

- `'/import'` Pagina destinada a enviar arquivos csv a API para popular o banco de dados. Os arquivos sao salvos de forma temporária ate o Job relacionado ser executado. Somente sao aceitos arquivos .csv, exibindo alertas de erro caso contrario




