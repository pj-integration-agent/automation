**User Story: Cadastro de Usuário (US01)**  
titulo: Cadastro de Usuário,  
cenario_bdd:  
    - nome: Cadastro bem‑sucedido com dados válidos  
      tipo: positivo  
      gherkin: |  
        Feature: Cadastro de Usuário  
        Scenario: Usuário cadastra conta com todos os campos corretos  
          Given o usuário está na página de cadastro  
          When ele preenche nome completo, CPF, data de nascimento, endereço, CEP, telefone, e‑mail e senha com valores válidos  
          And clica no botão “Cadastrar”  
          Then a conta é criada  
          And o usuário recebe mensagem de confirmação na tela  
          And o usuário pode fazer login com as credenciais cadastradas  

    - nome: Cadastro bloqueado quando campo obrigatório em branco  
      tipo: negativo  
      gherkin: |  
        Feature: Cadastro de Usuário  
        Scenario: Cadastro bloqueado por campo obrigatório em branco  
          Given o usuário está na página de cadastro  
          When ele deixa o campo “CPF” em branco e preenche os demais campos com valores válidos  
          And clica no botão “Cadastrar”  
          Then a submissão é bloqueada  
          And aparece mensagem “CPF é obrigatório” ao lado do campo  

    - nome: Cadastro bloqueado com telefone inválido  
      tipo: negativo  
      gherkin: |  
        Feature: Cadastro de Usuário  
        Scenario: Cadastro bloqueado por telefone inválido  
          Given o usuário está na página de cadastro  
          When ele insere “12345” no campo telefone e preenche os demais campos corretamente  
          Then mensagem “Telefone inválido – insira 10 dígitos” aparece em tempo real  
          And o botão “Cadastrar” permanece desabilitado  

    - nome: Cadastro bloqueado com e‑mail já registrado  
      tipo: negativo  
      gherkin: |  
        Feature: Cadastro de Usuário  
        Scenario: Cadastro bloqueado por e‑mail já existente  
          Given existe um usuário cadastrado com e‑mail “exemplo@dominio.com”  
          When o usuário tenta cadastrar outro com o mesmo e‑mail  
          And preenche todos os outros campos corretamente  
          And clica em “Cadastrar”  
          Then aparece mensagem “E‑mail já cadastrado”  
          And a conta não é criada  

---

**User Story: Login bem‑sucedido (US02)**  
titulo: Login bem‑sucedido,  
cenario_bdd:  
    - nome: Login com credenciais válidas redireciona para dashboard  
      tipo: positivo  
      gherkin: |  
        Feature: Login  
        Scenario: Usuário entra com credenciais válidas  
          Given o usuário tem credenciais válidas  
          When ele navega até a página de login  
          And preenche e‑mail e senha corretos  
          And clica em “Entrar”  
          Then é redirecionado automaticamente para a página inicial  
          And o saldo exibido corresponde ao valor atual da conta  

    - nome: Histórico de transações carregado após login  
      tipo: positivo  
      gherkin: |  
        Feature: Dashboard  
        Scenario: Histórico de transações exibido na dashboard  
          Given o usuário está na página inicial após login  
          Then o histórico de transações é carregado na mesma página  
          And cada transação mostra data, descrição e valor  

---

**User Story: Login inválido (US03)**  
titulo: Login inválido,  
cenario_bdd:  
    - nome: Mensagem de erro para e‑mail ou senha inválidos  
      tipo: negativo  
      gherkin: |  
        Feature: Login  
        Scenario: Usuário tenta login com credenciais inválidas  
          Given o usuário tem credenciais inválidas (e‑mail ou senha)  
          When ele tenta entrar no sistema  
          Then aparece mensagem “E‑mail ou senha inválidos.”  
          And permanece na página de login  
          And o link “Esqueci minha senha” permanece visível  

---

**User Story: Exibição de Saldo Atualizado (US04)**  
titulo: Exibição de Saldo Atualizado,  
cenario_bdd:  
    - nome: Saldo aparece em moeda local na dashboard  
      tipo: positivo  
      gherkin: |  
        Feature: Dashboard  
        Scenario: Saldo exibido em moeda local  
          Given o usuário está na página inicial  
          Then o saldo aparece no formato “R$ 1.234,56”  

    - nome: Saldo reflete último valor confirmado quando sem transações recentes  
      tipo: positivo  
      gherkin: |  
        Feature: Dashboard  
        Scenario: Saldo mantém último valor quando não há transações recentes  
          Given o usuário não realizou nenhuma operação recentemente  
          When ele acessa a dashboard  
          Then o saldo exibido é o último valor confirmado  

