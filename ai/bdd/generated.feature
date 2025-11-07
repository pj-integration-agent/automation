**US01 – Registro de conta**

```
titulo: US01 – Registro de conta
cenario_bdd:
    nome: Registro de conta com dados válidos
    tipo: positivo
    gherkin: "Feature: Registro de conta\nScenario: Registro de conta com dados válidos\nGiven o usuário abre a página de cadastro\nWhen preenche todos os campos obrigatórios com dados válidos e clica em \"Cadastrar\"\nThen o sistema exibe a mensagem \"Cadastro concluído com sucesso\" e redireciona para a tela de login"
```

```
titulo: US01 – Registro de conta
cenario_bdd:
    nome: Erro ao omitir campo obrigatório
    tipo: negativo
    gherkin: "Feature: Registro de conta\nScenario: Erro ao omitir campo obrigatório\nGiven o usuário abre a página de cadastro\nWhen preenche todos os campos obrigatórios exceto o CPF e clica em \"Cadastrar\"\nThen o sistema exibe a mensagem de erro \"CPF é obrigatório\""
```

```
titulo: US01 – Registro de conta
cenario_bdd:
    nome: Erro de formato de telefone
    tipo: negativo
    gherkin: "Feature: Registro de conta\nScenario: Erro de formato de telefone\nGiven o usuário abre a página de cadastro\nWhen preenche o telefone com texto alfabético e clica em \"Cadastrar\"\nThen o sistema exibe a mensagem de erro \"Telefone inválido, apenas números são permitidos\""
```

```
titulo: US01 – Registro de conta
cenario_bdd:
    nome: Registro com e‑mail já cadastrado
    tipo: negativo
    gherkin: "Feature: Registro de conta\nScenario: Registro com e‑mail já cadastrado\nGiven o usuário abre a página de cadastro\nWhen preenche todos os campos obrigatórios com um e‑mail que já existe e clica em \"Cadastrar\"\nThen o sistema exibe a mensagem de erro \"E‑mail já cadastrado\""
```

**US02 – Login**

```
titulo: US02 – Login
cenario_bdd:
    nome: Login bem-sucedido
    tipo: positivo
    gherkin: "Feature: Login\nScenario: Login bem-sucedido\nGiven o usuário abre a página de login\nWhen insere um e‑mail e senha válidos e clica em \"Entrar\"\nThen o sistema redireciona para a página inicial exibindo o nome do usuário"
```

```
titulo: US02 – Login
cenario_bdd:
    nome: Falha de login por e‑mail inexistente
    tipo: negativo
    gherkin: "Feature: Login\nScenario: Falha de login por e‑mail inexistente\nGiven o usuário abre a página de login\nWhen insere um e‑mail que não está registrado e senha válida e clica em \"Entrar\"\nThen o sistema exibe a mensagem \"E‑mail ou senha inválidos\""
```

```
titulo: US02 – Login
cenario_bdd:
    nome: Falha de login por senha incorreta
    tipo: negativo
    gherkin: "Feature: Login\nScenario: Falha de login por senha incorreta\nGiven o usuário abre a página de login\nWhen insere um e‑mail válido e senha incorreta e clica em \"Entrar\"\nThen o sistema exibe a mensagem \"E‑mail ou senha inválidos\""
```

```
titulo: US02 – Login
cenario_bdd:
    nome: Erro ao deixar campo de e‑mail vazio
    tipo: negativo
    gherkin: "Feature: Login\nScenario: Erro ao deixar campo de e‑mail vazio\nGiven o usuário abre a página de login\nWhen deixa o campo de e‑mail em branco, preenche a senha e clica em \"Entrar\"\nThen o sistema exibe a mensagem de erro \"E‑mail é obrigatório\""
```

**US03 – Exibir saldo**

```
titulo: US03 – Exibir saldo
cenario_bdd:
    nome: Exibir saldo formatado corretamente
    tipo: positivo
    gherkin: "Feature: Exibir saldo\nScenario: Exibir saldo formatado corretamente\nGiven o usuário está na página inicial\nThen o saldo é exibido em moeda local com duas casas decimais"
```

