**US01 – Cadastro de Usuário**  
```yaml
titulo: US01 – Cadastro de Usuário
cenario_bdd:
  - nome: Cadastro bem‑sucedido com todos os campos válidos
    tipo: positivo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário cria conta com dados válidos
        Given O usuário acessa a página de cadastro
        When O usuário preenche "Nome" com "Ana", "Sobrenome" com "Silva",
          e "E‑mail" com "ana.silva@example.com",
          "Senha" com "P@ssw0rd123", "Telefone" com "(11) 98765-4321",
          "CEP" com "01001-000", "Endereço" com "Rua A",
          "Cidade" com "São Paulo", "Estado" com "SP"
        And O usuário clica em "Registrar"
        Then O sistema cria a conta e exibe "Conta criada com sucesso"
        And Envia e‑mail de confirmação para "ana.silva@example.com"
        And Redireciona para a tela de login

  - nome: Cadastro falha por campos obrigatórios vazios
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário tenta registrar sem preencher campos obrigatórios
        Given O usuário acessa a página de cadastro
        When O usuário preenche apenas "E‑mail" com "novo@email.com" e clica em "Registrar"
        Then O sistema exibe mensagens de erro ao lado de "Nome", "Sobrenome",
          "Senha", "Telefone", "CEP", "Endereço", "Cidade", "Estado"

  - nome: Cadastro falha por telefone inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário registra telefone com letras
        Given O usuário acessa a página de cadastro
        When O usuário preenche "Telefone" com "abcde12345"
          e preenche os demais campos corretamente
        And O usuário clica em "Registrar"
        Then O sistema exibe a mensagem de erro "Formato de telefone inválido" ao lado do campo

  - nome: Cadastro falha por CEP inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário registra CEP com menos de 8 dígitos
        Given O usuário acessa a página de cadastro
        When O usuário preenche "CEP" com "1234-567"
          e preenche os demais campos corretamente
        And O usuário clica em "Registrar"
        Then O sistema exibe a mensagem de erro "CEP inválido" ao lado do campo

  - nome: Cadastro falha por e‑mail inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário registra e‑mail sem “@”
        Given O usuário acessa a página de cadastro
        When O usuário preenche "E‑mail" com "emailsemarroba.com"
          e preenche os demais campos corretamente
        And O usuário clica em "Registrar"
        Then O sistema exibe a mensagem de erro "E‑mail inválido" ao lado do campo

  - nome: Cadastro falha por e‑mail já existente
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário tenta registrar com e‑mail já cadastrado
        Given O usuário acessa a página de cadastro
        When O usuário preenche "E‑mail" com "exemplo@exemplo.com"
          e preenche os demais campos corretamente
        And O usuário clica em "Registrar"
        Then O sistema exibe a mensagem "E‑mail já cadastrado" junto ao campo de e‑mail
```

---

**US02 – Login**  
```yaml
titulo: US02 – Login
cenario_bdd:
  - nome: Login bem‑sucedido com credenciais válidas
    tipo: positivo
    gherkin: |
      Feature: Login do Usuário
      Scenario: Usuário faz login com credenciais corretas
        Given O usuário está na página de login
        When O usuário digita "E‑mail" com "cliente@bank.com" e "Senha" com "Segura123!"
        And Clica em "Entrar"
        Then O sistema autentica o usuário
        And Redireciona para a página inicial da conta exibindo saldo e menu

  - nome: Login falha por credenciais inválidas
    tipo: negativo
    gherkin: |
      Feature: Login do Usuário
      Scenario: Usuário tenta login com senha incorreta
        Given O usuário está na página de login
        When O usuário digita "E‑mail" com "cliente@bank.com" e "Senha" com "Errada!"
        And Clica em "Entrar"
        Then O sistema exibe a mensagem "Credenciais inválidas. Tente novamente."

  - nome: Bloqueio após 3 tentativas consecutivas de login
    tipo: negativo
    gherkin: |
      Feature: Login do Usuário
      Scenario: Usuário é bloqueado após 3 falhas seguidas
        Given O usuário está na página de login
        When O usuário digita "E‑mail" com "cliente@bank.com" e "Senha" com "Errada!"
        And Clica em "Entrar"
        And Repete o passo acima por mais duas vezes
        Then O sistema exibe a mensagem "Conta bloqueada por 30 minutos devido a múltiplas tentativas"

  - nome: Login falha por campos vazios
    tipo: negativo
    gherkin: |
      Feature: Login do Usuário
      Scenario: Usuário tenta login sem preencher e‑mail
        Given O usuário está na página de login
        When O usuário deixa "E‑mail" em branco e digita "Senha" com "Segura123!"
        And Clica em "Entrar"
        Then O sistema exibe a mensagem de erro "E‑mail é obrigatório" ao lado do campo
```

