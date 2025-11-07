**US01 – Cadastro de Usuário**  
```
titulo: US01 – Cadastro de Usuário
cenario_bdd:
    nome: Registro bem‑sucedido com dados válidos
    tipo: positivo
    gherkin: "Feature: Cadastro de Usuário\nScenario: Registro bem-sucedido com dados válidos\n  Given o usuário acessa a página de cadastro\n  When ele preenche todos os campos obrigatórios com dados válidos\n  And clica no botão “Registrar”\n  Then o sistema exibe a mensagem “Cadastro concluído com sucesso”\n  And o usuário recebe um e‑mail de confirmação\n  And a conta fica habilitada para login"
```

```
titulo: US01 – Cadastro de Usuário
cenario_bdd:
    nome: Falha de cadastro quando e‑mail ausente
    tipo: negativo
    gherkin: "Feature: Cadastro de Usuário\nScenario: Falha de cadastro quando e‑mail ausente\n  Given o usuário acessa a página de cadastro\n  When ele preenche todos os campos obrigatórios exceto o e‑mail\n  And clica no botão “Registrar”\n  Then o sistema exibe a mensagem “E‑mail é obrigatório”"
```

```
titulo: US01 – Cadastro de Usuário
cenario_bdd:
    nome: Falha de cadastro com CPF inválido
    tipo: negativo
    gherkin: "Feature: Cadastro de Usuário\nScenario: Falha de cadastro com CPF inválido\n  Given o usuário acessa a página de cadastro\n  When ele preenche todos os campos obrigatórios com CPF no formato 12345678901\n  And clica no botão “Registrar”\n  Then o sistema exibe a mensagem “CPF inválido”"
```

**US02 – Login**  
```
titulo: US02 – Login
cenario_bdd:
    nome: Login bem‑sucedido com e‑mail válido
    tipo: positivo
    gherkin: "Feature: Login\nScenario: Login bem-sucedido com e‑mail válido\n  Given o usuário está na tela de login\n  When ele digita seu e‑mail registrado e a senha correta\n  And clica no botão “Entrar”\n  Then o usuário é redirecionado para “Minha Conta\"\n  And a sessão é iniciada"
```

```
titulo: US02 – Login
cenario_bdd:
    nome: Falha de login com senha incorreta
    tipo: negativo
    gherkin: "Feature: Login\nScenario: Falha de login com senha incorreta\n  Given o usuário está na tela de login\n  When ele digita seu e‑mail registrado e uma senha errada\n  And clica no botão “Entrar”\n  Then o sistema exibe a mensagem “Usuário ou senha inválidos”"
```

```
titulo: US02 – Login
cenario_bdd:
    nome: Falha de login com e‑mail inválido
    tipo: negativo
    gherkin: "Feature: Login\nScenario: Falha de login com e‑mail inválido\n  Given o usuário está na tela de login\n  When ele digita “usuario@” como e‑mail e qualquer senha\n  And clica no botão “Entrar”\n  Then o sistema exibe a mensagem “Formato de e‑mail inválido”"
```

**US03 – Visualizar Saldo e Extrato**  
```
titulo: US03 – Visualizar Saldo e Extrato
cenario_bdd:
    nome: Dashboard exibe saldo correto
    tipo: positivo
    gherkin: "Feature: Visualizar Saldo e Extrato\nScenario: Dashboard exibe saldo correto\n  Given o usuário está autenticado e no dashboard\n  Then o saldo exibido corresponde ao saldo da conta"
```

```
titulo: US03 – Visualizar Saldo e Extrato
cenario_bdd:
    nome: Extrato exibe últimas 10 transações em ordem decrescente
    tipo: positivo
    gherkin: "Feature: Visualizar Saldo e Extrato\nScenario: Extrato exibe últimas 10 transações em ordem decrescente\n  Given o usuário está autenticado\n  When ele clica em “Extrato”\n  Then a lista mostra as 10 transações mais recentes, ordenadas pela data decrescente"
```

```
titulo: US03 – Visualizar Saldo e Extrato
cenario_bdd:
    nome: Extrato exibe mensagem quando não há transações
    tipo: negativo
    gherkin: "Feature: Visualizar Saldo e Extrato\nScenario: Extrato exibe mensagem quando não há transações\n  Given o usuário tem saldo mas nenhuma transação\n  When ele clica em “Extrato”\n  Then o sistema exibe a mensagem “Nenhuma transação registrada”"
```

**US04 – Transferência de Fundos**  
```
titulo: US04 – Transferência de Fundos
cenario_bdd:
    nome: Transferência bem-sucedida dentro do saldo
    tipo: positivo
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência bem-sucedida dentro do saldo\n  Given o usuário tem saldo de R$1.000 na conta corrente\n  When ele seleciona a conta corrente como origem\n  And seleciona a conta poupança como destino\n  And insere o valor de R$200\n  And confirma a transferência\n  Then a conta corrente é debitada em R$200\n  And a conta poupança é creditada em R$200\n  And a transação aparece no extrato de ambas as contas"
```