```
titulo: US03 – Exibir saldo
cenario_bdd:
    nome: Atualização automática do saldo após transferência
    tipo: positivo
    gherkin: "Feature: Exibir saldo\nScenario: Atualização automática do saldo após transferência\nGiven o usuário realizou uma transferência de R$ 500,00\nWhen a página inicial é recarregada\nThen o saldo exibido reflete a subtração de R$ 500,00"
```

```
titulo: US03 – Exibir saldo
cenario_bdd:
    nome: Falha no carregamento do saldo
    tipo: negativo
    gherkin: "Feature: Exibir saldo\nScenario: Falha no carregamento do saldo\nGiven o usuário abre a página inicial e o serviço de saldo está indisponível\nWhen o sistema tenta obter o saldo\nThen o usuário vê a mensagem \"Não foi possível carregar o saldo. Tente novamente.\""
```

**US04 – Extrato de transações**

```
titulo: US04 – Extrato de transações
cenario_bdd:
    nome: Exibir as 10 transações mais recentes
    tipo: positivo
    gherkin: "Feature: Extrato de transações\nScenario: Exibir as 10 transações mais recentes\nGiven o usuário abre a tela de extrato\nThen são listadas as 10 transações mais recentes em ordem decrescente"
```

```
titulo: US04 – Extrato de transações
cenario_bdd:
    nome: Carregar mais transações ao clicar em \"Mostrar mais\"
    tipo: positivo
    gherkin: "Feature: Extrato de transações\nScenario: Carregar mais transações ao clicar em \"Mostrar mais\"\nGiven o usuário já viu as 10 primeiras transações\nWhen clica no botão \"Mostrar mais\"\nThen são exibidas mais 10 transações"
```

```
titulo: US04 – Extrato de transações
cenario_bdd:
    nome: Nenhuma transação encontrada
    tipo: negativo
    gherkin: "Feature: Extrato de transações\nScenario: Nenhuma transação encontrada\nGiven o usuário abre a tela de extrato e não há transações\nThen o sistema exibe a mensagem \"Nenhuma transação encontrada.\""
```

**US05 – Transferência de fundos**

```
titulo: US05 – Transferência de fundos
cenario_bdd:
    nome: Transferência bem-sucedida entre contas
    tipo: positivo
    gherkin: "Feature: Transferência de fundos\nScenario: Transferência bem-sucedida entre contas\nGiven o usuário seleciona sua conta de origem, escolhe a conta destino e insere R$ 300,00\nWhen confirma a transferência\nThen a origem é debitada, o destino creditado e o usuário vê a mensagem \"Transferência concluída\" junto aos novos saldos"
```

```
titulo: US05 – Transferência de fundos
cenario_bdd:
    nome: Falha por saldo insuficiente
    tipo: negativo
    gherkin: "Feature: Transferência de fundos\nScenario: Falha por saldo insuficiente\nGiven o usuário tenta transferir R$ 10.000,00 mas o saldo disponível é R$ 5.000,00\nWhen confirma a transferência\nThen o sistema exibe a mensagem \"Saldo insuficiente\""
```

```
titulo: US05 – Transferência de fundos
cenario_bdd:
    nome: Erro ao inserir valor negativo ou zero
    tipo: negativo
    gherkin: "Feature: Transferência de fundos\nScenario: Erro ao inserir valor negativo ou zero\nGiven o usuário insere R$ -50,00 na caixa de valor\nWhen tenta confirmar a transferência\nThen o sistema exibe a mensagem de erro \"Valor inválido, deve ser positivo\""
```

**US06 – Solicitação de empréstimo**

```
titulo: US06 – Solicitação de empréstimo
cenario_bdd:
    nome: Empréstimo aprovado
    tipo: positivo
    gherkin: "Feature: Solicitação de empréstimo\nScenario: Empréstimo aprovado\nGiven o usuário insere R$ 50.000,00 como valor e R$ 200.000,00 como renda anual\nWhen solicita o empréstimo\nThen o sistema exibe um modal com a mensagem \"Seu empréstimo foi aprovado\""
```

```
titulo: US06 – Solicitação de empréstimo
cenario_bdd:
    nome: Empréstimo negado por valor máximo excedido
    tipo: negativo
    gherkin: "Feature: Solicitação de empréstimo\nScenario: Empréstimo negado por valor máximo excedido\nGiven o usuário tenta solicitar R$ 250.000,00\nWhen envia a solicitação\nThen o sistema exibe a mensagem \"Valor máximo de empréstimo é R$ 200.000,00\""
```

