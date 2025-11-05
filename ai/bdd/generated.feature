## Feature: Cadastro de Usuário

```gherkin
Feature: Cadastro de Usuário
  Como novo cliente do ParaBank
  Quero cadastrar minha conta no sistema
  Para que eu possa usar todos os serviços bancários disponíveis

  @positive
  Scenario: Registro completo com dados válidos
    Given o usuário navega na página de cadastro
    When o usuário preenche todos os campos obrigatórios
      | nome      | João      |
      | sobrenome | Silva     |
      | telefone  | (11) 98765-4321 |
      | CEP       | 12345678  |
      | email     | joao.silva@example.com |
      | senha     | Passw0rd! |
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “Cadastro realizado com sucesso”
    And o usuário deve ser habilitado a fazer login

  @negative
  Scenario Outline: Campos obrigatórios vazios
    Given o usuário navega na página de cadastro
    When o usuário deixa o campo <campo> vazio
    And preenche os demais campos com valores válidos
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “O campo <campo> é obrigatório”

    Examples:
      | campo     |
      | nome      |
      | sobrenome |
      | telefone  |
      | CEP       |
      | email     |
      | senha     |

  @negative
  Scenario: Telefone com formato inválido
    Given o usuário navega na página de cadastro
    When o usuário preenche o campo telefone com “1234567890”
    And preenche os demais campos com valores válidos
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “Telefone inválido. Use DDD + número”

  @negative
  Scenario: CEP com dígitos inválidos
    Given o usuário navega na página de cadastro
    When o usuário preenche o campo CEP com “1234”
    And preenche os demais campos com valores válidos
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “CEP inválido. Use 8 dígitos numéricos”

  @negative
  Scenario: Email com sintaxe inválida
    Given o usuário navega na página de cadastro
    When o usuário preenche o campo email com “joao.silva@com”
    And preenche os demais campos com valores válidos
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “E‑mail inválido”

  @negative
  Scenario: Email já registrado no banco de dados
    Given o usuário navega na página de cadastro
    When o usuário preenche o campo email com “joao.existente@example.com”
    And preenche os demais campos com valores válidos
    And clica em “Cadastrar”
    Then o sistema deve exibir a mensagem “E‑mail já cadastrado”
```

---

## Feature: Login

```gherkin
Feature: Login
  Como usuário autenticado do ParaBank
  Quero fazer login com minhas credenciais
  Para que eu acesse minha conta e realize transações

  @positive
  Scenario: Login com credenciais corretas
    Given o usuário está na página de login
    When o usuário digita o e‑mail “joao.silva@example.com” e a senha “Passw0rd!”
    And clica em “Entrar”
    Then o usuário deve ser redirecionado para a página inicial da conta

  @negative
  Scenario Outline: Credenciais inválidas
    Given o usuário está na página de login
    When o usuário digita o e‑mail "<email>" e a senha "<senha>"
    And clica em “Entrar”
    Then o sistema deve exibir a mensagem “Credenciais inválidas. Por favor, tente novamente.”

    Examples:
      | email                       | senha      |
      | invalido@example.com        | Passw0rd!  |
      | joao.silva@example.com      | WrongPass! |
      |                            | Passw0rd!  |

  @negative
  Scenario: Bloqueio após cinco tentativas falhadas
    Given o usuário está na página de login
    And o usuário já tentou entrar cinco vezes com credenciais inválidas
    When o usuário digita o e‑mail “joao.silva@example.com” e a senha “Passw0rd!”
    And clica em “Entrar”
    Then o sistema deve exibir a mensagem “Conta bloqueada. Tente novamente em 15 minutos.”
```

---

## Feature: Exibição do Saldo

```gherkin
Feature: Exibição do Saldo
  Como cliente
  Quero ver meu saldo atualizado na página inicial
  Para que eu saiba quanto dinheiro tenho disponível a qualquer momento

  @positive
  Scenario: Saldo exibido após operação
    Given o usuário está na página inicial
    And o saldo atual é R$ 1.000,00
    When o usuário faz um depósito de R$ 500,00
    And a transação é processada
    Then o saldo exibido deve ser R$ 1.500,00
    And deve ter 2 casas decimais e separador de milhares
```

---

## Feature: Visualização do Extrato

```gherkin
Feature: Visualização do Extrato
  Como cliente
  Quero visualizar meu extrato de transações recentes
  Para que eu possa acompanhar todas as movimentações da conta

  @positive
  Scenario: Lista as 10 transações mais recentes
    Given o usuário está na página de extrato
    When o usuário solicita visualizar extrato
    Then o sistema deve exibir uma lista com 10 linhas
    And cada linha deve conter:
      | data          | descrição          | valor   | saldo pós‑transação |
    And o extrato deve estar em ordem cronológica (mais recente em primeiro)

  @positive
  Scenario: Acesso à página de extrato completo
    Given o usuário está na página de extrato
    When o usuário clica em “Ver mais”
    Then o sistema deve abrir a página de extrato completo
```

---

## Feature: Transferência de Fundos

