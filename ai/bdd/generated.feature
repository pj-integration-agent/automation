Título da User Story: Realizar login no sistema

cenario_bdd:
  nome: Realizar login com credenciais válidas
  tipo: positivo
  gherkin: |
    Feature: Login do usuário
    Scenario: Realizar login com credenciais válidas
      Given que o usuário está na tela de login
      When o usuário insere o nome de usuário "joaosilva" e a senha "123456"
      Then o sistema deve conceder acesso ao usuário
      And redirecionar o usuário para a página inicial

cenario_bdd:
  nome: Realizar login com credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Login do usuário
    Scenario: Realizar login com credenciais inválidas
      Given que o usuário está na tela de login
      When o usuário insere o nome de usuário "joaosilva" e a senha "abcdef"
      Then o sistema deve exibir uma mensagem de erro informando que as credenciais são inválidas
      And não conceder acesso ao usuário

cenario_bdd:
  nome: Realizar login com campos em branco
  tipo: negativo
  gherkin: |
    Feature: Login do usuário
    Scenario: Realizar login com campos em branco
      Given que o usuário está na tela de login
      When o usuário não preenche o nome de usuário e a senha
      Then o sistema deve exibir uma mensagem de erro informando que os campos são obrigatórios
      And não conceder acesso ao usuário

Título da User Story: Visualizar saldo bancário

cenario_bdd:
  nome: Visualizar saldo bancário após login
  tipo: positivo
  gherkin: |
    Feature: Visualização de saldo bancário
    Scenario: Visualizar saldo bancário após login
      Given que o usuário fez login no sistema
      When o usuário acessa a página inicial
      Then o sistema deve exibir o saldo bancário do usuário de forma clara e destacada
      And informar a data e hora da última atualização do saldo

cenario_bdd:
  nome: Visualizar extrato de movimentações
  tipo: positivo
  gherkin: |
    Feature: Visualização de saldo bancário
    Scenario: Visualizar extrato de movimentações
      Given que o usuário está na página inicial
      When o usuário acessa a opção de visualizar extrato
      Then o sistema deve exibir o histórico de movimentações bancárias do usuário

Título da User Story: Realizar transferência bancária

cenario_bdd:
  nome: Realizar transferência com sucesso
  tipo: positivo
  gherkin: |
    Feature: Transferência bancária
    Scenario: Realizar transferência com sucesso
      Given que o usuário está logado no sistema
      When o usuário preenche os dados da transferência:
        | Conta de Origem | 12345-6 |
        | Conta de Destino | 98765-0 |
        | Valor           | 500.00  |
      And o usuário confirma a transferência
      Then o sistema deve processar a transferência em tempo real
      And atualizar os saldos das contas envolvidas
      And exibir uma confirmação da transferência realizada com sucesso

cenario_bdd:
  nome: Realizar transferência com saldo insuficiente
  tipo: negativo
  gherkin: |
    Feature: Transferência bancária
    Scenario: Realizar transferência com saldo insuficiente
      Given que o usuário está logado no sistema
      When o usuário preenche os dados da transferência:
        | Conta de Origem | 12345-6 |
        | Conta de Destino | 98765-0 |
        | Valor           | 10000.00 |
      And o usuário confirma a transferência
      Then o sistema deve exibir uma mensagem de erro informando que não há saldo suficiente na conta de origem
      And não processar a transferência

cenario_bdd:
  nome: Realizar transferência com conta de destino inválida
  tipo: negativo
  gherkin: |
    Feature: Transferência bancária
    Scenario: Realizar transferência com conta de destino inválida
      Given que o usuário está logado no sistema
      When o usuário preenche os dados da transferência:
        | Conta de Origem | 12345-6 |
        | Conta de Destino | 98765-x |
        | Valor           | 500.00  |
      And o usuário confirma a transferência
      Then o sistema deve exibir uma mensagem de erro informando que a conta de destino é inválida
      And não processar a transferência

Título da User Story: Solicitar empréstimo

cenario_bdd:
  nome: Solicitar empréstimo com sucesso
  tipo: positivo
  gherkin: |
    Feature: Solicitação de empréstimo
    Scenario: Solicitar empréstimo com sucesso
      Given que o usuário está logado no sistema
      When o usuário preenche os dados da solicitação de empréstimo:
        | Valor       | 10000.00 |
        | Prazo       | 24 meses |
        | Finalidade  | Compra de carro |
      And o usuário envia a solicitação
      Then o sistema deve validar os dados da solicitação
      And exibir uma estimativa das parcelas e taxas do empréstimo
      And permitir que o usuário acompanhe o status da solicitação

cenario_bdd:
  nome: Solicitar empréstimo com valor acima do limite
  tipo: negativo
  gherkin: |
    Feature: Solicitação de empréstimo
    Scenario: Solicitar empréstimo com valor acima do limite
      Given que o usuário está logado no sistema
      When o usuário preenche os dados da solicitação de