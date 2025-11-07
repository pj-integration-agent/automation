**User Story: US01 – Cadastro de Usuário**  
titulo: Cadastro de Usuário  
cenario_bdd:
    nome: Cadastro com todos os campos válidos  
    tipo: positivo  
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário preenche formulário com dados válidos e recebe confirmação
          Given o usuário está na página de cadastro
          When preenche "Nome completo" com "Ana Maria da Silva"
          And preenche "Data de nascimento" com "15/04/1990"
          And preenche "CPF" com "123.456.789-10"
          And preenche "Endereço" com "Rua das Flores, 123"
          And preenche "CEP" com "12345-678"
          And preenche "Telefone" com "(11) 91234-5678"
          And preenche "E‑mail" com "ana.silva@example.com"
          And preenche "Senha" com "Segura123!"
          And confirma "Senha" com "Segura123!"
          And clica no botão "Cadastrar"
          Then o botão "Cadastrar" deve estar ativo
          And a página de confirmação deve aparecer
          And o usuário deve estar autenticado e redirecionado para a tela “Minha Conta”

---

titulo: Cadastro bloqueado quando campo obrigatório em branco  
cenario_bdd:
    nome: Erro de campo obrigatório em branco  
    tipo: negativo  
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário deixa campo "CPF" em branco
          Given o usuário está na página de cadastro
          When preenche "Nome completo" com "Ana Maria da Silva"
          And preenche "Data de nascimento" com "15/04/1990"
          And deixa "CPF" em branco
          And preenche "Endereço" com "Rua das Flores, 123"
          And preenche "CEP" com "12345-678"
          And preenche "Telefone" com "(11) 91234-5678"
          And preenche "E‑mail" com "ana.silva@example.com"
          And preenche "Senha" com "Segura123!"
          And confirma "Senha" com "Segura123!"
          Then o botão "Cadastrar" deve permanecer inativo
          And exibe mensagem de erro abaixo do campo "CPF" com texto "CPF é obrigatório"

---

titulo: Cadastro bloqueado com telefone inválido  
cenario_bdd:
    nome: Erro de validação de telefone  
    tipo: negativo  
    gherkin: |
      Feature: Cadastro de Usuário
      Scenario: Usuário entra telefone com letras
          Given o usuário está na página de cadastro
          When preenche "Telefone" com "telefone123"
          And clica no botão "Cadastrar"
          Then exibe mensagem de erro abaixo do campo "Telefone" com texto "Telefone inválido – use números"

---

**User Story: US02 – Login**  
titulo: Login com credenciais válidas  
cenario_bdd:
    nome: Usuário loga com e‑mail e senha corretos  
    tipo: positivo  
    gherkin: |
      Feature: Login
      Scenario: Usuário autenticado com credenciais válidas
          Given o usuário está na página de login
          When preenche "E‑mail" com "ana.silva@example.com"
          And preenche "Senha" com "Segura123!"
          And clica no botão "Entrar"
          Then o usuário deve ser redirecionado para a página “Minha Conta”
          And a sessão deve permanecer ativa até logout ou timeout

---

titulo: Login falha com senha incorreta  
cenario_bdd:
    nome: Usuário tenta login com senha errada  
    tipo: negativo  
    gherkin: |
      Feature: Login
      Scenario: Usuário entra com senha incorreta
          Given o usuário está na página de login
          When preenche "E‑mail" com "ana.silva@example.com"
          And preenche "Senha" com "Errada123!"
          And clica no botão "Entrar"
          Then exibe mensagem de erro "Usuário ou senha inválidos"

---

titulo: Login falha com e‑mail não registrado  
cenario_bdd:
    nome: Usuário tenta login com e‑mail não cadastrado  
    tipo: negativo  
    gherkin: |
      Feature: Login
      Scenario: Usuário entra com e‑mail que não existe no sistema
          Given o usuário está na página de login
          When preenche "E‑mail" com "nao.cadastrado@example.com"
          And preenche "Senha" com "Qualquer123!"
          And clica no botão "Entrar"
          Then exibe mensagem de erro "Usuário ou senha inválidos"

---

**User Story: US03 – Visualizar Saldo e Extrato**  
titulo: Visualização de saldo e extrato com 10 transações  
cenario_bdd:
    nome: Usuário vê saldo atualizado e extrato completo  
    tipo: positivo  
    gherkin: |
      Feature: Visualizar Saldo e Extrato
      Scenario: Usuário autenticado visualiza saldo e extrato
          Given o usuário está autenticado e na página “Minha Conta”
          When abre a seção “Extrato”
          Then exibe saldo corrente em moeda local
          And lista as 10 transações mais recentes
          And cada linha tem data, descrição e valor com saldo pós‑transação

