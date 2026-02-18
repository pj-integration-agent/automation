Título da User Story: US01 - Login Seguro

cenario_bdd:
  nome: Realizar login com sucesso
  tipo: positivo
  gherkin: |
    Feature: Realizar login no sistema
    Scenario: Realizar login com credenciais válidas
      Given que o cliente acessa a página de login
      When o cliente preenche o username "johndoe" e a senha "password123"
      And clica no botão de login
      Then o sistema autentica as credenciais
      And concede acesso ao sistema
      And exibe a página inicial do sistema

cenario_bdd:
  nome: Falha no login por credenciais inválidas
  tipo: negativo
  gherkin: |
    Feature: Realizar login no sistema
    Scenario: Realizar login com credenciais inválidas
      Given que o cliente acessa a página de login
      When o cliente preenche o username "invaliduser" e a senha "invalidpass"
      And clica no botão de login
      Then o sistema não autentica as credenciais
      And exibe uma mensagem de erro informando que as credenciais são inválidas

cenario_bdd:
  nome: Falha no login por campos vazios
  tipo: negativo
  gherkin: |
    Feature: Realizar login no sistema
    Scenario: Realizar login com campos vazios
      Given que o cliente acessa a página de login
      When o cliente não preenche o username e a senha
      And clica no botão de login
      Then o sistema não autentica as credenciais
      And exibe uma mensagem de erro informando que os campos de username e senha são obrigatórios

Título da User Story: US02 - Sacar Dinheiro no ATM

cenario_bdd:
  nome: Sacar dinheiro com sucesso
  tipo: positivo
  gherkin: |
    Feature: Sacar dinheiro no ATM
    Scenario: Sacar dinheiro com saldo suficiente
      Given que o cliente acessa o serviço de ATM
      And o cliente possui saldo de R$ 1.000,00 em sua conta
      When o cliente seleciona a opção de saque
      And informa o valor de R$ 200,00 para saque
      Then o sistema valida o saldo
      And realiza o saque da conta
      And atualiza o saldo da conta para R$ 800,00
      And exibe uma mensagem de sucesso informando o valor sacado

cenario_bdd:
  nome: Falha no saque por saldo insuficiente
  tipo: negativo
  gherkin: |
    Feature: Sacar dinheiro no ATM
    Scenario: Sacar dinheiro com saldo insuficiente
      Given que o cliente acessa o serviço de ATM
      And o cliente possui saldo de R$ 50,00 em sua conta
      When o cliente seleciona a opção de saque
      And informa o valor de R$ 100,00 para saque
      Then o sistema valida o saldo
      And exibe uma mensagem de erro informando que o saldo é insuficiente para o saque

cenario_bdd:
  nome: Falha no saque por valor inválido
  tipo: negativo
  gherkin: |
    Feature: Sacar dinheiro no ATM
    Scenario: Sacar dinheiro com valor inválido
      Given que o cliente acessa o serviço de ATM
      And o cliente possui saldo de R$ 1.000,00 em sua conta
      When o cliente seleciona a opção de saque
      And informa o valor de R$ -50,00 para saque
      Then o sistema valida o valor
      And exibe uma mensagem de erro informando que o valor de saque é inválido

Título da User Story: US03 - Transferir Dinheiro

cenario_bdd:
  nome: Transferir dinheiro com sucesso
  tipo: positivo
  gherkin: |
    Feature: Transferir dinheiro entre contas
    Scenario: Transferir dinheiro com saldo suficiente
      Given que o cliente acessa o serviço de transferência
      And o cliente possui saldo de R$ 1.000,00 na conta origem
      When o cliente seleciona a conta destino
      And informa o valor de R$ 200,00 para transferência
      Then o sistema valida o saldo da conta origem
      And realiza a transferência
      And atualiza o saldo da conta origem para R$ 800,00
      And atualiza o saldo da conta destino para R$ 200,00
      And exibe uma mensagem de sucesso informando a transferência

cenario_bdd:
  nome: Falha na transferência por saldo insuficiente
  tipo: negativo
  gherkin: |
    Feature: Transferir dinheiro entre contas
    Scenario: Transferir dinheiro com saldo insuficiente
      Given que o cliente acessa o serviço de transferência
      And o cliente possui saldo de R$ 50,00 na conta origem
      When o cliente seleciona a conta destino
      And informa o valor de R$ 100,00 para transferência
      Then o sistema valida o saldo da conta origem
      And exibe uma mensagem de erro informando que o saldo é insuficiente para a transferência

cenario_bdd:
  nome: Falha na transferência por valor inválido
  tipo: negativo
  gherkin: |
    Feature: Transferir dinheiro entre contas
    Scenario: Transferir dinheiro com valor inválido
      Given que o cliente acessa o serviço de transferência
      And o cliente possui saldo de R$ 1.000,00 na conta origem
      When o cliente seleciona a conta destino
      And informa o valor de R$ -50,00 para transferência
      Then o sistema valida o valor da transferência
      And exibe uma mensagem de erro informando que o valor da transferência é