---

**User Story: Exibição de Extrato em Ordem Cronológica (US05)**  
titulo: Exibição de Extrato em Ordem Cronológica,  
cenario_bdd:  
    - nome: Extrato mostra transações em ordem decrescente  
      tipo: positivo  
      gherkin: |  
        Feature: Extrato  
        Scenario: Transações aparecem em ordem decrescente  
          Given o usuário acessa a página de extrato  
          Then a lista de transações está ordenada de mais recente para mais antiga  
          And cada linha mostra data, tipo, descrição curta e saldo final  

    - nome: Mensagem exibida quando não há transações recentes  
      tipo: negativo  
      gherkin: |  
        Feature: Extrato  
        Scenario: Usuário sem transações recentes  
          Given o usuário não possui transações na conta  
          When ele acessa a página de extrato  
          Then aparece mensagem “Nenhuma transação encontrada”  

---

**User Story: Transferência de Fundos (Sucesso) (US06)**  
titulo: Transferência de Fundos (Sucesso),  
cenario_bdd:  
    - nome: Transferência de valor dentro do saldo disponível  
      tipo: positivo  
      gherkin: |  
        Feature: Transferência de Fundos  
        Scenario: Usuário transfere valor dentro do saldo disponível  
          Given o usuário possui saldo de R$ 5.000,00 na conta origem  
          When ele navega até a tela de transferência  
          And preenche conta destino, valor R$ 1.000,00 e data de transferência “agora”  
          And confirma a operação  
          Then a origem é debitada e a destino creditada  
          And aparece mensagem “Transferência concluída com sucesso – R$ 1.000,00”  

    - nome: Saldo atual reflete transferência no extrato  
      tipo: positivo  
      gherkin: |  
        Feature: Transferência de Fundos  
        Scenario: Saldo e extrato atualizados após transferência  
          Given a transferência anterior foi concluída  
          When o usuário acessa a dashboard  
          Then o saldo reflete o débito de R$ 1.000,00  
          And a transferência aparece no extrato de ambas as contas  

---

**User Story: Transferência de Fundos (Valor Excede Saldo) (US07)**  
titulo: Transferência de Fundos (Valor Excede Saldo),  
cenario_bdd:  
    - nome: Mensagem de saldo insuficiente ao tentar transferir valor superior ao saldo  
      tipo: negativo  
      gherkin: |  
        Feature: Transferência de Fundos  
        Scenario: Usuário tenta transferir mais que o saldo disponível  
          Given o saldo disponível na conta origem é R$ 500,00  
          When ele tenta transferir R$ 1.000,00  
          Then aparece mensagem “Saldo insuficiente – saldo atual R$ 500,00”  
          And o botão “Confirmar” permanece desabilitado  

    - nome: Campo de valor bloqueia entrada de valores negativos ou zero  
      tipo: negativo  
      gherkin: |  
        Feature: Transferência de Fundos  
        Scenario: Campo valor bloqueia valores não positivos  
          When o usuário tenta inserir “0” ou “-100” no campo valor  
          Then aparece mensagem “Valor deve ser maior que zero”  
          And a operação não pode ser confirmada  

---

**User Story: Solicitação de Empréstimo (US08)**  
titulo: Solicitação de Empréstimo,  
cenario_bdd:  
    - nome: Empréstimo aprovado com valores válidos  
      tipo: positivo  
      gherkin: |  
        Feature: Empréstimo  
        Scenario: Usuário solicita empréstimo com valor e renda válidos  
          Given o usuário tem renda anual de R$ 120.000,00  
          When ele solicita empréstimo de R$ 10.000,00  
          Then o sistema avalia e exibe “Aprovado” com justificativa “Renda adequada”  
          And o histórico de empréstimos mostra data, valor e status “Aprovado”  

    - nome: Empréstimo negado por renda insuficiente  
      tipo: negativo  
      gherkin: |  
        Feature: Empréstimo  
        Scenario: Usuário tem renda insuficiente para o empréstimo solicitado  
          Given o usuário tem renda anual de R$ 20.000,00  
          When ele solicita empréstimo de R$ 30.000,00  
          Then exibe “Negado” com mensagem “Renda insuficiente”  
          And o histórico mostra status “Negado”  

    - nome: Erro de validação quando valor ou renda são zero ou negativos  
      tipo: negativo  
      gherkin: |  
        Feature: Empréstimo  
        Scenario: Valor ou renda inválidos na solicitação de empréstimo  
          When o usuário insere valor “0” ou renda “-50000”  
          Then aparece mensagem “Valor e renda devem ser maiores que zero”  
          And a solicitação não é enviada  