```gherkin
Feature: Transferência de Fundos
  Como cliente com saldo disponível
  Quero transferir fundos de uma conta para outra
  Para que eu possa enviar dinheiro para parceiros ou outras contas pessoais

  @positive
  Scenario: Transferência com saldo suficiente
    Given o usuário está na tela de transferência
    And o saldo da conta de origem é R$ 1.000,00
    When o usuário seleciona a conta de destino “123456-7”
    And digita o valor “250,00”
    And confirma a transferência
    Then o valor deve ser debitado da conta de origem
    And o valor deve ser creditado na conta de destino
    And ambas as contas devem exibir a transação no histórico
    And o sistema deve enviar um e‑mail de confirmação com data, valor e contas

  @negative
  Scenario: Valor superior ao saldo disponível
    Given o usuário está na tela de transferência
    And o saldo da conta de origem é R$ 100,00
    When o usuário tenta transferir R$ 150,00
    And confirma a transferência
    Then o sistema deve exibir a mensagem “Saldo insuficiente”

  @negative
  Scenario: Valor com mais de duas casas decimais
    Given o usuário está na tela de transferência
    When o usuário digita o valor “100,123”
    And confirma a transferência
    Then o sistema deve exibir a mensagem “O valor deve ter no máximo 2 casas decimais”

  @negative
  Scenario: Conta de destino inexistente
    Given o usuário está na tela de transferência
    When o usuário digita o número de conta “000000‑0” que não existe
    And confirma a transferência
    Then o sistema deve exibir a mensagem “Conta de destino não encontrada”
```

---

## Feature: Solicitação de Empréstimo

```gherkin
Feature: Solicitação de Empréstimo
  Como cliente que precisa de capital adicional
  Quero solicitar um empréstimo
  Para que eu obtenha o montante necessário para meus projetos

  @positive
  Scenario: Empréstimo aprovado e creditado
    Given o usuário navega na tela de empréstimos
    And preenche o valor “10.000,00” e renda anual “50.000,00”
    When envia a solicitação
    Then o sistema deve responder “Aprovado”
    And deve exibir a razão “Renda suficiente”
    And o valor do empréstimo será creditado na conta em 24 h
    And o usuário pode visualizar o contrato e o cronograma de parcelas

  @negative
  Scenario: Empréstimo negado por renda insuficiente
    Given o usuário navega na tela de empréstimos
    And preenche o valor “20.000,00” e renda anual “30.000,00”
    When envia a solicitação
    Then o sistema deve responder “Negado”
    And deve exibir a mensagem “Renda insuficiente”
```

---

## Feature: Pagamento de Contas

```gherkin
Feature: Pagamento de Contas
  Como cliente
  Quero cadastrar e agendar pagamentos de contas
  Para que eu não perca vencimentos e mantenha meu crédito em dia

  @positive
  Scenario: Cadastro de pagamento agendado
    Given o usuário está na tela de pagamento de contas
    When o usuário preenche:
      | beneficiário | Contas Energia |
      | endereço     | Rua X, 123     |
      | cidade       | São Paulo      |
      | estado       | SP             |
      | CEP          | 12345678       |
      | telefone     | (11) 91234-5678 |
      | contaDestino | 765432-1       |
      | valor        | 200,00         |
      | dataPagamento | 2025‑12‑20   |
    And clica em “Agendar”
    Then o sistema exibe a confirmação “Pagamento agendado”
    And envia um e‑mail com a confirmação
    And o pagamento aparece no histórico na data programada

  @negative
  Scenario: Data de pagamento anterior à data atual
    Given o usuário está na tela de pagamento de contas
    When o usuário define a data de pagamento “2020‑01‑01”
    And tenta agendar
    Then o sistema exibe a mensagem “Data inválida. A data deve ser no futuro.”

  @negative
  Scenario: CEP inválido
    Given o usuário preenche o campo CEP com “1234”
    When tenta agendar
    Then o sistema exibe a mensagem “CEP inválido. Use 8 dígitos numéricos”

  @negative
  Scenario: Telefone com formato inválido
    Given o usuário preenche o campo telefone com “1234567890”
    When tenta agendar
    Then o sistema exibe a mensagem “Telefone inválido. Use DDD + número”

  @negative
  Scenario: Cancelamento após 24 h da data de pagamento
    Given o usuário tem um pagamento agendado para “2025‑12‑20”
    And a data atual é “2025‑12‑19”
    When tenta cancelar
    Then o sistema exibe a mensagem “Não é possível cancelar pagamentos a menos de 24 h do vencimento”
```

---

## Feature: Navegação e Usabilidade

```gherkin
Feature: Navegação e Usabilidade
  Como qualquer usuário
  Quero que todas as páginas e menus sejam consistentes e sem erros de navegação
  Para que a experiência seja intuitiva e sem frustração

  @positive
  Scenario: Todos os links de navegação estão ativos
    Given o usuário está em qualquer página
    When o usuário clica em cada link do menu superior, sidebar e footer
    Then cada link deve levar a sua respectiva página sem erros (404)

  @positive
  Scenario: Mensagens de erro destacadas
    Given o usuário tenta submeter um formulário com dados inválidos
    Then o sistema deve exibir a mensagem de erro em vermelho com ícone de alerta

  @positive
  Scenario: Tempo de carregamento abaixo de 3 s em 3G
    Given o usuário acessa qualquer página com conexão 3G
    When a página carrega
    Then o tempo de carregamento deve ser <= 3 segundos

  @positive
  Scenario: Layout responsivo em dispositivos móveis
    Given o usuário acessa a aplicação em um smartphone
    When o usuário navega pela aplicação
    Then a interface deve se adaptar ao tamanho da tela e manter todas as funcionalidades operacionais
```

---

**Observação:** Cada cenário acima cobre um ou mais critérios de aceite das histórias de usuário. Eles podem ser expandidos ou refinados conforme a evolução do produto e a necessidade de detalhamento de regras de negócio.