```
titulo: US04 – Transferência de Fundos
cenario_bdd:
    nome: Transferência falha por saldo insuficiente
    tipo: negativo
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência falha por saldo insuficiente\n  Given o usuário tem saldo de R$500 na conta corrente\n  When ele tenta transferir R$600 para outra conta\n  Then o sistema exibe a mensagem “Valor excede saldo”"
```

```
titulo: US04 – Transferência de Fundos
cenario_bdd:
    nome: Transferência falha devido a erro de rede
    tipo: negativo
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência falha devido a erro de rede\n  Given o usuário tem saldo de R$1.000 na conta corrente\n  When a conexão cai durante a transferência\n  Then nenhuma conta é alterada\n  And o usuário recebe a mensagem “Transferência não concluída, tente novamente”"
```

**US05 – Solicitação de Empréstimo**  
```
titulo: US05 – Solicitação de Empréstimo
cenario_bdd:
    nome: Empréstimo aprovado quando renda adequada
    tipo: positivo
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo aprovado quando renda adequada\n  Given o usuário tem renda anual de R$30.000\n  When ele solicita R$20.000\n  And clica em “Solicitar”\n  Then o sistema exibe “Empréstimo aprovado”"
```

```
titulo: US05 – Solicitação de Empréstimo
cenario_bdd:
    nome: Empréstimo negado por renda insuficiente
    tipo: negativo
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo negado por renda insuficiente\n  Given o usuário tem renda anual de R$15.000\n  When ele solicita R$20.000\n  Then o sistema exibe “Empréstimo negado – renda insuficiente”"
```

```
titulo: US05 – Solicitação de Empréstimo
cenario_bdd:
    nome: Empréstimo rejeitado por valor superior ao limite
    tipo: negativo
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo rejeitado por valor superior ao limite\n  Given o usuário tem renda anual de R$60.000\n  When ele solicita R$60.000\n  Then o sistema exibe “Dados inválidos”"
```

**US06 – Pagamento de Contas**  
```
titulo: US06 – Pagamento de Contas
cenario_bdd:
    nome: Pagamento agendado com saldo futuro suficiente
    tipo: positivo
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento agendado com saldo futuro suficiente\n  Given o usuário tem saldo de R$1.000\n  When ele agenda pagamento de R$200 para 30 dias à frente\n  And confirma\n  Then o sistema exibe “Pagamento agendado com sucesso”\n  And uma transação com status “Agendado” aparece no histórico"
```

```
titulo: US06 – Pagamento de Contas
cenario_bdd:
    nome: Falha ao agendar pagamento com data no passado
    tipo: negativo
    gherkin: "Feature: Pagamento de Contas\nScenario: Falha ao agendar pagamento com data no passado\n  Given o usuário tenta agendar pagamento para 01/01/2023\n  When ele confirma\n  Then o sistema exibe “Data inválida”"
```

```
titulo: US06 – Pagamento de Contas
cenario_bdd:
    nome: Pagamento permanece agendado por saldo insuficiente no dia de pagamento
    tipo: negativo
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento permanece agendado por saldo insuficiente no dia de pagamento\n  Given o usuário tem saldo de R$150 hoje\n  When ele agenda pagamento de R$200 para amanhã\n  And a conta não tem saldo no dia\n  Then o pagamento permanece “Agendado” e o usuário recebe mensagem “Saldo insuficiente para pagamento”"
```

**US07 – Navegação e Usabilidade Geral**  
```
titulo: US07 – Navegação e Usabilidade Geral
cenario_bdd:
    nome: Todas as páginas carregam e navegação funciona
    tipo: positivo
    gherkin: "Feature: Navegação e Usabilidade Geral\nScenario: Todas as páginas carregam e navegação funciona\n  Given o usuário está autenticado\n  When ele clica em “Transferências”\n  Then a página de transferências carrega sem erros\n  And o menu permanece ativo"
```

```
titulo: US07 – Navegação e Usabilidade Geral
cenario_bdd:
    nome: Acesso a página protegida sem autenticação redireciona ao login
    tipo: negativo
    gherkin: "Feature: Navegação e Usabilidade Geral\nScenario: Acesso a página protegida sem autenticação redireciona ao login\n  Given o usuário não autenticado\n  When ele tenta acessar “Minha Conta”\n  Then ele é redirecionado ao login"
```

```
titulo: US07 – Navegação e Usabilidade Geral
cenario_bdd:
    nome: Página não encontrada exibe banner de erro
    tipo: negativo
    gherkin: "Feature: Navegação e Usabilidade Geral\nScenario: Página não encontrada exibe banner de erro\n  Given o usuário acessa URL inválida\n  When a página 404 é gerada\n  Then o banner exibe “Página não encontrada”"
```