```
titulo: US06 – Solicitação de empréstimo
cenario_bdd:
    nome: Empréstimo negado por renda anual muito baixa
    tipo: negativo
    gherkin: "Feature: Solicitação de empréstimo\nScenario: Empréstimo negado por renda anual muito baixa\nGiven o usuário insere R$ 50.000,00 como valor e R$ 20.000,00 como renda anual\nWhen envia a solicitação\nThen o sistema exibe a mensagem \"Seu empréstimo foi negado\" e sugere revisão de renda"
```

```
titulo: US06 – Solicitação de empréstimo
cenario_bdd:
    nome: Erro ao inserir valor não numérico
    tipo: negativo
    gherkin: "Feature: Solicitação de empréstimo\nScenario: Erro ao inserir valor não numérico\nGiven o usuário digita \"abc\" no campo de valor\nWhen tenta enviar a solicitação\nThen o sistema exibe a mensagem de erro \"Valor inválido, apenas números são permitidos\""
```

**US07 – Pagamento de conta**

```
titulo: US07 – Pagamento de conta
cenario_bdd:
    nome: Agendamento de pagamento futuro
    tipo: positivo
    gherkin: "Feature: Pagamento de conta\nScenario: Agendamento de pagamento futuro\nGiven o usuário preenche todos os campos obrigatórios com uma data 10 dias no futuro\nWhen confirma o pagamento\nThen o sistema exibe a mensagem \"Pagamento agendado\" e adiciona a transação como \"Pendente\" no extrato"
```

```
titulo: US07 – Pagamento de conta
cenario_bdd:
    nome: Erro por data no passado
    tipo: negativo
    gherkin: "Feature: Pagamento de conta\nScenario: Erro por data no passado\nGiven o usuário preenche a data com ontem\nWhen tenta confirmar o pagamento\nThen o sistema exibe a mensagem \"Data inválida\""
```

```
titulo: US07 – Pagamento de conta
cenario_bdd:
    nome: Erro por valor negativo
    tipo: negativo
    gherkin: "Feature: Pagamento de conta\nScenario: Erro por valor negativo\nGiven o usuário digita R$ -100,00 no campo de valor\nWhen tenta enviar a solicitação\nThen o sistema exibe a mensagem de erro \"Valor inválido, deve ser positivo\""
```

```
titulo: US07 – Pagamento de conta
cenario_bdd:
    nome: Erro ao omitir campo obrigatório
    tipo: negativo
    gherkin: "Feature: Pagamento de conta\nScenario: Erro ao omitir campo obrigatório\nGiven o usuário deixa o campo beneficiário em branco e preenche os demais\nWhen tenta enviar a solicitação\nThen o sistema exibe a mensagem de erro \"Beneficiário é obrigatório\""
```

**US08 – Navegação e Consistência de página**

```
titulo: US08 – Navegação e Consistência
cenario_bdd:
    nome: Todas as páginas carregam sem erros
    tipo: positivo
    gherkin: "Feature: Navegação e Consistência\nScenario: Todas as páginas carregam sem erros\nGiven o usuário navega por todas as páginas do site\nWhen cada página carrega\nThen nenhuma página apresenta erro 404 nem mensagem de falha"
```

```
titulo: US08 – Navegação e Consistência
cenario_bdd:
    nome: Link inválido gera erro 404
    tipo: negativo
    gherkin: "Feature: Navegação e Consistência\nScenario: Link inválido gera erro 404\nGiven o usuário clica em um link que não existe\nWhen a página tenta carregar\nThen o sistema exibe a mensagem de erro 404"
```

```
titulo: US08 – Navegação e Consistência
cenario_bdd:
    nome: Mensagem de erro inesperado em banner vermelho
    tipo: negativo
    gherkin: "Feature: Navegação e Consistência\nScenario: Mensagem de erro inesperado em banner vermelho\nGiven ocorre uma exceção inesperada no servidor\nWhen o usuário tenta acessar a página inicial\nThen o banner vermelho com a mensagem \"Erro inesperado. Tente novamente\" aparece acima do conteúdo"
```