Título da User Story: Criar novo registro de Banco Nacional
cenario_bdd:
  nome: Criar novo registro de Banco Nacional com sucesso
  tipo: positivo
  gherkin: |
    Feature: Cadastro de Banco Nacional
    Scenario: Criar novo registro de Banco Nacional com sucesso
      Given que o Especialista do Banco está na tela de cadastro de Banco Nacional
      When o Especialista preencher todos os campos obrigatórios corretamente
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        | 123    | Banco ABC         | ABC     | 123456                     | Banco XYZ         | 12.345.678/0001-90 |
      And clicar no botão "Salvar"
      Then o novo registro de Banco Nacional deve ser exibido na listagem
        
cenario_bdd:
  nome: Código de Banco duplicado
  tipo: negativo
  gherkin: |
    Feature: Cadastro de Banco Nacional
    Scenario: Código de Banco duplicado
      Given que o Especialista do Banco está na tela de cadastro de Banco Nacional
      When o Especialista preencher todos os campos obrigatórios com um Código que já existe
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        | 123    | Banco ABC         | ABC     | 123456                     | Banco XYZ         | 12.345.678/0001-90 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o Código já está cadastrado

cenario_bdd:
  nome: Campo obrigatório não preenchido
  tipo: negativo
  gherkin: |
    Feature: Cadastro de Banco Nacional
    Scenario: Campo obrigatório não preenchido
      Given que o Especialista do Banco está na tela de cadastro de Banco Nacional
      When o Especialista deixar de preencher um campo obrigatório
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        |        | Banco ABC         | ABC     | 123456                     | Banco XYZ         | 12.345.678/0001-90 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o campo obrigatório não foi preenchido

cenario_bdd:
  nome: CNPJ inválido
  tipo: negativo
  gherkin: |
    Feature: Cadastro de Banco Nacional
    Scenario: CNPJ inválido
      Given que o Especialista do Banco está na tela de cadastro de Banco Nacional
      When o Especialista preencher um CNPJ inválido
        | Código | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        | 456    | Banco DEF         | DEF     | 789012                     | Banco XYZ         | 12.345.678/0001-91 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o CNPJ é inválido

Título da User Story: Editar registro de Banco Nacional
cenario_bdd:
  nome: Editar registro de Banco Nacional com sucesso
  tipo: positivo
  gherkin: |
    Feature: Edição de Banco Nacional
    Scenario: Editar registro de Banco Nacional com sucesso
      Given que o Especialista do Banco está na tela de edição de um Banco Nacional
      When o Especialista alterar os campos permitidos
        | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        | Banco ABC Atualizado | ABC2   | 987654                     | Banco XYZ         | 12.345.678/0001-90 |
      And clicar no botão "Salvar"
      Then o registro de Banco Nacional deve ser atualizado na listagem

cenario_bdd:
  nome: Tentar editar o código do Banco
  tipo: negativo
  gherkin: |
    Feature: Edição de Banco Nacional
    Scenario: Tentar editar o código do Banco
      Given que o Especialista do Banco está na tela de edição de um Banco Nacional
      When o Especialista tentar alterar o campo "Código"
      Then o campo "Código" deve estar desabilitado e não permitir a edição

cenario_bdd:
  nome: CNPJ inválido na edição
  tipo: negativo
  gherkin: |
    Feature: Edição de Banco Nacional
    Scenario: CNPJ inválido na edição
      Given que o Especialista do Banco está na tela de edição de um Banco Nacional
      When o Especialista preencher um CNPJ inválido
        | Descrição do Banco | Apelido | Número de inscrição no SBP | Banco controlador | CNPJ |
        | Banco ABC Atualizado | ABC2   | 987654                     | Banco XYZ         | 12.345.678/0001-91 |
      And clicar no botão "Salvar"
      Then deve ser exibida uma mensagem de erro informando que o CNPJ é inválido