---

**User Story: Pagamento de Contas (Registro) (US09)**  
titulo: Pagamento de Contas (Registro),  
cenario_bdd:  
    - nome: Registro de pagamento com todos os campos obrigatórios preenchidos  
      tipo: positivo  
      gherkin: |  
        Feature: Pagamento de Contas  
        Scenario: Usuário registra pagamento com dados completos  
          Given o usuário está na tela de pagamento  
          When preenche beneficiário, endereço, cidade, estado, CEP, telefone, conta destino, valor R$ 200,00 e data “agora”  
          And confirma  
          Then pagamento aparece no histórico com status “Concluído”  

    - nome: Erro quando campo obrigatório fica em branco  
      tipo: negativo  
      gherkin: |  
        Feature: Pagamento de Contas  
        Scenario: Falha ao tentar registrar pagamento com campo obrigatório em branco  
          Given o usuário deixa o campo “CEP” em branco  
          When tenta salvar  
          Then aparece mensagem “CEP é obrigatório”  
          And o pagamento não é registrado  

    - nome: Valor inválido (zero ou negativo) bloqueia gravação  
      tipo: negativo  
      gherkin: |  
        Feature: Pagamento de Contas  
        Scenario: Usuário tenta registrar pagamento com valor zero  
          When insere valor “0” no campo valor  
          Then aparece mensagem “Valor deve ser maior que zero”  
          And o pagamento não é registrado  

---

**User Story: Pagamento de Contas (Agendamento Futuro) (US10)**  
titulo: Pagamento de Contas (Agendamento Futuro),  
cenario_bdd:  
    - nome: Agendamento de pagamento em data futura válida  
      tipo: positivo  
      gherkin: |  
        Feature: Pagamento de Contas  
        Scenario: Usuário agenda pagamento para data futura  
          Given o usuário escolhe data “02/12/2025”  
          When confirma o agendamento  
          Then aparece mensagem “Pagamento agendado para 02/12/2025”  
          And pagamento aparece no histórico com status “Agendado”  

    - nome: Data inválida (menor que hoje) bloqueia agendamento  
      tipo: negativo  
      gherkin: |  
        Feature: Pagamento de Contas  
        Scenario: Usuário tenta agendar pagamento para data passada  
          Given a data escolhida é “01/11/2024” (antes da data atual)  
          When tenta salvar  
          Then aparece mensagem “Data inválida – selecione uma data futura”  
          And o pagamento não é agendado  

---

**User Story: Navegação Consistente (US11)**  
titulo: Navegação Consistente,  
cenario_bdd:  
    - nome: Todos os links de navegação levam às páginas corretas  
      tipo: positivo  
      gherkin: |  
        Feature: Navegação  
        Scenario: Verifica links de navegação em todas as páginas  
          Given o usuário está na página inicial  
          When clica em “Minha Conta”  
          Then a página correta é aberta  
          When clica em “Transferências”  
          Then a página de transferências é aberta  
          And assim sucessivamente para “Pagamentos”, “Empréstimos”, “Extrato”, “Sair”  
          And nenhuma página retorna erro 404  

    - nome: Menu ativo destaca a página atual  
      tipo: positivo  
      gherkin: |  
        Feature: Navegação  
        Scenario: Destaque do menu ativo  
          Given o usuário está na página “Extrato”  
          Then o link “Extrato” no menu está destacado  

    - nome: Link “Sair” encerra sessão corretamente  
      tipo: positivo  
      gherkin: |  
        Feature: Navegação  
        Scenario: Usuário clica em “Sair”  
          When ele confirma logout  
          Then a sessão é encerrada e redireciona para página de login  

---

