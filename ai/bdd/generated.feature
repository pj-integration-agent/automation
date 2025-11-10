**US01 – Como cliente recém‑registrado, quero me cadastrar no sistema para ter uma conta bancária virtual.**  
titulo: US01 – Como cliente recém‑registrado, quero me cadastrar no sistema para ter uma conta bancária virtual.  
cenario_bdd:  
- nome: Cadastro com todos os campos obrigatórios preenchidos  
  tipo: positivo  
  gherkin: |  
    Feature: Cadastro de usuário  
    Scenario: Cadastro completo com dados válidos  
      Given o usuário está na página de cadastro  
      When ele preenche os campos nome completo, CPF, endereço, telefone, CEP, email e senha com dados válidos  
      And clica no botão “Cadastrar”  
      Then o sistema cria a conta  
      And exibe a mensagem “Cadastro concluído com sucesso”  
      And o usuário tem acesso à tela de login  
- nome: Cadastro falha quando campo obrigatório está em branco  
  tipo: negativo  
  gherkin: |  
    Feature: Cadastro de usuário  
    Scenario: Falha de cadastro com campo obrigatório em branco  
      Given o usuário está na página de cadastro  
      When ele deixa o campo CEP em branco e clica em “Cadastrar”  
      Then o sistema exibe “CEP é obrigatório” abaixo do campo CEP  
      And o formulário não é submetido  

**US02 – Como cliente, quero receber mensagens de erro quando informar dados inválidos (telefone, CEP, email) no cadastro.**  
titulo: US02 – Como cliente, quero receber mensagens de erro quando informar dados inválidos (telefone, CEP, email) no cadastro.  
cenario_bdd:  
- nome: Erro de email inválido  
  tipo: negativo  
  gherkin: |  
    Feature: Validação de dados no cadastro  
    Scenario: Email sem “@”  
      Given o usuário está na página de cadastro  
      When ele digita “usuarioemail.com” no campo email e tenta enviar o formulário  
      Then o sistema exibe “Email inválido” abaixo do campo email  
      And o formulário não é enviado  
- nome: Erro de CEP com letras  
  tipo: negativo  
  gherkin: |  
    Feature: Validação de dados no cadastro  
    Scenario: CEP com caracteres não numéricos  
      Given o usuário está na página de cadastro  
      When ele digita “12a34-567” no campo CEP e tenta enviar  
      Then o sistema exibe “CEP inválido” abaixo do campo CEP  
      And o formulário não é enviado  
- nome: Erro de telefone sem formato  
  tipo: negativo  
  gherkin: |  
    Feature: Validação de dados no cadastro  
    Scenario: Telefone sem formatação correta  
      Given o usuário está na página de cadastro  
      When ele digita “1234567890” no campo telefone e tenta enviar  
      Then o sistema exibe “Telefone inválido” abaixo do campo telefone  
      And o formulário não é enviado  

**US03 – Como cliente recém‑registrado, quero receber um e‑mail de confirmação para saber que o cadastro foi concluído com sucesso.**  
titulo: US03 – Como cliente recém‑registrado, quero receber um e‑mail de confirmação para saber que o cadastro foi concluído com sucesso.  
cenario_bdd:  
- nome: E‑mail de confirmação enviado após cadastro bem‑sucesso  
  tipo: positivo  
  gherkin: |  
    Feature: E‑mail de confirmação  
    Scenario: Envio de e‑mail de confirmação  
      Given o usuário cadastrou com sucesso no sistema  
      When ele verifica a caixa de entrada  
      Then o e‑mail contém o endereço de login e a mensagem “Seu cadastro no ParaBank foi concluído com sucesso!”  
      And o e‑mail chega no endereço informado em até 5 minutos  

**US04 – Como cliente registrado, quero fazer login com credenciais válidas para acessar minha conta bancária.**  
titulo: US04 – Como cliente registrado, quero fazer login com credenciais válidas para acessar minha conta bancária.  
cenario_bdd:  
- nome: Login com CPF e senha válidos  
  tipo: positivo  
  gherkin: |  
    Feature: Login de usuário  
    Scenario: Acesso à conta com credenciais válidas  
      Given o usuário já tem conta cadastrada no sistema  
      When ele entra CPF “12345678901” e senha “senha123” na tela de login  
      And clica em “Entrar”  
      Then o sistema redireciona para a página inicial da conta  
      And a sessão permanece aberta até que o usuário feche o navegador  

**US05 – Como cliente, quero receber uma mensagem de erro quando digitar credenciais inválidas.**  
titulo: US05 – Como cliente, quero receber uma mensagem de erro quando digitar credenciais inválidas.  
cenario_bdd:  
- nome: Mensagem de erro ao usar CPF ou senha incorretos  
  tipo: negativo  
  gherkin: |  
    Feature: Login de usuário  
    Scenario: Falha de login com credenciais inválidas  
      Given o usuário está na tela de login  
      When ele entra CPF “123” e senha “senhaerrada” e tenta acessar  
      Then o sistema exibe “CPF ou senha inválidos” em destaque  
      And os campos permanecem preenchidos para nova tentativa  

**US06 – Como cliente, quero visualizar o saldo atual da minha conta.**  
titulo: US06 – Como cliente, quero visualizar o saldo atual da minha conta.  
cenario_bdd:  
- nome: Saldo exibido corretamente após transações  
  tipo: positivo  
  gherkin: |  
    Feature: Visualização de saldo  
    Scenario: Saldo atualizado em tempo real  
      Given o usuário está na página da conta  
      When ele realizou uma transferência de R$200 para outra conta  
      Then o saldo exibido reflete a transferência (diminui na origem e aumenta no destino)  
      And o saldo atual é atualizado automaticamente em tempo real (ou pelo menos a cada 10 segundos)  

