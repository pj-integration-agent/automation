titulo: US01 - Cadastro de Novo Banco
cenario_bdd:
  nome: Cadastrar novo banco com sucesso
  tipo: positivo
  gherkin: |
    Feature: Cadastro de Novo Banco
    Scenario: Cadastrar novo banco com sucesso
      Given que o usuário está na tela de cadastro de novo banco
      When preencher todos os campos obrigatórios corretamente
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco Controlador | CNPJ |
        | 123    | Banco ABC          | ABC     | 12345                      | Banco Central    | 12.345.678/0001-90 |
      And clicar no botão "Salvar"
      Then o novo banco deve ser cadastrado com sucesso

cenario_bdd:
  nome: Cadastrar novo banco com código duplicado
  tipo: negativo
  gherkin: |
    Feature: Cadastro de Novo Banco
    Scenario: Cadastrar novo banco com código duplicado
      Given que o usuário está na tela de cadastro de novo banco
      When preencher todos os campos obrigatórios corretamente
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco Controlador | CNPJ |
        | 123    | Banco XYZ          | XYZ     | 54321                      | Banco Central    | 98.765.432/0001-09 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o código é duplicado

cenario_bdd:
  nome: Cadastrar novo banco com CNPJ inválido
  tipo: negativo
  gherkin: |
    Feature: Cadastro de Novo Banco
    Scenario: Cadastrar novo banco com CNPJ inválido
      Given que o usuário está na tela de cadastro de novo banco
      When preencher todos os campos obrigatórios corretamente
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco Controlador | CNPJ |
        | 456    | Banco DEF          | DEF     | 98765                      | Banco Central    | 12.345.678/0001-91 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o CNPJ é inválido

titulo: US02 - Editar Banco Cadastrado
cenario_bdd:
  nome: Editar informações de um banco cadastrado
  tipo: positivo
  gherkin: |
    Feature: Editar Banco Cadastrado
    Scenario: Editar informações de um banco cadastrado
      Given que o usuário está na tela de edição de um banco cadastrado
      When alterar os seguintes campos:
        | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco Controlador | CNPJ |
        | Banco ABC Ltda     | ABC123  | 54321                      | Banco XYZ         | 98.765.432/0001-09 |
      And clicar no botão "Salvar"
      Then as informações do banco devem ser atualizadas com sucesso

cenario_bdd:
  nome: Tentar editar o código de um banco cadastrado
  tipo: negativo
  gherkin: |
    Feature: Editar Banco Cadastrado
    Scenario: Tentar editar o código de um banco cadastrado
      Given que o usuário está na tela de edição de um banco cadastrado
      When tentar alterar o campo "Código"
      Then o campo "Código" não deve poder ser editado