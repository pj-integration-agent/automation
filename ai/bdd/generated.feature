```gherkin
# Feature: Cadastro de Usuário
Feature: Cadastro de Usuário
  Como usuário novo
  Quero preencher um formulário de cadastro completo
  Para que eu possa criar minha conta no ParaBank

  @positive
  Scenario: Usuário preenche cadastro completo com dados válidos
    Given I open the “Cadastro” page
    When I enter
      | campo        | valor                 |
      | Nome         | João da Silva         |
      | CPF          | 12345678901           |
      | Endereço     | Rua das Flores, 123   |
      | Telefone     | (11)98765-4321        |
      | CEP          | 12345678              |
      | E‑mail       | joao.silva@email.com |
      | Senha        | MinhaSenha!123        |
      | Confirmação  | MinhaSenha!123        |
    And I click “Cadastrar”
    Then I should see a banner “Cadastro concluído com sucesso! Faça login.”

  @negative
  Scenario: Usuário deixa um campo obrigatório vazio
    Given I open the “Cadastro” page
    When I leave “CPF” empty
    And I fill all other fields with valid data
    And I click “Cadastrar”
    Then I should see an error message “O campo CPF é obrigatório”

  @negative
  Scenario Outline: Validação de formatos de campos inválidos
    Given I open the “Cadastro” page
    When I enter
      | campo        | valor                 |
      | Nome         | Maria Oliveira        |
      | CPF          | <cpf>                 |
      | Endereço     | Av. Central, 456      |
      | Telefone     | <telefone>            |
      | CEP          | <cep>                 |
      | E‑mail       | <email>               |
      | Senha        | Segura123!            |
      | Confirmação  | Segura123!            |
    And I click “Cadastrar”
    Then I should see the error message "<mensagem>"

    Examples:
      | cpf        | telefone          | cep     | email                       | mensagem                                   |
      | 123          | 11-987654321     | 1234    | joao.silva                 | O campo CPF deve conter 11 dígitos          |
      | 12345678901 | (11)987654321     | 1234567 | joao.silva@email           | O campo Telefone deve ter o formato (xx)xxxxx‑xxxx |
      | 12345678901 | (11)987654321     | 1234567 | joao.silva@email.com       | O campo CEP deve conter 8 dígitos            |
      | 12345678901 | (11)987654321     | 12345678 | joao.silva                  | O campo E‑mail deve ter um endereço válido   |

  @positive
  Scenario: Usuário recebe e‑mail de confirmação após cadastro
    Given I have completed the registration successfully
    Then an e‑mail should be sent to “joao.silva@email.com” containing a “link de validação”

# Feature: Login
Feature: Login
  Como usuário cadastrado
  Quero entrar no sistema usando credenciais válidas
  Para que eu possa acessar minha conta

  @positive
  Scenario: Usuário entra com CPF e senha corretos
    Given I open the “Login” page
    When I enter “12345678901” as CPF
    And I enter “MinhaSenha!123” as senha
    And I click “Entrar”
    Then I should be redirected to the “Dashboard” page

  @negative
  Scenario: Usuário entra com senha inválida
    Given I open the “Login” page
    When I enter “12345678901” as CPF
    And I enter “SenhaErrada” as senha
    And I click “Entrar”
    Then I should see the message “CPF ou senha inválidos.”

  @negative
  Scenario: Usuário entra com CPF inválido
    Given I open the “Login” page
    When I enter “11111111111” as CPF
    And I enter “MinhaSenha!123” as senha
    And I click “Entrar”
    Then I should see the message “CPF ou senha inválidos.”

  @negative
  Scenario: Usuário excede tentativas de login
    Given I open the “Login” page
    When I fail to login 5 times with incorrect credentials
    Then I should see the message “Tentativas excedidas. Aguarde 5 min.”

# Feature: Acesso à Conta – Saldo e Extrato
Feature: Acesso à Conta – Saldo e Extrato
  Como cliente logado
  Quero visualizar meu saldo atual e extrato em ordem cronológica
  Para que eu saiba exatamente meus recursos disponíveis

  @positive
  Scenario: Usuário visualiza saldo após operação de depósito
    Given I am logged in
    And I have deposited R$ 1.000,00 into my account
    When I go to the “Saldo” tab
    Then I should see the balance “R$ 1.000,00”

  @positive
  Scenario: Usuário visualiza extrato em ordem cronológica
    Given I am logged in
    And I have performed 12 transactions in the last month
    When I go to the “Extrato” tab
    Then the first 10 entries should be displayed in descending date order
    And each entry should contain date, description, type, value, and post‑transaction balance

# Feature: Transferência de Fundos
Feature: Transferência de Fundos
  Como cliente logado
  Quero transferir dinheiro para outra conta
  Para que eu possa movimentar recursos entre minhas contas

  @positive
  Scenario: Usuário transfere dinheiro com saldo suficiente
    Given I am logged in
    And I have a balance of R$ 5.000,00
    When I navigate to the “Transferir” page
    And I enter destination account “987654321” and amount “R$ 1.500,00”
    And I click “Confirmar”
    Then I should see the message “Transferência concluída com sucesso”
    And my balance should be updated to “R$ 3.500,00”

  @negative
  Scenario: Usuário tenta transferir valor maior que o saldo
    Given I am logged in
    And I have a balance of R$ 2.000,00
    When I navigate to the “Transferir” page
    And I enter destination account “987654321” and amount “R$ 3.000,00”
    And I click “Confirmar”
    Then I should see the message “Saldo insuficiente”

  @positive
  Scenario Outline: Registro de transferência no histórico de ambas as contas
    Given I am logged in as <cpfOrigem> with balance R$ 5.000,00
    When I transfer R$ 500,00 to account <cpfDestino>
    Then the origin account history should contain a “Transferência de <cpfDestino>” entry
    And the destination account history should contain a “Transferência de <cpfOrigem>” entry

    Examples:
      | cpfOrigem     | cpfDestino   |
      | 12345678901   | 10987654321  |

# Feature: Solicitação de Empréstimo
Feature: Solicitação de Empréstimo
  Como cliente logado
  Quero solicitar empréstimo indicando valor e renda anual
  Para que eu possa obter recursos adicionais se necessário

  @positive
  Scenario: Usuário solicita empréstimo aprovado
    Given I am logged in
    When I request a loan of R$ 20.000,00 with annual income R$ 120.000,00
    Then I should see the status “Aprovado” within 2 seconds
    And I should see available terms and interest rates

  @negative
  Scenario: Usuário solicita empréstimo negado por renda insuficiente
    Given I am logged in
    When I request a loan of R$ 50.000,00 with annual income R$ 30.000,00
    Then I should see the status “Negado” within 2 seconds
    And I should see the reason “Renda insuficiente”

# Feature: Pagamento de Contas
Feature: Pagamento de Contas
  Como cliente logado
  Quero registrar pagamento de conta a futuro
  Para que eu garanta que a transação ocorrerá na data certa

  @positive
  Scenario: Usuário agenda pagamento futuro
    Given I am logged in
    When I schedule a payment to “Conta X” for R$ 200,00 on the 25th of the next month
    Then the payment should appear in the scheduled payments list
    And the transaction should be recorded on the 25th

  @negative
  Scenario: Usuário tenta agendar pagamento em dia passado
    Given I am logged in
    When I try to schedule a payment for yesterday’s date
    Then I should see an error message “A data de pagamento deve ser futura”

# Feature: Navegação e Usabilidade
Feature: Navegação e Usabilidade
  Como usuário em qualquer página
  Quero navegar sem erros
  Para que minha experiência seja fluida

  @negative
  Scenario: Usuário acessa rota inexistente e recebe página 404
    Given I am logged in
    When I navigate to “/caminho/invalido”
    Then I should see the “Erro 404 – Página não encontrada” page

  @positive
  Scenario: Mensagens de erro aparecem localizadas e claras
    Given I am on the “Cadastro” page
    When I submit the form with an invalid e‑mail
    Then the error message should appear next to the e‑mail field
    And the message should read “O campo E‑mail deve ter um endereço válido”

  @positive
  Scenario: Menus e links são consistentes em todas as páginas
    Given I am logged in
    When I navigate to each of the main pages: “Dashboard”, “Transferir”, “Empréstimo”, “Pagamentos”, “Logout”
    Then each page should contain the same top menu structure with these items
    And the layout should adapt responsively to mobile viewports
```