---

**US03 – Visualização de Saldo**  
```yaml
titulo: US03 – Visualização de Saldo
cenario_bdd:
  - nome: Exibição do saldo atual formatado corretamente
    tipo: positivo
    gherkin: |
      Feature: Visualização de Saldo
      Scenario: Usuário visualiza saldo após operação
        Given O usuário está na página inicial da conta
        When O usuário realizou uma operação (ex.: depósito de R$ 1.500,00)
        Then O saldo exibido é "R$ 1.500,00"
        And O valor contém separador de milhares e duas casas decimais

  - nome: Exibição do saldo zero quando não há fundos
    tipo: positivo
    gherkin: |
      Feature: Visualização de Saldo
      Scenario: Usuário tem saldo zero
        Given O usuário está na página inicial da conta
        And O usuário não possui transações
        Then O saldo exibido é "R$ 0,00"
        And O texto exibe “Saldo disponível: R$ 0,00”
```

---

**US04 – Visualização de Extrato**  
```yaml
titulo: US04 – Visualização de Extrato
cenario_bdd:
  - nome: Exibição das últimas 10 transações
    tipo: positivo
    gherkin: |
      Feature: Visualização de Extrato
      Scenario: Usuário visualiza extrato com mais de 10 transações
        Given O usuário está na página de extrato
        When O usuário possui 15 transações na conta
        Then O sistema exibe apenas as 10 transações mais recentes
        And Cada linha mostra "Data", "Descrição", "Tipo", "Valor" e "Saldo pós‑transação"

  - nome: Exportação de extrato para PDF
    tipo: positivo
    gherkin: |
      Feature: Visualização de Extrato
      Scenario: Usuário exporta extrato em PDF
        Given O usuário está na página de extrato
        When O usuário clica em "Exportar PDF"
        Then O sistema gera e inicia download de arquivo PDF contendo o extrato

  - nome: Filtro de extrato por data e tipo com resultado vazio
    tipo: negativo
    gherkin: |
      Feature: Visualização de Extrato
      Scenario: Usuário filtra extrato com data inexistente
        Given O usuário está na página de extrato
        When O usuário seleciona data "01/01/2020" e tipo "Crédito"
        And Clica em "Filtrar"
        Then O sistema exibe a mensagem "Nenhuma transação encontrada para o filtro selecionado"
```

---

**US05 – Transferência de Fundos**  
```yaml
titulo: US05 – Transferência de Fundos
cenario_bdd:
  - nome: Transferência bem‑sucedida com saldo suficiente
    tipo: positivo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Usuário transfere R$ 200,00 para conta B
        Given O usuário está na página de transferência
        And Possui saldo R$ 500,00 na conta de origem
        When O usuário seleciona conta de origem "A"
        And Seleciona conta de destino "B"
        And Digita valor "200,00" e confirma a transferência
        Then O sistema debita R$ 200,00 da conta A
        And Crédito R$ 200,00 na conta B
        And Exibe mensagem "Transferência concluída com sucesso"
        And Exibe data/hora da transação

  - nome: Transferência falha por saldo insuficiente
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Usuário tenta transferir mais do que o saldo disponível
        Given O usuário está na página de transferência
        And Possui saldo R$ 100,00 na conta de origem
        When O usuário tenta transferir R$ 200,00
        Then O sistema exibe a mensagem "Saldo insuficiente – impossível completar a transferência."

  - nome: Transferência falha por valor não numérico ou zero
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Usuário tenta transferir valor inválido
        Given O usuário está na página de transferência
        When O usuário digita valor "zero" ou "-50" no campo de valor
        And Clica em "Transferir"
        Then O sistema exibe a mensagem "Valor inválido. Digite um número positivo."

  - nome: Transferência falha por conta de destino inexistente
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Usuário tenta transferir para conta não cadastrada
        Given O usuário está na página de transferência
        When O usuário seleciona conta de destino "ZZZ"
        And Clica em "Transferir"
        Then O sistema exibe a mensagem "Conta de destino não encontrada."
```

