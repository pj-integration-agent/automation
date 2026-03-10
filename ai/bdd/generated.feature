Título da User Story: US01 - Saque de Fundos

cenario_bdd:
  nome: Realizar saque de fundos com sucesso
  tipo: positivo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Realizar saque de fundos com sucesso
      Given que o cliente possui uma conta válida no ParaBank
      And o cliente está autenticado no sistema
      When o cliente selecionar a opção de saque
      And digitar o valor do saque
      Then o caixa eletrônico deve dispensar o valor solicitado
      And o saldo da conta do cliente deve ser atualizado corretamente

cenario_bdd:
  nome: Tentativa de saque com credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Tentativa de saque com credenciais inválidas
      Given que o cliente possui uma conta no ParaBank
      But o cliente informar credenciais inválidas (usuário e/ou senha)
      When o cliente tentar realizar o saque
      Then o sistema deve exibir uma mensagem de erro informando que as credenciais são inválidas
      And não deve ser permitido realizar o saque

cenario_bdd:
  nome: Tentativa de saque com valor inválido
  tipo: negativo
  gherkin: |
    Feature: Saque de Fundos
    Scenario: Tentativa de saque com valor inválido
      Given que o cliente possui uma conta válida no ParaBank
      And o cliente está autenticado no sistema
      When o cliente tentar sacar um valor negativo ou maior que o saldo disponível
      Then o sistema deve exibir uma mensagem de erro informando que o valor é inválido
      And não deve ser permitido realizar o saque

Título da User Story: US02 - Transferência de Fundos

cenario_bdd:
  nome: Realizar transferência de fundos entre contas com sucesso
  tipo: positivo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Realizar transferência de fundos entre contas com sucesso
      Given que o cliente possui duas contas válidas no ParaBank
      And o cliente está autenticado no sistema
      When o cliente selecionar a opção de transferência de fundos
      And escolher a conta de origem e destino
      And digitar o valor a ser transferido
      Then a transferência deve ser processada com sucesso
      And os saldos das contas devem ser atualizados corretamente
      And o histórico da transferência deve ser exibido na conta do cliente

cenario_bdd:
  nome: Tentativa de transferência com credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Tentativa de transferência com credenciais inválidas
      Given que o cliente possui contas no ParaBank
      But o cliente informar credenciais inválidas (usuário e/ou senha)
      When o cliente tentar realizar a transferência
      Then o sistema deve exibir uma mensagem de erro informando que as credenciais são inválidas
      And não deve ser permitido realizar a transferência

cenario_bdd:
  nome: Tentativa de transferência com valor inválido
  tipo: negativo
  gherkin: |
    Feature: Transferência de Fundos
    Scenario: Tentativa de transferência com valor inválido
      Given que o cliente possui contas válidas no ParaBank
      And o cliente está autenticado no sistema
      When o cliente tentar transferir um valor negativo ou maior que o saldo disponível
      Then o sistema deve exibir uma mensagem de erro informando que o valor é inválido
      And não deve ser permitido realizar a transferência

Título da User Story: US03 - Consulta de Saldos

cenario_bdd:
  nome: Consultar saldos de contas com sucesso
  tipo: positivo
  gherkin: |
    Feature: Consulta de Saldos
    Scenario: Consultar saldos de contas com sucesso
      Given que o cliente possui contas válidas no ParaBank
      And o cliente está autenticado no sistema
      When o cliente selecionar a opção de consulta de saldo
      Then o sistema deve exibir o saldo atual de cada uma das contas do cliente
      And as informações de saldo devem estar atualizadas

cenario_bdd:
  nome: Tentativa de consulta de saldo com credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Consulta de Saldos
    Scenario: Tentativa de consulta de saldo com credenciais inválidas
      Given que o cliente possui contas no ParaBank
      But o cliente informar credenciais inválidas (usuário e/ou senha)
      When o cliente tentar consultar o saldo
      Then o sistema deve exibir uma mensagem de erro informando que as credenciais são inválidas
      And não deve ser permitido consultar os saldos

Título da User Story: US04 - Depósito de Fundos

cenario_bdd:
  nome: Realizar depósito de fundos com sucesso
  tipo: positivo
  gherkin: |
    Feature: Depósito de Fundos
    Scenario: Realizar depósito de fundos com sucesso
      Given que o cliente possui uma conta válida no ParaBank
      And o cliente está autenticado no sistema
      When o cliente selecionar a opção de depósito
      And inserir o valor em dinheiro
      Then o caixa eletrônico deve aceitar e processar o depósito
      And o saldo da conta do cliente deve ser atualizado corretamente

cenario_bdd:
  nome: Tentativa de depósito com credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Depósito de Fundos
    Scenario: