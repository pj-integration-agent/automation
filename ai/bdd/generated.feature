```
titulo: US01 – Cadastro de Usuário
cenario_bdd:
  - nome: Usuário cadastra conta com dados válidos
    tipo: positivo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Registro de um novo usuário com dados corretos
        Given eu estou na página de cadastro
        When preencho o nome completo "João da Silva"
        And preencho o e‑mail "joao.silva@email.com"
        And preencho o telefone "11987654321"
        And preencho o CEP "12345678"
        And preencho a senha "Segura123"
        And confirmo a senha "Segura123"
        And clico no botão "Criar Conta"
        Then devo receber uma mensagem de confirmação de e‑mail enviado
        And devo ser redirecionado para a tela de login

  - nome: Usuário tenta cadastrar sem preencher campos obrigatórios
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Não é possível enviar formulário vazio
        Given eu estou na página de cadastro
        When deixo todos os campos em branco
        And clico no botão "Criar Conta"
        Then devo ver uma mensagem "Preencha todos os campos obrigatórios" abaixo de cada campo

  - nome: E‑mail inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Validação de formato de e‑mail
        Given eu estou na página de cadastro
        When preencho o e‑mail "joaosilva@com"
        And preencho o restante dos campos corretamente
        And clico no botão "Criar Conta"
        Then devo ver a mensagem "Formato de e‑mail inválido" abaixo do campo de e‑mail

  - nome: CEP com menos de 8 dígitos
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Validação de CEP
        Given eu estou na página de cadastro
        When preencho o CEP "12345"
        And preencho os demais campos corretamente
        And clico no botão "Criar Conta"
        Then devo ver a mensagem "CEP inválido" abaixo do campo de CEP

  - nome: Telefone com caracteres não numéricos
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Validação de telefone
        Given eu estou na página de cadastro
        When preencho o telefone "11987-5432a"
        And preencho os demais campos corretamente
        And clico no botão "Criar Conta"
        Then devo ver a mensagem "Telefone deve conter apenas números" abaixo do campo de telefone

  - nome: Senhas não correspondem
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Validação de confirmação de senha
        Given eu estou na página de cadastro
        When preencho a senha "Segura123"
        And confirmo a senha "Segura321"
        And preencho os demais campos corretamente
        And clico no botão "Criar Conta"
        Then devo ver a mensagem "As senhas não correspondem" abaixo do campo de confirmação

titulo: US02 – Login
cenario_bdd:
  - nome: Login bem‑sucedido
    tipo: positivo
    gherkin: |
      Feature: Login
      Scenario: Usuário autenticado com credenciais corretas
        Given eu estou na página de login
        When preencho o e‑mail "joao.silva@email.com"
        And preencho a senha "Segura123"
        And clico em "Login"
        Then devo ser redirecionado para o Dashboard
        And devo ver o saldo da minha conta

  - nome: Login com credenciais inválidas
    tipo: negativo
    gherkin: |
      Feature: Login
      Scenario: Credenciais inválidas
        Given eu estou na página de login
        When preencho o e‑mail "joao.silva@email.com"
        And preencho a senha "Errada123"
        And clico em "Login"
        Then devo ver a mensagem "Credenciais inválidas. Tente novamente." no centro da página

  - nome: Login com campos vazios
    tipo: negativo
    gherkin: |
      Feature: Login
      Scenario: Campos obrigatórios não preenchidos
        Given eu estou na página de login
        When deixo o campo de e‑mail em branco
        And deixo o campo de senha em branco
        And clico em "Login"
        Then devo ver as mensagens "Campo obrigatório" abaixo de cada campo

titulo: US03 – Exibir Saldo e Extrato
cenario_bdd:
  - nome: Dashboard exibe saldo e extrato mínimo
    tipo: positivo
    gherkin: |
      Feature: Dashboard
      Scenario: Visualização de saldo e extrato
        Given eu estou autenticado e na página de Dashboard
        Then devo ver meu saldo atual exibido em moeda local
        And devo ver a lista com pelo menos 10 transações recentes
        And cada transação deve conter data, descrição, valor e tipo (C/D)

  - nome: Carregamento de extrato completo ao clicar em "Ver mais"
    tipo: positivo
    gherkin: |
      Feature: Dashboard
      Scenario: Carregar transações adicionais
        Given eu estou na página de Dashboard
        And já exibi as 10 transações recentes
        When clico em "Ver mais"
        Then as transações restantes devem ser carregadas sem recarregar a página inteira

  - nome: Mensagem de saldo quando nenhuma transação
    tipo: negativo
    gherkin: |
      Feature: Dashboard
      Scenario: Usuário sem transações
        Given eu estou autenticado e minha conta tem saldo mas zero transações
        When acesso o Dashboard
        Then devo ver a mensagem "Nenhuma transação encontrada" abaixo da lista de extrato

titulo: US04 – Transferência de Fundos
cenario_bdd:
  - nome: Transferência bem‑sucedida dentro do saldo disponível
    tipo: positivo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Transferir valor dentro do saldo
        Given eu estou autenticado na minha conta
        And meu saldo atual é R$ 5.000,00
        When seleciono a conta origem "Conta Corrente"
        And seleciono a conta destino "Conta Poupança"
        And informo o valor "1.000,00"
        And confirmo a transferência
        Then devo ver a mensagem "Transferência concluída – Ref: 123456"
        And meu saldo atual deve ser R$ 4.000,00
        And a conta de destino deve ter saldo atualizado

  - nome: Transferência com valor superior ao saldo
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Saldo insuficiente
        Given eu estou autenticado na minha conta
        And meu saldo atual é R$ 500,00
        When informo o valor "1.000,00"
        And confirmo a transferência
        Then devo ver a mensagem "Saldo insuficiente"

  - nome: Transferência com valor inválido (nulo ou negativo)
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Valor de transferência inválido
        Given eu estou na página de transferência
        When informo o valor "-100,00"
        And confirmo a transferência
        Then devo ver a mensagem "Valor de transferência inválido"

titulo: US05 – Solicitação de Empréstimo
cenario_bdd:
  - nome: Empréstimo aprovado
    tipo: positivo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Aprovação de empréstimo dentro dos limites
        Given eu estou autenticado na minha conta
        When preencho o valor do empréstimo "200.000"
        And preencho a renda anual "300.000"
        And confirmo a solicitação
        Then devo ver a mensagem "Empréstimo Aprovado – 12% ao ano"

  - nome: Empréstimo negado por renda insuficiente
    tipo: negativo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Negação por renda insuficiente
        Given eu estou autenticado na minha conta
        When preencho o valor do empréstimo "100.000"
        And preencho a renda anual "20.000"
        And confirmo a solicitação
        Then devo ver a mensagem "Empréstimo Negado – Renda insuficiente"

  - nome: Empréstimo negado por valor acima do limite
    tipo: negativo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Negação por valor acima do limite permitido
        Given eu estou autenticado na minha conta
        When preencho o valor do empréstimo "600.000"
        And preencho a renda anual "500.000"
        And confirmo a solicitação
        Then devo ver a mensagem "Dados fora do limite permitido"

titulo: US06 – Pagamento de Contas
cenario_bdd:
  - nome: Pagamento agendado para data futura
    tipo: positivo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Agendamento de pagamento futuro
        Given eu estou na página de pagamento de contas
        When preencho o beneficiário "Pedro"
        And preencho o endereço "Rua A, 123"
        And preencho a cidade "São Paulo"
        And preencho o estado "SP"
        And preencho o CEP "12345678"
        And preencho o telefone "11987654321"
        And preencho a conta de destino "123456789"
        And preencho o valor "200,00"
        And seleciono a data de pagamento "25/12/2025"
        And confirmo o pagamento
        Then devo ver a mensagem "Pagamento agendado para 25/12/2025"
        And o pagamento aparece no histórico com status "Agendado"

  - nome: Pagamento com data no passado
    tipo: negativo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Data de pagamento inválida
        Given eu estou na página de pagamento de contas
        When preencho todos os campos corretamente
        And seleciono a data de pagamento "01/01/2020"
        And confirmo o pagamento
        Then devo ver a mensagem "Data inválida – escolha uma data futura" abaixo do campo de data

  - nome: Pagamento com campo obrigatório em branco
    tipo: negativo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Campo obrigatório vazio
        Given eu estou na página de pagamento de contas
        When deixo o campo "Beneficiário" em branco
        And preencho os demais campos corretamente
        And confirmo o pagamento
        Then devo ver a mensagem "Campo obrigatório" abaixo do campo Beneficiário

titulo: US07 – Navegação e Usabilidade
cenario_bdd:
  - nome: Menu principal presente em todas as páginas
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
      Scenario: Verificar links do menu principal
        Given eu navego para a página de Dashboard
        Then devo ver o menu com os links "Dashboard", "Transferir", "Empréstimos", "Pagamentos", "Extrato" e "Sair"

  - nome: Navegação sem erros 404
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
      Scenario: Todos os links direcionam corretamente
        Given eu estou no Dashboard
        When clico em "Transferir"
        Then devo ser redirecionado para a página de Transferência
        And não deve aparecer erro 404

  - nome: Mensagens de erro em vermelho alinhadas ao campo
    tipo: positivo
    gherkin: |
      Feature: Mensagens de Erro
      Scenario: Exibição correta de mensagens de erro
        Given eu estou na página de cadastro
        When deixo o campo de e‑mail vazio
        And clico em "Criar Conta"
        Then a mensagem "Campo obrigatório" deve aparecer em vermelho abaixo do campo e‑mail

  - nome: Tempo de carregamento do Dashboard menor que 2 segundos
    tipo: positivo
    gherkin: |
      Feature: Performance
      Scenario: Tempo de resposta do Dashboard
        Given eu estou autenticado
        When acesso a página de Dashboard
        Then o tempo de carregamento deve ser inferior a 2 segundos

  - nome: Menu colapsa em dispositivos móveis
    tipo: positivo
    gherkin: |
      Feature: Responsividade
      Scenario: Menu responsivo em mobile
        Given eu acesso o site em um dispositivo com largura 320px
        Then o menu deve colapsar em um ícone “hamburger”
        And ao clicar no ícone, todas as opções devem aparecer

  - nome: Página retorna 404 ao acessar link inexistente
    tipo: negativo
    gherkin: |
      Feature: Navegação Consistente
      Scenario: Acesso a URL inválida
        Given eu clico em um link que leva a "/pagina-inexistente"
        Then devo ver uma página de erro 404
```

