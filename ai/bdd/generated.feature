**US01 – Cadastro de Usuário**  
```
titulo: US01 – Cadastro de Usuário,
cenario_bdd:
    nome: Cadastro bem‑sucedido com dados válidos,
    tipo: positivo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro de usuário com sucesso\n  Given o usuário abre a página de cadastro\n  When preenche todos os campos obrigatórios com dados válidos e envia o formulário\n  Then o usuário recebe um e‑mail de confirmação\n  And o usuário é redirecionado para a tela de login"

cenario_bdd:
    nome: Erro ao submeter formulário com e‑mail inválido,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro falha por e‑mail inválido\n  Given o usuário abre a página de cadastro\n  When preenche o campo e‑mail com \"usuario@@dominio\" e preenche os demais campos corretamente\n  And submete o formulário\n  Then é exibida a mensagem de erro \"E‑mail inválido\" logo abaixo do campo e‑mail"

cenario_bdd:
    nome: Erro ao submeter formulário com CPF duplicado,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro falha por CPF já cadastrado\n  Given um usuário já está cadastrado com CPF \"123.456.789-00\"\n  And o usuário abre a página de cadastro\n  When preenche todos os campos obrigatórios com CPF duplicado \"123.456.789-00\" e envia o formulário\n  Then é exibida a mensagem de erro \"CPF já cadastrado\" logo abaixo do campo CPF"

cenario_bdd:
    nome: Erro ao submeter formulário com senha curta,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro falha por senha menor que 8 caracteres\n  Given o usuário abre a página de cadastro\n  When preenche todos os campos obrigatórios com senha \"abc123\" e envia o formulário\n  Then é exibida a mensagem de erro \"Senha deve ter pelo menos 8 caracteres\" logo abaixo do campo Senha"

cenario_bdd:
    nome: Campos obrigatórios marcados corretamente,
    tipo: positivo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Campos obrigatórios exibem asterisco\n  Given o usuário abre a página de cadastro\n  Then todos os campos obrigatórios exibem um asterisco (*) ao lado"

```

**US02 – Login**  
```
titulo: US02 – Login,
cenario_bdd:
    nome: Login bem‑sucedido com credenciais válidas,
    tipo: positivo,
    gherkin: "Feature: Login\nScenario: Usuário entra com credenciais corretas\n  Given o usuário está na tela de login\n  When o usuário insere e‑mail \"cliente@bank.com\" e senha \"Segura123\"\n  And clica em \"Entrar\"\n  Then o usuário é redirecionado para a página de Conta"

cenario_bdd:
    nome: Mensagem de erro ao submeter credenciais inválidas,
    tipo: negativo,
    gherkin: "Feature: Login\nScenario: Login falha por credenciais inválidas\n  Given o usuário está na tela de login\n  When o usuário insere e‑mail \"cliente@bank.com\" e senha \"Errada\"\n  And clica em \"Entrar\"\n  Then é exibida a mensagem \"Credenciais inválidas\" no topo da página"

cenario_bdd:
    nome: Bloqueio de conta após cinco tentativas falhadas,
    tipo: negativo,
    gherkin: "Feature: Login\nScenario: Conta bloqueada após cinco tentativas consecutivas\n  Given o usuário está na tela de login\n  When o usuário tenta entrar cinco vezes consecutivas com credenciais inválidas\n  And clica em \"Entrar\" na quinta tentativa\n  Then é exibida a mensagem \"Conta bloqueada, contate o suporte\""

cenario_bdd:
    nome: Botão \"Entrar\" desabilitado durante requisição,
    tipo: positivo,
    gherkin: "Feature: Login\nScenario: Botão desabilitado durante requisição\n  Given o usuário está na tela de login\n  When o usuário insere credenciais válidas e clica em \"Entrar\"\n  Then o botão \"Entrar\" fica desabilitado até que a resposta seja recebida\n  And o botão volta a ficar habilitado após a resposta"

```

