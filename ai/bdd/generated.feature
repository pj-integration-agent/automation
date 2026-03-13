Título da User Story: US01 - Acesso às informações de login

cenario_bdd:
  nome: Realizar login com sucesso
  tipo: positivo
  gherkin: |
    Feature: Acesso às informações de login
    Scenario: Realizar login com sucesso
      Given que o usuário está na página de login do ParaBank
      When o usuário inserir um nome de usuário válido e uma senha válida
      Then o sistema deve autenticar as credenciais e conceder acesso ao usuário

cenario_bdd:
  nome: Falha no login devido a credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Acesso às informações de login
    Scenario: Falha no login devido a credenciais inválidas
      Given que o usuário está na página de login do ParaBank
      When o usuário inserir um nome de usuário inválido e/ou uma senha inválida
      Then o sistema deve exibir uma mensagem de erro informando que as credenciais são inválidas

Título da User Story: US02 - Realização de saques em caixas eletrônicos

cenario_bdd:
  nome: Realizar saque com sucesso
  tipo: positivo
  gherkin: |
    Feature: Realização de saques em caixas eletrônicos
    Scenario: Realizar saque com sucesso
      Given que o usuário está logado no sistema do ParaBank
      And o usuário seleciona a opção de saque
      When o usuário inserir um valor de saque válido
      And o usuário possui saldo suficiente na conta
      Then o sistema deve processar o saque e atualizar o saldo da conta

cenario_bdd:
  nome: Falha no saque por falta de saldo
  tipo: negativo
  gherkin: |
    Feature: Realização de saques em caixas eletrônicos
    Scenario: Falha no saque por falta de saldo
      Given que o usuário está logado no sistema do ParaBank
      And o usuário seleciona a opção de saque
      When o usuário inserir um valor de saque que excede o saldo disponível
      Then o sistema deve exibir uma mensagem de erro informando que não há saldo suficiente para realizar o saque

Título da User Story: US03 - Realização de transferências de fundos entre contas

cenario_bdd:
  nome: Realizar transferência entre contas com sucesso
  tipo: positivo
  gherkin: |
    Feature: Realização de transferências de fundos entre contas
    Scenario: Realizar transferência entre contas com sucesso
      Given que o usuário está logado no sistema do ParaBank
      And o usuário seleciona a opção de transferência de fundos
      When o usuário selecionar a conta de origem e a conta de destino
      And o usuário inserir um valor de transferência válido
      And o usuário possui saldo suficiente na conta de origem
      Then o sistema deve processar a transferência e atualizar os saldos das contas envolvidas

cenario_bdd:
  nome: Falha na transferência por falta de saldo
  tipo: negativo
  gherkin: |
    Feature: Realização de transferências de fundos entre contas
    Scenario: Falha na transferência por falta de saldo
      Given que o usuário está logado no sistema do ParaBank
      And o usuário seleciona a opção de transferência de fundos
      When o usuário selecionar a conta de origem e a conta de destino
      And o usuário inserir um valor de transferência que excede o saldo disponível na conta de origem
      Then o sistema deve exibir uma mensagem de erro informando que não há saldo suficiente para realizar a transferência