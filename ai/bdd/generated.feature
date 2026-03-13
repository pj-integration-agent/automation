Título da User Story: US01 - Login na conta

cenario_bdd:
  nome: Usuário realiza login com sucesso
  tipo: positivo
  gherkin: |
    Feature: Login na conta
    Scenario: Usuário realiza login com sucesso
      Given que o usuário esteja na página de login
      When o usuário preencher o campo "Usuário" com "john_doe"
      And o usuário preencher o campo "Senha" com "mypassword"
      And o usuário clicar no botão "LOG IN"
      Then o sistema deve autenticar as credenciais
      And conceder acesso à conta do usuário

cenario_bdd:
  nome: Usuário preenche campos de login com informações inválidas
  tipo: negativo
  gherkin: |
    Feature: Login na conta
    Scenario: Usuário preenche campos de login com informações inválidas
      Given que o usuário esteja na página de login
      When o usuário preencher o campo "Usuário" com uma entrada inválida
      And o usuário preencher o campo "Senha" com uma entrada inválida
      And o usuário clicar no botão "LOG IN"
      Then o sistema deve exibir uma mensagem de erro amigável
      And não conceder acesso à conta do usuário

cenario_bdd:
  nome: Usuário deixa campos de login em branco
  tipo: negativo
  gherkin: |
    Feature: Login na conta
    Scenario: Usuário deixa campos de login em branco
      Given que o usuário esteja na página de login
      When o usuário não preencher o campo "Usuário"
      And o usuário não preencher o campo "Senha"
      And o usuário clicar no botão "LOG IN"
      Then o sistema deve exibir uma mensagem de erro amigável
      And não conceder acesso à conta do usuário

Título da User Story: US02 - Serviços bancários online

cenario_bdd:
  nome: Usuário acessa serviços bancários online
  tipo: positivo
  gherkin: |
    Feature: Serviços bancários online
    Scenario: Usuário acessa serviços bancários online
      Given que o usuário esteja logado em sua conta
      When o usuário clicar na seção "Serviços Online"
      Then o sistema deve exibir as opções de "Bill Pay", "Account History", "Transfer Funds" e outras funcionalidades relevantes
      And o usuário deve poder realizar transações financeiras através dessas opções

cenario_bdd:
  nome: Usuário insere informações inválidas durante uma transação
  tipo: negativo
  gherkin: |
    Feature: Serviços bancários online
    Scenario: Usuário insere informações inválidas durante uma transação
      Given que o usuário esteja logado em sua conta
      When o usuário clicar na opção "Transfer Funds"
      And o usuário preencher os campos com informações inválidas
      And o usuário clicar no botão de confirmação
      Then o sistema deve exibir uma mensagem de erro
      And não deve realizar a transação

cenario_bdd:
  nome: Usuário não possui saldo suficiente para realizar uma transação
  tipo: negativo
  gherkin: |
    Feature: Serviços bancários online
    Scenario: Usuário não possui saldo suficiente para realizar uma transação
      Given que o usuário esteja logado em sua conta
      When o usuário clicar na opção "Withdraw Funds"
      And o usuário tentar sacar um valor maior do que seu saldo
      And o usuário clicar no botão de confirmação
      Then o sistema deve exibir uma mensagem de erro informando saldo insuficiente
      And não deve realizar a transação

Título da User Story: US03 - Serviços bancários em caixas eletrônicos (ATM)

cenario_bdd:
  nome: Usuário acessa serviços bancários em caixas eletrônicos
  tipo: positivo
  gherkin: |
    Feature: Serviços bancários em caixas eletrônicos (ATM)
    Scenario: Usuário acessa serviços bancários em caixas eletrônicos
      Given que o usuário esteja na seção "Serviços ATM"
      When o usuário clicar nas opções de "Withdraw Funds", "Transfer Funds", "Check Balances" ou "Make Deposits"
      Then o sistema deve fornecer instruções claras sobre como realizar a transação no caixa eletrônico

cenario_bdd:
  nome: Usuário insere informações inválidas durante uma transação em caixa eletrônico
  tipo: negativo
  gherkin: |
    Feature: Serviços bancários em caixas eletrônicos (ATM)
    Scenario: Usuário insere informações inválidas durante uma transação em caixa eletrônico
      Given que o usuário esteja na seção "Serviços ATM"
      When o usuário clicar na opção "Withdraw Funds"
      And o usuário inserir informações inválidas no caixa eletrônico
      Then o sistema deve exibir uma mensagem de erro
      And não deve realizar a transação

cenario_bdd:
  nome: Usuário não possui saldo suficiente para realizar uma transação em caixa eletrônico
  tipo: negativo
  gherkin: |
    Feature: Serviços bancários em caixas eletrônicos (ATM)
    Scenario: Usuário não possui saldo suficiente para realizar uma transação em caixa eletrônico
      Given que o usuário esteja na seção "Serviços ATM"
      When o usuário clicar na opção "Withdraw Funds"
      And o usuário tentar sacar um valor maior do que seu saldo
      Then o sistema