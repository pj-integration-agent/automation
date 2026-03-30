Título da User Story: US01 - Saque de Fundos

cenario_bdd:
  nome: Realizar saque de fundos com sucesso
  tipo: positivo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Realizar saque de fundos com sucesso
      Given que o usuário está autenticado no sistema do ParaBank
      And o usuário possui saldo suficiente em sua conta
      When o usuário selecionar a opção de saque
      And informar o valor desejado
      Then o sistema deve processar o saque
      And atualizar o saldo da conta
      And emitir um comprovante da transação

cenario_bdd:
  nome: Saque com saldo insuficiente
  tipo: negativo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Saque com saldo insuficiente
      Given que o usuário está autenticado no sistema do ParaBank
      And o usuário não possui saldo suficiente em sua conta
      When o usuário selecionar a opção de saque
      And informar o valor desejado
      Then o sistema deve exibir uma mensagem de saldo insuficiente
      And não deve processar o saque

cenario_bdd:
  nome: Saque com dados de autenticação inválidos
  tipo: negativo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Saque com dados de autenticação inválidos
      Given que o usuário não está autenticado no sistema do ParaBank
      When o usuário selecionar a opção de saque
      And informar os dados de autenticação inválidos
      Then o sistema deve exibir uma mensagem de autenticação falha
      And não deve processar o saque

Título da User Story: US02 - Transferência de Fundos

cenario_bdd:
  nome: Realizar transferência de fundos com sucesso
  tipo: positivo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Realizar transferência de fundos com sucesso
      Given que o usuário está autenticado no sistema do ParaBank
      And o usuário possui saldo suficiente na conta de origem
      When o usuário selecionar a opção de transferência
      And informar a conta de origem
      And informar a conta de destino
      And informar o valor a ser transferido
      Then o sistema deve processar a transferência
      And atualizar os saldos das contas envolvidas
      And emitir um comprovante da transação

cenario_bdd:
  nome: Transferência com saldo insuficiente
  tipo: negativo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Transferência com saldo insuficiente
      Given que o usuário está autenticado no sistema do ParaBank
      And o usuário não possui saldo suficiente na conta de origem
      When o usuário selecionar a opção de transferência
      And informar a conta de origem
      And informar a conta de destino
      And informar o valor a ser transferido
      Then o sistema deve exibir uma mensagem de saldo insuficiente
      And não deve processar a transferência

cenario_bdd:
  nome: Transferência com dados de autenticação inválidos
  tipo: negativo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Transferência com dados de autenticação inválidos
      Given que o usuário não está autenticado no sistema do ParaBank
      When o usuário selecionar a opção de transferência
      And informar os dados de autenticação inválidos
      Then o sistema deve exibir uma mensagem de autenticação falha
      And não deve processar a transferência

Título da User Story: US03 - Consulta de Saldo

cenario_bdd:
  nome: Consultar saldo de conta com sucesso
  tipo: positivo
  gherkin: |
    Feature: Consulta de Saldo
    Scenario: Consultar saldo de conta com sucesso
      Given que o usuário está autenticado no sistema do ParaBank
      When o usuário selecionar a opção de consulta de saldo
      And escolher a conta desejada
      Then o sistema deve exibir o saldo atualizado da conta

cenario_bdd:
  nome: Consulta de saldo com dados de autenticação inválidos
  tipo: negativo
  gherkin: |
    Feature: Consulta de Saldo
    Scenario: Consulta de saldo com dados de autenticação inválidos
      Given que o usuário não está autenticado no sistema do ParaBank
      When o usuário selecionar a opção de consulta de saldo
      And informar os dados de autenticação inválidos
      Then o sistema deve exibir uma mensagem de autenticação falha
      And não deve exibir o saldo da conta