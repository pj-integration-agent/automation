**US01 – Registro de Usuário**  
titulo: US01 – Registro de Usuário  
cenario_bdd:  
  - nome: Registro bem‑sucedido  
    tipo: positivo  
    gherkin: "Feature: Registro de Usuário\nScenario: Cadastro com dados válidos\n  Given o usuário está na tela de registro\n  When ele preenche o formulário com nome completo, CPF, data de nascimento, endereço, telefone \"(12) 34567-8901\", CEP \"12345-678\", e‑mail \"exemplo@dominio.com\" e senha \"Senha123!\"\n  And clica no botão “Registrar\"\n  Then o sistema exibe a mensagem “Cadastro concluído com sucesso!”\n  And o usuário pode acessar a tela de login"

  - nome: Cadastro falha por campos obrigatórios vazios  
    tipo: negativo  
    gherkin: "Feature: Registro de Usuário\nScenario: Cadastro falha por campo obrigatório vazio\n  Given o usuário está na tela de registro\n  When ele preenche o formulário deixando o campo CPF vazio\n  And clica no botão “Registrar\"\n  Then o sistema exibe a mensagem “CPF é obrigatório”"

  - nome: Cadastro falha por formatos inválidos de telefone, CEP e e‑mail  
    tipo: negativo  
    gherkin: "Feature: Registro de Usuário\nScenario: Cadastro falha por formatos inválidos\n  Given o usuário está na tela de registro\n  When ele preenche o formulário com telefone \"1234567890\", CEP \"12345678\", e‑mail \"exemplo\"\n  And clica no botão “Registrar\"\n  Then o sistema exibe as mensagens “Formato de telefone inválido”, “Formato de CEP inválido”, “Formato de e‑mail inválido”"

---

**US02 – Login**  
titulo: US02 – Login  
cenario_bdd:  
  - nome: Login bem‑sucedido com credenciais corretas  
    tipo: positivo  
    gherkin: "Feature: Login\nScenario: Usuário loga com credenciais válidas\n  Given o usuário tem uma conta ativa com e‑mail \"user@dominio.com\" e senha \"Senha123!\"\n  When o usuário vai para a tela de login\n  And preenche e‑mail \"user@dominio.com\" e senha \"Senha123!\"\n  And clica em “Entrar\"\n  Then o usuário é redirecionado para a página inicial da conta\n  And a mensagem “Bem‑vindo” é exibida"

  - nome: Login falha com credenciais inválidas  
    tipo: negativo  
    gherkin: "Feature: Login\nScenario: Usuário tenta logar com senha incorreta\n  Given o usuário tenta logar\n  When preenche e‑mail \"user@dominio.com\" e senha \"SenhaErrada\"\n  And clica em “Entrar\"\n  Then o sistema exibe a mensagem “Credenciais inválidas. Por favor, tente novamente.”"

  - nome: Acesso à página inicial sem login  
    tipo: negativo  
    gherkin: "Feature: Login\nScenario: Usuário tenta acessar a página inicial sem estar autenticado\n  Given o usuário não está autenticado\n  When ele tenta acessar a página inicial\n  Then o sistema redireciona para a tela de login"

---

**US03 – Visualização do Saldo**  
titulo: US03 – Visualização do Saldo  
cenario_bdd:  
  - nome: Saldo exibido corretamente na tela inicial  
    tipo: positivo  
    gherkin: "Feature: Visualização do Saldo\nScenario: Saldo exibido na página inicial\n  Given o usuário está autenticado\n  And o saldo real da conta é R$ 1.234,56\n  When o usuário acessa a página inicial\n  Then o saldo exibido é “R$ 1.234,56”"

  - nome: Saldo atualizado após transferência  
    tipo: positivo  
    gherkin: "Feature: Visualização do Saldo\nScenario: Saldo atualizado após operação financeira\n  Given o usuário tem saldo R$ 1.000,00\n  When ele faz uma transferência de R$ 100,00\n  Then o saldo exibido é R$ 900,00"

---

**US04 – Extrato de Transações**  
titulo: US04 – Extrato de Transações  
cenario_bdd:  
  - nome: Extrato lista as 10 transações mais recentes  
    tipo: positivo  
    gherkin: "Feature: Extrato de Transações\nScenario: Exibição das 10 transações mais recentes\n  Given o usuário tem 15 transações no banco\n  When ele acessa o extrato\n  Then o sistema exibe as 10 transações mais recentes"

  - nome: Transações ordenadas cronologicamente (mais recente ao mais antigo)  
    tipo: positivo  
    gherkin: "Feature: Extrato de Transações\nScenario: Ordenação cronológica das transações\n  Given transações em datas distintas\n  When o usuário visualiza o extrato\n  Then as transações são listadas do mais recente para o mais antigo"

  - nome: Filtragem por período  
    tipo: positivo  
    gherkin: "Feature: Extrato de Transações\nScenario: Filtragem de extrato por período\n  Given o usuário deseja ver transações de 01/01/2024 a 31/01/2024\n  When ele aplica o filtro de período\n  Then o extrato exibe apenas transações dentro do intervalo"

