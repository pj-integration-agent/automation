```json
[
  {
    "titulo": "US01 – Registro de nova conta",
    "cenario_bdd": [
      {
        "nome": "Registro bem-sucedido",
        "tipo": "positivo",
        "gherkin": "Feature: Registro de nova conta\nScenario: Registro bem-sucedido\n  Given eu sou um novo cliente\n  When preencho todos os campos obrigatórios com dados válidos\n  And envio o formulário\n  Then recebo a mensagem \"Cadastro concluído, verifique seu e‑mail\"\n  And posso fazer login com as credenciais recém‑criadas"
      },
      {
        "nome": "Erro de e‑mail inválido",
        "tipo": "negativo",
        "gherkin": "Feature: Registro de nova conta\nScenario: E‑mail inválido\n  Given eu sou um novo cliente\n  When preencho o campo e‑mail com \"usuario@exemplo\"\n  And completo os demais campos obrigatórios com dados válidos\n  And envio o formulário\n  Then recebo a mensagem \"E‑mail inválido\"\n  And o registro não é criado"
      },
      {
        "nome": "Campo obrigatório ausente",
        "tipo": "negativo",
        "gherkin": "Feature: Registro de nova conta\nScenario: Campo obrigatório ausente\n  Given eu sou um novo cliente\n  When deixo o campo \"CEP\" em branco e preencho os demais campos com dados válidos\n  And envio o formulário\n  Then recebo a mensagem \"CEP obrigatório\"\n  And o registro não é criado"
      },
      {
        "nome": "E‑mail já cadastrado",
        "tipo": "negativo",
        "gherkin": "Feature: Registro de nova conta\nScenario: E‑mail já cadastrado\n  Given eu sou um novo cliente\n  And já existe um usuário com e‑mail \"usuario@exemplo.com\"\n  When preencho todos os campos obrigatórios com dados válidos\n  And envio o formulário\n  Then recebo a mensagem \"E‑mail já cadastrado\"\n  And o registro não é criado"
      }
    ]
  },
  {
    "titulo": "US02 – Login do cliente",
    "cenario_bdd": [
      {
        "nome": "Login bem-sucedido",
        "tipo": "positivo",
        "gherkin": "Feature: Login do cliente\nScenario: Login bem-sucedido\n  Given eu sou um cliente registrado com e‑mail \"usuario@exemplo.com\" e senha \"Senha1234\"\n  When preencho o e‑mail e a senha\n  And clico em \"Entrar\"\n  Then sou redirecionado para o Dashboard\n  And a mensagem \"Bem‑vindo\" aparece"
      },
      {
        "nome": "Credenciais inválidas",
        "tipo": "negativo",
        "gherkin": "Feature: Login do cliente\nScenario: Credenciais inválidas\n  Given eu sou um cliente registrado com e‑mail \"usuario@exemplo.com\"\n  When preencho o e‑mail com \"usuario@exemplo.com\" e senha com \"senhaerrada\"\n  And clico em \"Entrar\"\n  Then recebo a mensagem \"Credenciais inválidas. Tente novamente.\"\n  And permaneço na página de login"
      },
      {
        "nome": "Campo de senha pode ser exibido",
        "tipo": "positivo",
        "gherkin": "Feature: Login do cliente\nScenario: Exibição da senha\n  Given eu estou na tela de login\n  When clico no ícone \"Mostrar\"\n  Then a senha é exibida em texto\n  When clico novamente no ícone \"Ocultar\"\n  Then a senha fica oculta"
      }
    ]
  },
  {
    "titulo": "US03 – Visualização do saldo",
    "cenario_bdd": [
      {
        "nome": "Saldo inicial exibido corretamente",
        "tipo": "positivo",
        "gherkin": "Feature: Visualização do saldo\nScenario: Saldo inicial\n  Given eu estou no Dashboard\n  Then o saldo exibido está no formato \"R$ 1.234,56\"\n  And o valor não é negativo"
      },
      {
        "nome": "Saldo atualizado após transferência",
        "tipo": "positivo",
        "gherkin": "Feature: Visualização do saldo\nScenario: Saldo atualizado após transferência\n  Given eu tenho saldo \"R$ 1.000,00\"\n  And realizei uma transferência de \"R$ 200,00\"\n  Then o saldo exibido no Dashboard é \"R$ 800,00\""
      }
    ]
  },
  {
    "titulo": "US04 – Extrato de transações",
    "cenario_bdd": [
      {
        "nome": "Extrato exibe 10 transações recentes",
        "tipo": "positivo",
        "gherkin": "Feature: Extrato de transações\nScenario: Exibição de 10 transações\n  Given eu tenho pelo menos 10 transações na conta\n  When acesso a página de extrato\n  Then a lista exibe 10 linhas\n  And cada linha contém data, descrição, tipo e valor"
      },
      {
        "nome": "Extrato exibe menos de 10 se houver menos registros",
        "tipo": "positivo",
        "gherkin": "Feature: Extrato de transações\nScenario: Menos de 10 transações\n  Given eu tenho 5 transações na conta\n  When acesso a página de extrato\n  Then a lista exibe 5 linhas\n  And as linhas estão em ordem decrescente"
      }
    ]
  },
  {
    "titulo": "US05 – Transferência de fundos",
    "cenario_bdd": [
      {
        "nome": "Transferência bem-sucedida",
        "tipo": "positivo",
        "gherkin": "Feature: Transferência de fundos\nScenario: Transferência bem-sucedida\n  Given eu tenho saldo \"R$ 1.000,00\" na conta A\n  And a conta B existe\n  When realizo uma transferência de \"R$ 300,00\" da conta A para a conta B\n  And confirmo a operação\n  Then o saldo da conta A é \"R$ 700,00\"\n  And o saldo da conta B aumenta em \"R$ 300,00\"\n  And ambas as contas registram a transação no histórico"
      },
      {
        "nome": "Transferência bloqueada por saldo insuficiente",
        "tipo": "negativo",
        "gherkin": "Feature: Transferência de fundos\nScenario: Saldo insuficiente\n  Given eu tenho saldo \"R$ 100,00\" na conta A\n  When tento transferir \"R$ 200,00\" da conta A para a conta B\n  Then recebo a mensagem \"Saldo insuficiente\"\n  And a transferência não ocorre"
      }
    ]
  },
  {
    "titulo": "US06 – Solicitação de empréstimo",
    "cenario_bdd": [
      {
        "nome": "Solicitação enviada",
        "tipo": "positivo",
        "gherkin": "Feature: Solicitação de empréstimo\nScenario: Envio de solicitação\n  Given eu sou um cliente autenticado\n  And preencho o valor \"R$ 10.000,00\" e renda anual \"R$ 60.000,00\"\n  When envio a solicitação\n  Then recebo a mensagem \"Solicitação enviada. Aguarde avaliação.\"\n  And a solicitação fica registrada em \"Meus Empréstimos\""
      },
      {
        "nome": "Resultado aprovado após 5 minutos",
        "tipo": "positivo",
        "gherkin": "Feature: Solicitação de empréstimo\nScenario: Empréstimo aprovado\n  Given eu enviei uma solicitação de empréstimo\n  When 5 minutos se passam\n  Then a página mostra \"Aprovado\"\n  And a entrada aparece em \"Meus Empréstimos\""
      },
      {
        "nome": "Resultado negado após 5 minutos",
        "tipo": "negativo",
        "gherkin": "Feature: Solicitação de empréstimo\nScenario: Empréstimo negado\n  Given eu enviei uma solicitação de empréstimo\n  When 5 minutos se passam\n  Then a página mostra \"Negado\"\n  And a entrada aparece em \"Meus Empréstimos\""
      },
      {
        "nome": "Solicitação com campo obrigatório ausente",
        "tipo": "negativo",
        "gherkin": "Feature: Solicitação de empréstimo\nScenario: Campo obrigatório ausente\n  Given eu sou um cliente autenticado\n  When deixo o campo \"valor do empréstimo\" em branco\n  And envio a solicitação\n  Then recebo a mensagem \"Valor do empréstimo obrigatório\"\n  And a solicitação não é criada"
      }
    ]
  },
  {
    "titulo": "US07 – Pagamento de contas",
    "cenario_bdd": [
      {
        "nome": "Pagamento agendado com sucesso",
        "tipo": "positivo",
        "gherkin": "Feature: Pagamento de contas\nScenario: Pagamento agendado\n  Given eu sou um cliente autenticado\n  And preencho todos os campos obrigatórios com dados válidos\n  And seleciono a data \"25/12/2025\"\n  When envio o pagamento\n  Then recebo a mensagem \"Pagamento agendado para 25/12/2025\"\n  And a transação aparece no histórico na data correta"
      },
      {
        "nome": "Erro de CEP inválido",
        "tipo": "negativo",
        "gherkin": "Feature: Pagamento de contas\nScenario: CEP inválido\n  Given eu sou um cliente autenticado\n  And preencho o CEP com \"12345\"\n  When envio o pagamento\n  Then recebo a mensagem \"CEP inválido\"\n  And o pagamento não é registrado"
      },
      {
        "nome": "Pagamento futuro não processado na data atual",
        "tipo": "negativo",
        "gherkin": "Feature: Pagamento de contas\nScenario: Pagamento futuro não processado\n  Given eu agendei um pagamento para \"30/12/2025\"\n  When verifico a conta no dia \"01/12/2025\"\n  Then o pagamento permanece com status \"Agendado\"\n  And não há débito na conta"
      }
    ]
  },
  {
    "titulo": "US08 – Navegação sem erros",
    "cenario_bdd": [
      {
        "nome": "Todas as páginas carregam sem erro 404",
        "tipo": "positivo",
        "gherkin": "Feature: Navegação sem erros\nScenario: Navegação completa\n  Given eu estou autenticado\n  When clico em cada link do menu principal\n  Then cada página carrega corretamente\n  And nenhuma rota retorna erro 404\n  And o breadcrumb sempre aponta para o Dashboard"
      }
    ]
  },
  {
    "titulo": "US09 – Mensagens de erro claras",
    "cenario_bdd": [
      {
        "nome": "Mensagem de erro de login clara",
        "tipo": "negativo",
        "gherkin": "Feature: Mensagens de erro claras\nScenario: Erro de login\n  Given eu sou um cliente registrado\n  When preencho e‑mail e senha incorretos\n  And clico em \"Entrar\"\n  Then recebo a mensagem \"Credenciais inválidas. Tente novamente.\"\n  And a mensagem não contém códigos técnicos"
      },
      {
        "nome": "Mensagem de erro de e‑mail já cadastrado",
        "tipo": "negativo",
        "gherkin": "Feature: Mensagens de erro claras\nScenario: E‑mail já cadastrado\n  Given eu estou na página de cadastro\n  And já existe usuário com e‑mail \"usuario@exemplo.com\"\n  When envio o formulário\n  Then recebo a mensagem \"E‑mail já cadastrado\"\n  And a mensagem não contém stack traces"
      }
    ]
  },
  {
    "titulo": "US10 – Registro no histórico de transações",
    "cenario_bdd": [
      {
        "nome": "Transferência registrada no histórico",
        "tipo": "positivo",
        "gherkin": "Feature: Registro no histórico\nScenario: Transferência\n  Given eu realizo uma transferência de \"R$ 200,00\" entre contas\n  Then há um registro no histórico com data, tipo \"Transferência\" e valor \"R$ 200,00\"\n  And a descrição indica a conta de destino"
      },
      {
        "nome": "Pagamento registrado no histórico",
        "tipo": "positivo",
        "gherkin": "Feature: Registro no histórico\nScenario: Pagamento\n  Given eu pago uma conta de \"Luz\"\n  Then há um registro no histórico com data, tipo \"Pagamento\" e valor correspondente\n  And a descrição inclui o beneficiário"
      },
      {
        "nome": "Empréstimo registrado no histórico",
        "tipo": "positivo",
        "gherkin": "Feature: Registro no histórico\nScenario: Empréstimo\n  Given eu recebo aprovação de empréstimo de \"R$ 5.000,00\"\n  Then há um registro no histórico com data, tipo \"Empréstimo\" e valor \"R$ 5.000,00\"\n  And a descrição indica status \"Aprovado\""
      }
    ]
  },
  {
    "titulo": "US11 – Pagamentos futuros respeitam data agendada",
    "cenario_bdd": [
      {
        "nome": "Pagamento futuro respeita a data de agendamento",
        "tipo": "positivo",
        "gherkin": "Feature: Pagamentos futuros\nScenario: Respeito da data agendada\n  Given eu agendei um pagamento para \"15/01/2026\"\n  And a conta tem saldo suficiente em 15/01/2026\n  When a data atual é \"15/01/2026\"\n  Then o sistema processa o pagamento automaticamente\n  And o saldo é debitado no dia correto"
      }
    ]
  },
  {
    "titulo": "US12 – Layout responsivo em dispositivos móveis",
    "cenario_bdd": [
      {
        "nome": "Interface se adapta ao viewport de 480px",
        "tipo": "positivo",
        "gherkin": "Feature: Layout responsivo\nScenario: Visualização em smartphone\n  Given eu acesso o site com viewport de 480px de largura\n  Then o menu principal se transforma em hamburger\n  And os campos de formulário têm largura mínima de 80% da tela\n  And os botões têm área de toque de pelo menos 48×48px"
      }
    ]
  }
]
```