**User Story: Mensagens de Erro Claras (US12)**  
titulo: Mensagens de Erro Claras,  
cenario_bdd:  
    - nome: Erro de validação aparece ao lado do campo em vermelho  
      tipo: positivo  
      gherkin: |  
        Feature: Mensagens de Erro  
        Scenario: Campo obrigatório vazio durante cadastro  
          When deixa campo “Nome completo” em branco e tenta salvar  
          Then aparece mensagem “Nome completo é obrigatório” em vermelho ao lado do campo  

    - nome: Mensagem geral de erro inesperado não aparece sem causa  
      tipo: negativo  
      gherkin: |  
        Feature: Mensagens de Erro  
        Scenario: Sistema não apresenta mensagem de erro inesperado  
          When não há falha no backend  
          Then nenhuma mensagem “Erro inesperado – tente novamente mais tarde” aparece  

    - nome: Mensagens de sucesso desaparecem após 5 segundos  
      tipo: positivo  
      gherkin: |  
        Feature: Mensagens de Sucesso  
        Scenario: Mensagem de confirmação de operação  
          When operação concluída com sucesso  
          Then aparece banner verde com mensagem “Transferência concluída”  
          And desaparece automaticamente após 5 segundos  

---

**User Story: Carregamento sem Erros de Navegação (US13)**  
titulo: Carregamento sem Erros de Navegação,  
cenario_bdd:  
    - nome: Todas as páginas carregam em menos de 2 segundos em conexão padrão  
      tipo: positivo  
      gherkin: |  
        Feature: Performance  
        Scenario: Tempo de carregamento de página  
          When usuário acessa qualquer página  
          Then o tempo de carregamento não excede 2 segundos  

    - nome: Exibição de mensagem em caso de falha de servidor  
      tipo: negativo  
      gherkin: |  
        Feature: Falha de Servidor  
        Scenario: Erro 500 ao carregar página  
          When o servidor retorna erro 500  
          Then aparece mensagem “Falha no servidor – recarregue a página”  

---

**User Story: Validação de Campos no Cadastro (US14)**  
titulo: Validação de Campos no Cadastro,  
cenario_bdd:  
    - nome: Telefone aceita apenas 10 ou 11 dígitos numéricos  
      tipo: positivo  
      gherkin: |  
        Feature: Validação de Telefone  
        Scenario: Telefone válido com 11 dígitos  
          When usuário insere “11987654321” no campo telefone  
          Then campo aceita o valor e nenhuma mensagem de erro aparece  

    - nome: Telefone inválido bloqueia entrada  
      tipo: negativo  
      gherkin: |  
        Feature: Validação de Telefone  
        Scenario: Telefone com caracteres não numéricos  
          When usuário insere “(11)98765-4321”  
          Then aparece mensagem “Telefone inválido – insira 10 dígitos”  

    - nome: CEP aceita apenas 8 dígitos numéricos  
      tipo: positivo  
      gherkin: |  
        Feature: Validação de CEP  
        Scenario: CEP válido  
          When usuário insere “12345678” no campo CEP  
          Then campo aceita e nenhuma mensagem de erro aparece  

    - nome: E‑mail segue padrão RFC  
      tipo: negativo  
      gherkin: |  
        Feature: Validação de E‑mail  
        Scenario: E‑mail inválido  
          When usuário insere “exemplo@”  
          Then aparece mensagem “Formato inválido”  
          And campo permanece em vermelho  

---

**User Story: Mensagens de Confirmação de Operações (US15)**  
titulo: Mensagens de Confirmação de Operações,  
cenario_bdd:  
    - nome: Mensagem de confirmação de transferência exibida em verde  
      tipo: positivo  
      gherkin: |  
        Feature: Confirmação de Transferência  
        Scenario: Usuário confirma transferência  
          When operação de transferência é concluída  
          Then aparece banner verde com mensagem “Transferência concluída – R$ 500,00 – Saldo atual R$ 4.500,00”  
          And banner desaparece após 5 segundos, salvo se usuário clicar em “Detalhes”  

    - nome: Botão “Detalhes” abre tela completa da transação  
      tipo: positivo  
      gherkin: |  
        Feature: Detalhes da Transação  
        Scenario: Usuário visualiza detalhes após transferência  
          When clica em “Detalhes” no banner de confirmação  
          Then abre tela com data, beneficiário, valor, saldo final e status  

    - nome: Mensagem de confirmação não aparece para operação não concluída  
      tipo: negativo  
      gherkin: |  
        Feature: Confirmação de Operação  
        Scenario: Operação falha  
          When transferência é abortada por saldo insuficiente  
          Then nenhuma mensagem de confirmação aparece  
          And mensagem de erro “Saldo insuficiente” é exibida  

---