---

**US05 – Transferência de Fundos**  
titulo: US05 – Transferência de Fundos  
cenario_bdd:  
  - nome: Transferência bem‑sucedida com saldo suficiente  
    tipo: positivo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência de R$ 200,00 para conta 987654321\n  Given o usuário tem saldo R$ 1.000,00\n  And a conta de destino tem número 987654321\n  When ele faz transferência de R$ 200,00 para conta 987654321\n  Then a conta origem é debitada R$ 200,00\n  And a conta destino é creditada R$ 200,00\n  And o histórico de ambas as contas mostra a transação\n  And o sistema exibe “Transferência concluída com sucesso”"

  - nome: Transferência bloqueada por saldo insuficiente  
    tipo: negativo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência com saldo insuficiente\n  Given o usuário tem saldo R$ 100,00\n  When tenta transferir R$ 200,00\n  Then o sistema exibe “Saldo insuficiente”"

  - nome: Transferência falha para conta de destino inexistente  
    tipo: negativo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência para conta inexistente\n  Given a conta destino 000000000 não existe\n  When tenta transferir R$ 100,00\n  Then exibe “Conta de destino inválida”"

---

**US06 – Solicitação de Empréstimo**  
titulo: US06 – Solicitação de Empréstimo  
cenario_bdd:  
  - nome: Empréstimo aprovado  
    tipo: positivo  
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo aprovado\n  Given o usuário tem renda anual R$ 80.000,00\n  When solicita empréstimo de R$ 10.000,00\n  Then exibe “Empréstimo Aprovado”"

  - nome: Empréstimo negado por renda insuficiente  
    tipo: negativo  
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo negado por renda insuficiente\n  Given renda anual R$ 20.000,00\n  When solicita R$ 15.000,00\n  Then exibe “Empréstimo Negado” e razão “Renda insuficiente”"

  - nome: Solicitação falha por campo vazio  
    tipo: negativo  
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Solicitação falha ao deixar valor em branco\n  Given usuário abre o formulário\n  When deixa o campo de valor em branco\n  Then exibe “Valor do empréstimo é obrigatório”"

---

**US07 – Pagamento de Contas**  
titulo: US07 – Pagamento de Contas  
cenario_bdd:  
  - nome: Pagamento agendado com sucesso  
    tipo: positivo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento agendado corretamente\n  Given usuário preenche beneficiário, endereço, cidade, estado, CEP \"12345-678\", telefone \"(12) 34567-8901\", conta de destino \"111222333\", valor R$ 300,00, data 15/12/2024\n  When confirma pagamento\n  Then transação aparece no histórico com data 15/12/2024"

  - nome: Pagamento falha por valor negativo  
    tipo: negativo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento falha por valor negativo\n  Given valor \"-100,00\"\n  When confirma pagamento\n  Then exibe “O valor não pode ser negativo”"

  - nome: Pagamento falha por data inválida  
    tipo: negativo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento falha por data inválida\n  Given data \"31/02/2024\"\n  When confirma pagamento\n  Then exibe “Data inválida”"

  - nome: Cancelar pagamento agendado antes da data de vencimento  
    tipo: positivo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Cancelamento de pagamento agendado\n  Given pagamento agendado em 15/12/2024\n  When cancela antes de 15/12/2024\n  Then pagamento é removido do histórico"

---

**US08 – Navegação e Usabilidade Consistentes**  
titulo: US08 – Navegação e Usabilidade Consistentes  
cenario_bdd:  
  - nome: Todas as páginas carregam dentro de 3 segundos  
    tipo: positivo  
    gherkin: "Feature: Navegação e Usabilidade\nScenario: Tempo de carregamento das páginas\n  Given o usuário acessa qualquer página\n  When a página carrega\n  Then o tempo de carregamento é inferior ou igual a 3 segundos"

  - nome: Menu de navegação visível em todas as telas autenticadas  
    tipo: positivo  
    gherkin: "Feature: Navegação e Usabilidade\nScenario: Menu de navegação consistente\n  Given o usuário autenticado\n  When ele navega em qualquer tela\n  Then o menu com itens “Conta”, “Transferência”, “Empréstimo”, “Pagamentos”, “Extrato” está visível"

  - nome: Clique em link leva à página correta  
    tipo: positivo  
    gherkin: "Feature: Navegação e Usabilidade\nScenario: Navegação por link\n  Given usuário clica em “Transferência”\n  Then o usuário é levado à página de transferências"

  - nome: Mensagem de erro ao falhar ao carregar página  
    tipo: negativo  
    gherkin: "Feature: Navegação e Usabilidade\nScenario: Erro de carregamento de página\n  Given ocorre erro 404\n  Then exibe “Erro ao carregar a página” com sugestão “Tente novamente”"

  - nome: Responsividade em desktop e mobile  
    tipo: positivo  
    gherkin: "Feature: Navegação e Usabilidade\nScenario: Navegação em dispositivos móveis\n  Given usuário abre o aplicativo em mobile\n  When navega por todas as telas\n  Then a navegação funciona corretamente e os elementos são exibidos corretamente"