**US07 – Como cliente, quero ver meu extrato de transações recentes em ordem cronológica.**  
titulo: US07 – Como cliente, quero ver meu extrato de transações recentes em ordem cronológica.  
cenario_bdd:  
- nome: Exibição das últimas 10 transações em ordem decrescente  
  tipo: positivo  
  gherkin: |  
    Feature: Exibição do extrato  
    Scenario: Listar as 10 transações mais recentes  
      Given o usuário tem pelo menos 10 transações registradas  
      When ele abre a aba “Extrato”  
      Then o extrato lista exatamente 10 transações  
      And as transações aparecem do mais recente ao mais antigo  
      And cada linha contém data, descrição, tipo, valor e saldo após a transação  

**US08 – Como cliente, quero transferir fundos entre minhas contas.**  
titulo: US08 – Como cliente, quero transferir fundos entre minhas contas.  
cenario_bdd:  
- nome: Transferência dentro do saldo disponível  
  tipo: positivo  
  gherkin: |  
    Feature: Transferência de fundos  
    Scenario: Transferência válida dentro do saldo  
      Given o usuário tem saldo R$500 na conta de origem  
      When ele transfere R$200 para a conta destino  
      Then o saldo da origem fica R$300  
      And o saldo da destinação aumenta R$200  
      And ambos os registros aparecem no histórico (saída na origem, entrada na destinação)  
- nome: Transferência que excede o saldo disponível  
  tipo: negativo  
  gherkin: |  
    Feature: Transferência de fundos  
    Scenario: Transferência inválida por saldo insuficiente  
      Given o usuário tem saldo R$150 na conta de origem  
      When ele tenta transferir R$200 para outra conta  
      Then o sistema exibe a mensagem “Saldo insuficiente”  
      And a transação não é registrada  
      And os saldos permanecem inalterados  

**US09 – Como cliente, quero solicitar um empréstimo informando valor e renda anual.**  
titulo: US09 – Como cliente, quero solicitar um empréstimo informando valor e renda anual.  
cenario_bdd:  
- nome: Empréstimo aprovado quando critérios atendidos  
  tipo: positivo  
  gherkin: |  
    Feature: Empréstimo  
    Scenario: Aprovação de empréstimo com renda e valor adequados  
      Given o usuário informa renda anual R$60.000 e valor solicitado R$200.000 (menor que 5× renda)  
      When ele submete a solicitação  
      Then o sistema exibe “Aprovado” com a data de liberação e o valor concedido  
- nome: Empréstimo negado quando valor excede limite  
  tipo: negativo  
  gherkin: |  
    Feature: Empréstimo  
    Scenario: Negação de empréstimo por valor superior a 5× renda  
      Given o usuário informa renda anual R$50.000 e valor solicitado R$260.000 (maior que 5× renda)  
      When ele submete a solicitação  
      Then o sistema exibe “Negado” com mensagem explicativa sobre o motivo  

**US10 – Como cliente, quero registrar um pagamento de conta.**  
titulo: US10 – Como cliente, quero registrar um pagamento de conta.  
cenario_bdd:  
- nome: Pagamento agendado para data futura  
  tipo: positivo  
  gherkin: |  
    Feature: Pagamento de conta  
    Scenario: Agendamento de pagamento com data futura  
      Given o usuário preenche beneficiário, endereço, telefone, conta destino, valor 250 e data “30/12/2025”  
      When confirma o pagamento  
      Then a transação aparece no histórico com status “Agendado”  
      And o saldo da conta não diminui imediatamente  
- nome: Rejeição de data de pagamento no passado  
  tipo: negativo  
  gherkin: |  
    Feature: Pagamento de conta  
    Scenario: Data de pagamento passada é rejeitada  
      Given o usuário preenche data “01/01/2020” (no passado)  
      When tenta confirmar o pagamento  
      Then o sistema exibe “Data inválida”  
      And a transação não é agendada  

**US11 – Como usuário, quero navegar pela aplicação sem erros e com mensagens de erro claras.**  
titulo: US11 – Como usuário, quero navegar pela aplicação sem erros e com mensagens de erro claras.  
cenario_bdd:  
- nome: Carregamento de páginas em ≤ 2s em conexão de 3 Mbps  
  tipo: positivo  
  gherkin: |  
    Feature: Navegação e desempenho  
    Scenario: Tempo de carregamento aceitável em todas as páginas  
      Given o usuário navega entre cadastro, login, conta, extrato, transferências, empréstimos e pagamentos  
      When cada página é carregada em conexão de 3 Mbps  
      Then todas as páginas carregam em menos de 2 segundos  
- nome: Menus e links consistentes sem páginas 404  
  tipo: positivo  
  gherkin: |  
    Feature: Navegação e consistência  
    Scenario: Navegação consistente sem links quebrados  
      Given o usuário abre a página de login  
      When clica em “Extrato” no menu principal  
      Then é redirecionado corretamente para a página de extrato  
      And todos os links no menu levam às rotas corretas  
      And não há páginas 404 exibidas  
- nome: Mensagens de erro claras e destacadas  
  tipo: positivo  
  gherkin: |  
    Feature: Mensagens de erro  
    Scenario: Exibição de mensagens de erro em caso de falhas de rede  
      Given o usuário tenta carregar a página de transferências, mas a conexão falha  
      When a página tenta recarregar  
      Then o sistema exibe “Erro de conexão. Por favor, tente novamente.” em destaque próximo ao erro  

---