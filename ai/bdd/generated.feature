```gherkin
# Feature: Cadastro de Usuário
#   Como usuário que nunca utilizou o ParaBank
#   Quero criar uma conta
#   Para acessar os serviços bancários online
Feature: Cadastro de Usuário

  Scenario: Cadastro completo e válido
    Given eu acesso a página de cadastro
    When preencho todos os campos obrigatórios com dados válidos
      | Campo          | Valor                    |
      | Nome           | João da Silva            |
      | CPF            | 123.456.789-00           |
      | Email          | joao@email.com          |
      | Telefone       | (11)98765-4321           |
      | CEP            | 01001-000                |
      | Senha          | Senha@123                |
      | Confirma Senha | Senha@123                |
    And clico em "Registrar"
    Then devo ver a mensagem "Cadastro concluído"
    And devo ser redirecionado para a página de login

  Scenario: Cadastro com campo obrigatório em branco
    Given eu acesso a página de cadastro
    When preencho o campo "Nome" com ""
    And clico em "Registrar"
    Then devo ver mensagem de erro "Nome é obrigatório"
    And o formulário não deve ser submetido

  Scenario: Cadastro com CEP inválido
    Given eu acesso a página de cadastro
    When preencho o campo "CEP" com "ABCDE"
    And clico em "Registrar"
    Then devo ver mensagem de erro "CEP inválido"
    And o formulário não deve ser submetido

  Scenario: Cadastro com telefone com formato errado
    Given eu acesso a página de cadastro
    When preencho o campo "Telefone" com "123456"
    And clico em "Registrar"
    Then devo ver mensagem de erro "Telefone inválido"
    And o formulário não deve ser submetido

  Scenario: Cadastro com email sem “@”
    Given eu acesso a página de cadastro
    When preencho o campo "Email" com "joaoemail.com"
    And clico em "Registrar"
    Then devo ver mensagem de erro "Email inválido"
    And o formulário não deve ser submetido

  Scenario: Cadastro com senha e confirmação diferentes
    Given eu acesso a página de cadastro
    When preencho o campo "Senha" com "Senha@123"
    And preencho o campo "Confirma Senha" com "Senha@321"
    And clico em "Registrar"
    Then devo ver mensagem de erro "Senha e confirmação não coincidem"
    And o formulário não deve ser submetido
```

```gherkin
# Feature: Login do Usuário
#   Como usuário já registrado
#   Quero fazer login usando email e senha
#   Para acessar minha conta e serviços bancários
Feature: Login do Usuário

  Scenario: Login com credenciais corretas
    Given eu acesso a página de login
    When preencho "Email" com "joao@email.com"
    And preencho "Senha" com "Senha@123"
    And clico em "Entrar"
    Then devo ser redirecionado para a Dashboard
    And a mensagem "Bem‑vindo, João" é exibida

  Scenario: Login com senha incorreta
    Given eu acesso a página de login
    When preencho "Email" com "joao@email.com"
    And preencho "Senha" com "Errada@123"
    And clico em "Entrar"
    Then devo ver a mensagem "Usuário ou senha inválidos"
    And não devo ser redirecionado para a Dashboard

  Scenario: Login com email inexistente
    Given eu acesso a página de login
    When preencho "Email" com "naoexiste@email.com"
    And preencho "Senha" com "Senha@123"
    And clico em "Entrar"
    Then devo ver a mensagem "Usuário ou senha inválidos"
    And não devo ser redirecionado para a Dashboard

  Scenario: Login com campo em branco
    Given eu acesso a página de login
    When deixo os campos de email e senha em branco
    And clico em "Entrar"
    Then devo ver mensagens de erro "Email é obrigatório" e "Senha é obrigatória"
    And não devo ser redirecionado para a Dashboard
```

```gherkin
# Feature: Visualização do Saldo
#   Como usuário logado
#   Quero ver meu saldo atual
#   Para saber quanto dinheiro tenho disponível
Feature: Visualização do Saldo

  Scenario: Saldo exibido após login
    Given estou logado na Dashboard
    Then devo ver o saldo exibido em destaque

  Scenario: Saldo atualizado após transferência
    Given estou logado na Dashboard
    And tenho saldo de R$ 500,00
    When faço uma transferência de R$ 100,00 para outra conta
    Then o saldo exibido deve ser R$ 400,00

  Scenario: Saldo atualizado após pagamento de conta
    Given estou logado na Dashboard
    And tenho saldo de R$ 300,00
    When pago R$ 50,00 em uma conta a pagar
    Then o saldo exibido deve ser R$ 250,00
```

```gherkin
# Feature: Exibição do Extrato
#   Como usuário logado
#   Quero visualizar o extrato de transações
#   Para acompanhar histórico e validar movimentações
Feature: Exibição do Extrato

  Scenario: Extrato mostra transações em ordem cronológica
    Given estou na página de Extrato
    And existem transações nas datas 01/10/2024, 02/10/2024 e 03/10/2024
    Then a lista deve exibir primeiro a transação de 03/10/2024
    And em seguida 02/10/2024
    And depois 01/10/2024

  Scenario: Cada entrada exibe detalhes corretos
    Given estou na página de Extrato
    And há uma transação de R$ 200,00 de crédito em 02/10/2024
    Then a linha da transação deve mostrar
      | Data      | Descrição | Débito | Crédito | Saldo Após |
      | 02/10/2024 | Depósito  |        | 200,00 | 700,00      |

  Scenario: Página carrega sem erros de navegação
    Given estou na página de Extrato
    And não há erros 404 ou 500
    Then a página deve ser carregada corretamente
```

```gherkin
# Feature: Transferência de Fundos
#   Como usuário que possui várias contas
#   Quero transferir fundos entre minhas contas
#   Para movimentar recursos conforme necessidade
Feature: Transferência de Fundos

  Scenario: Transferência válida entre contas
    Given estou na tela de Transferência
    And minha Conta A tem saldo de R$ 500,00
    When escolho conta origem "Conta A"
    And escolho conta destino "Conta B"
    And insiro valor "200,00"
    And clico em "Confirmar"
    Then o saldo da Conta A deve ser R$ 300,00
    And o saldo da Conta B deve ser atualizado com +R$ 200,00
    And a transação deve aparecer no extrato de ambas as contas

  Scenario: Transferência com saldo insuficiente
    Given estou na tela de Transferência
    And minha Conta A tem saldo de R$ 100,00
    When escolho conta origem "Conta A"
    And escolho conta destino "Conta B"
    And insiro valor "150,00"
    And clico em "Confirmar"
    Then devo ver mensagem de erro "Saldo insuficiente"
    And os saldos das contas não devem mudar

  Scenario: Transferência com valor em branco
    Given estou na tela de Transferência
    When deixo o campo "Valor" em branco
    And clico em "Confirmar"
    Then devo ver mensagem de erro "Valor é obrigatório"
    And a transferência não é realizada

  Scenario: Transferência para a mesma conta (não permitido)
    Given estou na tela de Transferência
    When escolho conta origem "Conta A"
    And escolho conta destino "Conta A"
    And insiro valor "50,00"
    And clico em "Confirmar"
    Then devo ver mensagem de erro "Conta origem e destino não podem ser iguais"
    And a transferência não é realizada
```

```gherkin
# Feature: Solicitação de Empréstimo
#   Como usuário interessado em crédito
#   Quero solicitar um empréstimo
#   Para obter recursos adicionais
Feature: Solicitação de Empréstimo

  Scenario: Empréstimo aprovado
    Given estou na tela de Empréstimo
    When preencho o valor "10.000,00"
    And preencho a renda anual "120.000,00"
    And clico em "Solicitar"
    Then devo ver a mensagem "Empréstimo aprovado"
    And o valor do empréstimo deve aparecer no extrato

  Scenario: Empréstimo negado por renda insuficiente
    Given estou na tela de Empréstimo
    When preencho o valor "10.000,00"
    And preencho a renda anual "20.000,00"
    And clico em "Solicitar"
    Then devo ver a mensagem "Empréstimo negado"
    And não há registro no extrato

  Scenario: Empréstimo com campo vazio
    Given estou na tela de Empréstimo
    When deixo o campo "Valor" em branco
    And clico em "Solicitar"
    Then devo ver mensagem de erro "Valor é obrigatório"
    And a solicitação não é processada
```