---

**US06 – Solicitação de Empréstimo**  
```yaml
titulo: US06 – Solicitação de Empréstimo
cenario_bdd:
  - nome: Empréstimo aprovado com renda suficiente
    tipo: positivo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Usuário solicita empréstimo aprovado
        Given O usuário está na página de solicitação de empréstimo
        When O usuário preenche "Valor" com "12.000,00"
          e "Renda anual" com "100.000,00"
        And Clica em "Solicitar"
        Then O sistema avalia a solicitação e exibe "Aprovado"
        And Exibe taxa de juros, prazo e valor mensal calculado

  - nome: Empréstimo negado por renda insuficiente
    tipo: negativo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Usuário solicita empréstimo negado
        Given O usuário está na página de solicitação de empréstimo
        When O usuário preenche "Valor" com "12.000,00"
          e "Renda anual" com "20.000,00"
        And Clica em "Solicitar"
        Then O sistema avalia a solicitação e exibe "Negado"
        And Sugere aumentar a renda ou reduzir o valor solicitado

  - nome: Solicitação falha por campos obrigatórios vazios
    tipo: negativo
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Usuário deixa campo de renda em branco
        Given O usuário está na página de solicitação de empréstimo
        When O usuário preenche "Valor" com "12.000,00"
          e deixa "Renda anual" em branco
        And Clica em "Solicitar"
        Then O sistema exibe mensagem de erro "Renda anual é obrigatória" ao lado do campo
```

---

**US07 – Pagamento de Contas**  
```yaml
titulo: US07 – Pagamento de Contas
cenario_bdd:
  - nome: Pagamento agendado com dados válidos
    tipo: positivo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Usuário agenda pagamento futuro
        Given O usuário está na página de agendamento de pagamento
        When O usuário preenche "Beneficiário" com "Conta de Luz"
          "Endereço" com "Av. Central, 1000"
          "Cidade" com "São Paulo"
          "Estado" com "SP"
          "CEP" com "01001-000"
          "Telefone" com "(11) 99999-9999"
          "Conta de destino" com "123456"
          "Valor" com "150,00"
          "Data de vencimento" com data 10 dias à frente
        And Clica em "Agendar"
        Then O pagamento aparece no histórico com status "Agendado"
        And O usuário recebe notificação na data de vencimento

  - nome: Falha ao agendar pagamento com CEP inválido
    tipo: negativo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Usuário tenta agendar pagamento com CEP inválido
        Given O usuário está na página de agendamento de pagamento
        When O usuário preenche "CEP" com "ABC123"
        And Clica em "Agendar"
        Then O sistema exibe a mensagem de erro "CEP inválido" ao lado do campo

  - nome: Falha ao agendar pagamento com data no passado
    tipo: negativo
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Usuário tenta agendar pagamento com data passada
        Given O usuário está na página de agendamento de pagamento
        When O usuário define "Data de vencimento" como data 5 dias atrás
        And Clica em "Agendar"
        Then O sistema exibe a mensagem de erro "Data de vencimento não pode ser no passado."
```

---

**US08 – Navegação e Usabilidade**  
```yaml
titulo: US08 – Navegação e Usabilidade
cenario_bdd:
  - nome: Carregamento rápido das páginas principais
    tipo: positivo
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Carregamento de página em ≤ 2 segundos
        Given O usuário acessa a página de login
        When O navegador solicita a rota "/login"
        Then O sistema carrega a página em 1.8 segundos

  - nome: Exibição de mensagem de erro em falha de carregamento
    tipo: negativo
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Página falha ao carregar
        Given O usuário tenta acessar a rota "/extrato" com servidor offline
        When O navegador recebe erro 504
        Then O sistema exibe a mensagem "Ocorreu um problema. Por favor, recarregue a página."

  - nome: Consistência visual nos menus entre desktop e mobile
    tipo: positivo
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario Outline: Verificar consistência de menu
        Given O usuário acessa a aplicação em <dispositivo>
        When O usuário navega pelos menus
        Then Todos os links, ícones e labels são visíveis e responsivos
      Examples:
        | dispositivo |
        | desktop     |
        | mobile      |
```

---