---

titulo: Extrato exibe todas as transações quando há menos de 10  
cenario_bdd:
    nome: Usuário com menos de 10 transações  
    tipo: positivo  
    gherkin: |
      Feature: Visualizar Saldo e Extrato
      Scenario: Usuário com menos de 10 transações
          Given o usuário tem 7 transações na conta
          And está autenticado em “Minha Conta”
          When abre a seção “Extrato”
          Then lista todas as 7 transações
          And não exibe linhas vazias

---

**User Story: US04 – Transferência de Fundos**  
titulo: Transferência dentro do limite de saldo  
cenario_bdd:
    nome: Usuário transfere valor dentro do saldo disponível  
    tipo: positivo  
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Transferência de R$ 200,00 para conta externa
          Given o usuário está autenticado na página “Transferências”
          And o saldo disponível é R$ 500,00
          When seleciona conta de origem "Conta Corrente"
          And insere conta de destino "12345-6"
          And preenche "Valor" com "200,00"
          And confirma a transferência
          Then exibe mensagem "Transferência concluída"
          And o saldo da conta de origem é R$ 300,00
          And a conta de destino tem saldo aumentado em R$ 200,00
          And a transação aparece no extrato de origem como "–200,00"
          And a transação aparece no extrato de destino como "+200,00"

---

titulo: Transferência bloqueada por saldo insuficiente  
cenario_bdd:
    nome: Usuário tenta transferir mais que o saldo disponível  
    tipo: negativo  
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Transferência excede saldo
          Given o usuário está autenticado na página “Transferências”
          And o saldo disponível é R$ 150,00
          When insere conta de destino "12345-6"
          And preenche "Valor" com "200,00"
          Then exibe mensagem de erro "Valor excede saldo disponível"

---

titulo: Transferência bloqueada por valor inválido  
cenario_bdd:
    nome: Usuário entra valor negativo  
    tipo: negativo  
    gherkin: |
      Feature: Transferência de Fundos
      Scenario: Valor da transferência é negativo
          Given o usuário está na página “Transferências”
          When preenche "Valor" com "-100,00"
          Then exibe mensagem de erro "Valor inválido – apenas números positivos"

---

**User Story: US05 – Solicitação de Empréstimo**  
titulo: Empréstimo aprovado com renda suficiente  
cenario_bdd:
    nome: Solicitação de empréstimo que é aprovada  
    tipo: positivo  
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Usuário solicita R$ 5.000,00 com renda anual de R$ 80.000,00
          Given o usuário está autenticado na página “Empréstimos”
          When preenche "Valor do empréstimo" com "5.000,00"
          And preenche "Renda anual" com "80.000,00"
          And confirma a solicitação
          Then espera 2 segundos
          And exibe status "Aprovado"
          And o valor de R$ 5.000,00 é creditado imediatamente na conta
          And aparece no extrato com descrição "Empréstimo aprovado"

---

titulo: Empréstimo negado por renda insuficiente  
cenario_bdd:
    nome: Solicitação de empréstimo que é negada  
    tipo: negativo  
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Usuário solicita R$ 10.000,00 com renda anual de R$ 30.000,00
          Given o usuário está autenticado na página “Empréstimos”
          When preenche "Valor do empréstimo" com "10.000,00"
          And preenche "Renda anual" com "30.000,00"
          And confirma a solicitação
          Then espera 2 segundos
          And exibe status "Empréstimo negado – renda insuficiente"

---

titulo: Empréstimo falha com valor negativo  
cenario_bdd:
    nome: Usuário entra valor do empréstimo negativo  
    tipo: negativo  
    gherkin: |
      Feature: Solicitação de Empréstimo
      Scenario: Valor do empréstimo é negativo
          Given o usuário está na página “Empréstimos”
          When preenche "Valor do empréstimo" com "-1.000,00"
          Then exibe mensagem de erro "Valor do empréstimo inválido – apenas números positivos"

---