**US03 – Exibir Saldo e Extrato**  
```
titulo: US03 – Exibir Saldo e Extrato,
cenario_bdd:
    nome: Exibição do saldo e das 10 transações mais recentes,
    tipo: positivo,
    gherkin: "Feature: Saldo e Extrato\nScenario: Usuário vê saldo e extrato atualizados\n  Given o usuário está na página de Conta\n  Then o saldo atual é exibido em reais com duas casas decimais\n  And a lista mostra as 10 transações mais recentes em ordem decrescente de data"

cenario_bdd:
    nome: Mensagem quando não há transações,
    tipo: negativo,
    gherkin: "Feature: Saldo e Extrato\nScenario: Usuário sem transações\n  Given o usuário está na página de Conta e não possui transações\n  Then é exibida a mensagem \"Nenhuma transação encontrada\""

cenario_bdd:
    nome: Atualização do saldo após transferência,
    tipo: positivo,
    gherkin: "Feature: Saldo e Extrato\nScenario: Saldo atualizado após transferência\n  Given o usuário faz uma transferência de R$ 500,00\n  When a transferência é concluída\n  Then o saldo exibido na página de Conta reflete o novo valor"

```

**US04 – Transferência de Fundos**  
```
titulo: US04 – Transferência de Fundos,
cenario_bdd:
    nome: Transferência bem‑sucedida entre contas do usuário,
    tipo: positivo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência de R$ 200,00 entre contas do mesmo usuário\n  Given o usuário está na tela de Transferência\n  And a conta de origem tem saldo suficiente\n  When o usuário seleciona conta de origem, conta de destino e valor \"200,00\"\n  And confirma a transferência\n  Then a origem é debitada, a destino é creditada\n  And a mensagem de confirmação \"Transferência concluída. Valor transferido: R$ 200,00\" aparece"

cenario_bdd:
    nome: Erro ao transferir valor superior ao saldo da origem,
    tipo: negativo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência falha por saldo insuficiente\n  Given o usuário está na tela de Transferência\n  And a conta de origem tem saldo de R$ 150,00\n  When o usuário tenta transferir R$ 200,00\n  Then é exibida a mensagem \"Saldo insuficiente\""

cenario_bdd:
    nome: Erro ao transferir para conta inexistente,
    tipo: negativo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência falha por conta de destino inexistente\n  Given o usuário está na tela de Transferência\n  When o usuário tenta transferir para a conta de destino \"9999999999\"\n  Then é exibida a mensagem \"Conta de destino não encontrada\""

cenario_bdd:
    nome: Erro ao inserir valor negativo ou zero,
    tipo: negativo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência falha por valor inválido\n  Given o usuário está na tela de Transferência\n  When o usuário insere valor \"-50,00\" ou \"0,00\"\n  Then a mensagem de erro \"Valor inválido\" aparece ao lado do campo Valor"

```

**US05 – Solicitação de Empréstimo**  
```
titulo: US05 – Solicitação de Empréstimo,
cenario_bdd:
    nome: Empréstimo aprovado com renda suficiente,
    tipo: positivo,
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo aprovado com renda adequada\n  Given o usuário abre a tela de Empréstimo\n  When insere valor de empréstimo \"20.000,00\" e renda anual \"45.000,00\"\n  And solicita avaliação\n  Then a mensagem \"Aprovado com taxa de juros de 8% ao ano\" é exibida"

cenario_bdd:
    nome: Empréstimo negado por renda insuficiente,
    tipo: negativo,
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo negado por renda inadequada\n  Given o usuário abre a tela de Empréstimo\n  When insere valor de empréstimo \"30.000,00\" e renda anual \"30.000,00\"\n  And solicita avaliação\n  Then a mensagem \"Negado\" é exibida e sugere \"Revisar renda anual ou reduzir valor do empréstimo\""

cenario_bdd:
    nome: Erro ao submeter valor abaixo do mínimo ou acima do máximo,
    tipo: negativo,
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo fora dos limites permitidos\n  Given o usuário abre a tela de Empréstimo\n  When insere valor de empréstimo \"500,00\" (abaixo do mínimo) e renda anual \"50.000,00\"\n  And solicita avaliação\n  Then a mensagem de erro \"Valor mínimo de empréstimo: R$ 1.000\" aparece\n  When insere valor de empréstimo \"150.000,00\" (acima do máximo)\n  And solicita avaliação\n  Then a mensagem de erro \"Valor máximo de empréstimo: R$ 100.000\" aparece"

```