```gherkin
# Feature: Registro de Pagamentos de Contas
#   Como usuário que tem contas a pagar
#   Quero registrar pagamentos de contas
#   Para manter histórico e agendar futuros pagamentos
Feature: Registro de Pagamentos de Contas

  Scenario: Pagamento imediato registrado com sucesso
    Given estou na tela de Pagamento
    When preencho
      | Beneficiário | Conta Bancária | Valor | Data de Pagamento |
      | Luz           | 1234-5         | 200   | 01/10/2024        |
    And clico em "Registrar"
    Then devo ver mensagem "Pagamento registrado com sucesso"
    And a transação deve aparecer no extrato com data 01/10/2024

  Scenario: Pagamento futuro agendado corretamente
    Given estou na tela de Pagamento
    When preencho
      | Beneficiário | Conta Bancária | Valor | Data de Pagamento |
      | Água          | 5678-9         | 120   | 10/10/2024        |
    And clico em "Registrar"
    Then devo ver mensagem "Pagamento agendado para 10/10/2024"
    And a transação não deve aparecer no extrato antes da data agendada

  Scenario: Pagamento com data no passado
    Given estou na tela de Pagamento
    When preencho
      | Beneficiário | Conta Bancária | Valor | Data de Pagamento |
      | Internet     | 1111-1         | 80    | 01/01/2023        |
    And clico em "Registrar"
    Then devo ver mensagem de erro "Data de pagamento não pode ser anterior à data atual"
    And a transação não é cadastrada

  Scenario: Registro de pagamento com campo obrigatório vazio
    Given estou na tela de Pagamento
    When deixo o campo "Beneficiário" em branco
    And clico em "Registrar"
    Then devo ver mensagem de erro "Beneficiário é obrigatório"
    And a transação não é cadastrada
```

```gherkin
# Feature: Navegação sem erros de página
#   Como qualquer usuário
#   Quero que todas as páginas carreguem sem erros de navegação
#   Para garantir experiência de uso fluída
Feature: Navegação Sem Erros

  Scenario: Todos os links e botões funcionam em todas as páginas
    Given acesso a todas as páginas do sistema (Dashboard, Cadastro, Login, Transferência, Empréstimo, Pagamentos, Extrato)
    When clico em todos os links e botões disponíveis
    Then cada navegação deve resultar em carregamento completo sem mensagens 404 ou 500

  Scenario: Menus e links permanecem consistentes
    Given acesso à página inicial
    When observo o menu principal
    Then devo ver os itens "Minha Conta", "Transferir", "Empréstimos" e "Pagamentos" visíveis e funcionando
```

```gherkin
# Feature: Feedback Imediato em Cada Ação
#   Como qualquer usuário
#   Quero que o sistema forneça feedback imediato em cada ação
#   Para saber se a operação foi bem‑sucesso ou falhou
Feature: Feedback Imediato

  Scenario: Mensagem de sucesso após cadastro
    Given eu finalizo o cadastro corretamente
    Then devo ver um banner verde com a mensagem "Cadastro concluído"

  Scenario: Mensagem de erro ao tentar login com senha inválida
    Given estou na tela de login
    When preencho senha inválida
    And clico em "Entrar"
    Then devo ver um banner vermelho com a mensagem "Usuário ou senha inválidos"

  Scenario: Mensagem de sucesso após transferência
    Given estou na tela de Transferência e faço uma transferência válida
    Then devo ver um modal verde com a mensagem "Transferência concluída"

  Scenario: Mensagem de erro de saldo insuficiente
    Given faço uma transferência que excede o saldo disponível
    Then devo ver um modal vermelho com a mensagem "Saldo insuficiente"

  Scenario: Mensagem de erro ao enviar formulário incompleto
    Given deixo um campo obrigatório em branco e envio o formulário
    Then devo ver um banner amarelo com a mensagem "Campos obrigatórios não preenchidos"

  Scenario: Mensagens exibidas de forma contextual
    Given a operação falha
    Then a mensagem exibida deve indicar a causa específica (ex.: "CPF já cadastrado" ou "Conta inexistente")
```

Cada *Feature* contempla cenários positivos e negativos, cobrindo todos os critérios de aceitação das User Stories indicadas. Os cenários são escritos em português e seguem a estrutura Gherkin, prontamente utilizáveis em ferramentas de BDD como Cucumber, SpecFlow ou Behave.