**User Story: US06 – Pagamento de Contas**  
titulo: Pagamento imediato para beneficiário  
cenario_bdd:
    nome: Usuário registra pagamento para hoje  
    tipo: positivo  
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Pagamento imediato
          Given o usuário está autenticado na página “Pagamentos”
          And o saldo disponível é R$ 1.000,00
          When preenche "Beneficiário" com "João Pereira"
          And preenche "Endereço" com "Av. Brasil, 456"
          And preenche "Cidade" com "São Paulo"
          And preenche "Estado" com "SP"
          And preenche "CEP" com "01000-000"
          And preenche "Telefone" com "(11) 98765-4321"
          And preenche "Conta de destino" com "12345-6"
          And preenche "Valor" com "300,00"
          And escolhe data de pagamento "Hoje"
          And confirma o pagamento
          Then exibe mensagem "Pagamento registrado"
          And a transação aparece no extrato como "Pagamento para João Pereira – 300,00"

---

titulo: Pagamento agendado para data futura  
cenario_bdd:
    nome: Usuário agenda pagamento para 10 dias depois  
    tipo: positivo  
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Pagamento agendado
          Given o usuário está autenticado na página “Pagamentos”
          When preenche "Beneficiário" com "Maria Souza"
          And preenche "Conta de destino" com "98765-4"
          And preenche "Valor" com "150,00"
          And escolhe data de pagamento "10 dias depois"
          And confirma o pagamento
          Then exibe mensagem "Pagamento registrado"
          And o extrato mostra data marcada "10 dias depois" com valor "150,00"

---

titulo: Pagamento bloqueado por saldo insuficiente na data programada  
cenario_bdd:
    nome: Usuário agenda pagamento que ultrapassa saldo no dia agendado  
    tipo: negativo  
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: Saldo insuficiente no dia do pagamento
          Given o usuário tem saldo de R$ 200,00
          And agenda pagamento de R$ 300,00 para "12 dias depois"
          Then exibe mensagem de erro "Saldo insuficiente no dia do pagamento"

---

titulo: Pagamento bloqueado por CEP inválido  
cenario_bdd:
    nome: Usuário entra CEP com menos dígitos  
    tipo: negativo  
    gherkin: |
      Feature: Pagamento de Contas
      Scenario: CEP inválido
          Given o usuário está na página “Pagamentos”
          When preenche "CEP" com "1234"
          And tenta enviar o pagamento
          Then exibe mensagem de erro "CEP inválido – use 8 dígitos"

---

**User Story: US07 – Navegação e Usabilidade**  
titulo: Navegação entre todas as páginas sem erro  
cenario_bdd:
    nome: Usuário navega por todas as rotas sem receber erro 404/500  
    tipo: positivo  
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Navegação completa
          Given o usuário está no login
          When clica em "Cadastrar"
          Then a página de cadastro carrega com status 200
          When clica em "Entrar" (login)
          Then a página “Minha Conta” carrega com status 200
          When clica no menu "Transferências"
          Then a página de transferências carrega com status 200
          When clica no menu "Empréstimos"
          Then a página de empréstimos carrega com status 200
          When clica no menu "Pagamentos"
          Then a página de pagamentos carrega com status 200

---

titulo: Tela 404 mostra link de retorno ao dashboard ou login  
cenario_bdd:
    nome: Usuário acessa rota inexistente  
    tipo: negativo  
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Página 404
          When o usuário digita na barra de endereço "/rota-inexistente"
          Then o servidor responde com status 404
          And exibe mensagem "Página não encontrada"
          And mostra link "Voltar ao dashboard" se autenticado ou "Voltar ao login" se não autenticado

---

titulo: Mensagens de erro de validação aparecem corretamente  
cenario_bdd:
    nome: Erro de validação aparece abaixo do campo e em vermelho  
    tipo: positivo  
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Erro de validação
          Given o usuário está na página de cadastro
          When deixa "Telefone" em branco
          And tenta cadastrar
          Then a mensagem "Telefone é obrigatório" aparece abaixo do campo "Telefone" em texto vermelho
          And o botão "Cadastrar" permanece inativo

---

titulo: Menus responsivos em telas pequenas  
cenario_bdd:
    nome: Menu se adapta em tela de 320px  
    tipo: positivo  
    gherkin: |
      Feature: Navegação e Usabilidade
      Scenario: Responsividade do menu
          Given a aplicação está aberta em um dispositivo com largura 320px
          When o usuário abre o menu principal
          Then todos os links do menu são exibidos em vertical
          And cada link tem ícone e texto legível
          And o menu fecha ao clicar fora ou no ícone de fechar

---