**US06 – Pagamento de Contas**  
```
titulo: US06 – Pagamento de Contas,
cenario_bdd:
    nome: Pagamento agendado com sucesso,
    tipo: positivo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento de R$ 120,00 agendado para futuro\n  Given o usuário abre a tela de Pagamento\n  And a conta de origem tem saldo suficiente\n  When preenche Beneficiário, Endereço, Cidade, Estado, CEP, Telefone, Conta de destino, Valor \"120,00\" e Data de vencimento \"30/12/2025\"\n  And confirma a criação\n  Then a mensagem \"Pagamento agendado para 30/12/2025\" aparece\n  And o pagamento aparece no extrato com status \"Agendado\""

cenario_bdd:
    nome: Erro ao agendar pagamento com data anterior à atual,
    tipo: negativo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento falha por data vencida\n  Given o usuário abre a tela de Pagamento\n  When preenche data de vencimento \"01/01/2023\" (data passada)\n  And confirma\n  Then a mensagem de erro \"Data de vencimento não pode ser anterior à data atual\" aparece"

cenario_bdd:
    nome: Erro ao agendar pagamento com valor superior ao saldo,
    tipo: negativo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento falha por saldo insuficiente\n  Given o usuário abre a tela de Pagamento\n  And a conta de origem tem saldo de R$ 80,00\n  When preenche Valor \"120,00\"\n  And confirma\n  Then a mensagem de erro \"Valor não pode superar o saldo da conta de origem\" aparece"

cenario_bdd:
    nome: Erro ao deixar campo obrigatório vazio,
    tipo: negativo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento falha por campo obrigatório ausente\n  Given o usuário abre a tela de Pagamento\n  When deixa em branco o campo Beneficiário\n  And tenta submeter o formulário\n  Then a mensagem de erro \"Campo obrigatório\" aparece logo abaixo de Beneficiário"

```

**US07 – Requisitos Gerais de Navegação e Usabilidade**  
```
titulo: US07 – Requisitos Gerais de Navegação e Usabilidade,
cenario_bdd:
    nome: Todas as páginas carregam em menos de 2 segundos em conexão 3G,
    tipo: positivo,
    gherkin: "Feature: Navegação\nScenario: Tempo de carregamento das páginas\n  Given o usuário navega para qualquer rota\n  Then a página carrega em no máximo 2 segundos em conexão 3G"

cenario_bdd:
    nome: Menus contêm links corretos em todas as páginas,
    tipo: positivo,
    gherkin: "Feature: Navegação\nScenario: Links de menu funcionam corretamente\n  Given o usuário está em qualquer página\n  When clica em cada link do menu (Home, Extrato, Transferências, Empréstimos, Pagamentos)\n  Then cada link redireciona para a página correspondente"

cenario_bdd:
    nome: Mensagens de erro exibidas em vermelho com ícone de alerta,
    tipo: positivo,
    gherkin: "Feature: Usabilidade\nScenario: Exibição de mensagem de erro\n  Given o usuário submete um campo inválido\n  Then a mensagem de erro aparece em vermelho com ícone de alerta\n  And a mensagem desaparece automaticamente após 5 segundos ou quando o usuário corrige o campo"

cenario_bdd:
    nome: Layout responsivo em dispositivos móveis,
    tipo: positivo,
    gherkin: "Feature: Responsividade\nScenario: Menu exibido em barra inferior em dispositivos móveis\n  Given o usuário abre o site em um dispositivo iOS/Android\n  Then o menu de navegação aparece na barra inferior conforme mockup"

```

---