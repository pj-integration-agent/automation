```gherkin
# ParaBank – Cenários BDD (Gherkin, Português)

# ==============================================================
# 1. Cadastro de Usuário
# ==============================================================

Feature: Cadastro de Usuário
  Como novo cliente
  Quero registrar uma conta no ParaBank
  Para ter acesso ao sistema após a criação da conta

  # US-01 – Cadastro bem-sucedido
  Scenario: Cadastro de usuário com dados corretos
    Dado que o usuário acessa a página de registro
    Quando ele preenche todos os campos obrigatórios com dados válidos
    E clica no botão “Criar Conta”
    Então a página exibe a mensagem “Registro concluído com sucesso”
    E o usuário é redirecionado para a tela de login

  # US-02 – Campos obrigatórios
  Scenario Outline: Tentativa de cadastro sem preencher campos obrigatórios
    Dado que o usuário acessa a página de registro
    Quando ele preenche os seguintes campos obrigatórios: <campos>
    E clica no botão “Criar Conta”
    Então a página exibe a mensagem de erro “<mensagem>”
    E o campo <campo_erro> é destacado

    Examples:
      | campos                     | mensagem                                   | campo_erro   |
      | Nome completo              | O campo Nome completo é obrigatório       | Nome completo|
      | E‑mail, Telefone, CPF      | O campo CPF é obrigatório                 | CPF          |
      | Endereço, CEP, Cidade, Estado | O campo CEP é obrigatório                 | CEP          |

  # US-03 – Validação de dados
  Scenario Outline: Validação em tempo real de telefone, CEP e e‑mail
    Dado que o usuário acessa a página de registro
    Quando ele digita <valor> no campo <campo>
    Então a página exibe a mensagem de erro “<mensagem>” em tempo real

    Examples:
      | campo   | valor            | mensagem                                |
      | Telefone| 123            | Telefone inválido, digite 10 dígitos   |
      | CEP     | ABC12345       | CEP inválido, digite apenas números   |
      | E‑mail  | usuario@       | E‑mail inválido, verifique o domínio  |

  # US-04 – Confirmação de cadastro
  Scenario: Mensagem de confirmação após cadastro
    Dado que o usuário preencheu todos os campos obrigatórios corretamente
    Quando ele confirma o cadastro
    Então o sistema exibe “Registro concluído com sucesso”
    E o usuário pode prosseguir ao login

# ==============================================================
# 2. Login
# ==============================================================

Feature: Login
  Como cliente existente
  Quero entrar no sistema
  Para ter acesso à minha conta bancária

  # US-05 – Login bem-sucedido
  Scenario: Login com credenciais válidas
    Dado que o usuário já possui uma conta cadastrada
    Quando ele insere seu e‑mail/CPF e senha corretos
    E clica em “Entrar”
    Então ele é redirecionado para a página inicial da conta
    E a sessão permanece válida até que ele faça logout

  # US-06 – Credenciais inválidas
  Scenario Outline: Tentativa de login com credenciais inválidas
    Dado que o usuário tem uma conta cadastrada
    Quando ele tenta fazer login com e‑mail/CPF “<email>” e senha “<senha>”
    Então o sistema exibe a mensagem “E‑mail ou senha inválidos”

    Examples:
      | email           | senha     |
      | errado@email.com | senha123  |
      | certo@email.com  | wrongPass |

# ==============================================================
# 3. Saldo e Extrato
# ==============================================================

Feature: Saldo e Extrato
  Como cliente logado
  Quero visualizar saldo e extrato
  Para saber quanto dinheiro tenho disponível e meu histórico de movimentações

  # US-07 – Visualizar saldo atualizado
  Scenario: Visualização do saldo após operação
    Dado que o usuário está logado
    E ele realizou uma operação (depósito, retirada, transferência, pagamento) de <valor> em <tipo>
    Quando ele acessa a página de saldo
    Então ele vê o valor atualizado do saldo: <saldo_atual>

    Examples:
      | valor | tipo       | saldo_atual |
      | 500   | Depósito   | 1500        |
      | 200   | Retirada   | 1300        |

  # US-08 – Visualizar extrato
  Scenario: Visualização do extrato em ordem cronológica decrescente
    Dado que o usuário está logado
    E ele realizou várias transações
    Quando ele acessa a página de extrato
    Então o extrato lista as transações nas seguintes linhas (mais recente primeiro):
      | Data       | Tipo             | Valor | Saldo após |
      | 2025‑10‑03 | Transferência    | -200  | 1300      |
      | 2025‑10‑02 | Depósito         | +500  | 1500      |
      | 2025‑10‑01 | Pagamento        | -100  | 1000      |

# ==============================================================
# 4. Transferência de Fundos
# ==============================================================

Feature: Transferência de Fundos
  Como cliente logado
  Quero transferir dinheiro para outra conta
  Para movimentar fundos sem sair da aplicação

  # US-09 – Transferência bem-sucedida
  Scenario: Transferência de valor dentro do saldo disponível
    Dado que o usuário está logado com saldo de 1000
    Quando ele preenche “Conta de origem”, “Conta de destino” e valor “200”
    E confirma a transferência
    Então o saldo da conta de origem diminui em 200
    E o saldo da conta de destino aumenta em 200
    E a transação aparece no extrato da origem como “Transferência” e na destino como “Transferência recebida”

  # US-10 – Seleção de contas e valor
  Scenario Outline: Validação de valores e contas na transferência
    Dado que o usuário está logado
    Quando ele tenta transferir <valor> da conta <origem> para a conta <destino>
    Então o sistema exibe a mensagem de erro “<mensagem>”

    Examples:
      | valor | origem | destino | mensagem                     |
      | 200   | 12345  | 54321   | Transferência concluída      |
      | 0     | 12345  | 54321   | Valor deve ser maior que zero|
      | 2000  | 12345  | 54321   | Saldo insuficiente           |

  # US-11 – Evitar saldo insuficiente
  Scenario: Tentativa de transferência com saldo insuficiente
    Dado que o usuário tem saldo de 100
    Quando ele tenta transferir 200
    Então o sistema exibe a mensagem “Saldo insuficiente”
    E a transferência não é realizada

# ==============================================================
# 5. Solicitação de Empréstimo
# ==============================================================

Feature: Solicitação de Empréstimo
  Como cliente logado
  Quero solicitar um empréstimo
  Para obter crédito adicional se necessário

  # US-12 – Formulário de empréstimo
  Scenario: Preenchimento do formulário de empréstimo
    Dado que o usuário está logado
    Quando ele preenche “Valor do empréstimo” e “Renda anual”
    E clica em “Solicitar Empréstimo”
    Então o sistema processa a solicitação

  # US-13 – Decisão de aprovação ou negação
  Scenario Outline: Resposta ao pedido de empréstimo
    Dado que o sistema processa o pedido
    Quando a análise determina status <status>
    Então o usuário vê um banner <mensagem> no topo da tela

    Examples:
      | status   | mensagem                                   |
      | Aprovado | Empréstimo aprovado! Valor creditado      |
      | Negado   | Empréstimo negado. Motivo: renda insuficiente |

  # US-14 – Crédito em conta após aprovação
  Scenario: Crédito de empréstimo aprovado
    Dado que o empréstimo foi aprovado
    Quando o valor é creditado na conta do cliente
    Então o saldo da conta aumenta em <valor_emprestimo>

    Examples:
      | valor_emprestimo |
      | 5000             |

# ==============================================================
# 6. Pagamento de Contas
# ==============================================================

Feature: Pagamento de Contas
  Como cliente logado
  Quero registrar pagamento a terceiros
  Para pagar contas de forma automatizada

  # US-15 – Registro de pagamento
  Scenario: Registro de pagamento imediato
    Dado que o usuário está logado
    Quando ele preenche todos os campos obrigatórios do formulário de pagamento
    E confirma o pagamento
    Então o pagamento é registrado no histórico de transações
    E o usuário vê a mensagem “Pagamento confirmado”

  # US-16 – Dados completos do pagamento
  Scenario Outline: Validação dos campos obrigatórios do pagamento
    Dado que o usuário está logado
    Quando ele tenta salvar o pagamento sem preencher <campo>
    Então o sistema exibe a mensagem de erro “<mensagem>”

    Examples:
      | campo                | mensagem                         |
      | Beneficiário         | Beneficiário é obrigatório       |
      | CEP                   | CEP é obrigatório                 |
      | Conta de destino     | Conta de destino é obrigatória  |

  # US-17 – Pagamento agendado
  Scenario: Pagamento agendado
    Dado que o usuário preenche o formulário com data futura “<data_futura>”
    Quando ele confirma o pagamento
    Então o pagamento fica marcado como “Agendado”
    E não é debitado antes de <data_futura>

    Examples:
      | data_futura   |
      | 2025‑10‑20    |

# ==============================================================
# 7. Navegação e Usabilidade
# ==============================================================

Feature: Navegação e Usabilidade
  Como usuário em qualquer página
  Quero navegar entre funcionalidades sem erros
  Para ter experiência de uso fluida

  # US-18 – Navegação sem erros
  Scenario Outline: Acesso a páginas de navegação
    Dado que o usuário está logado
    Quando ele clica no link “<link>”
    Então a página <pagina> carrega sem erros

    Examples:
      | link        | pagina          |
      | Saldo       | /conta/saldo    |
      | Extrato     | /conta/extrato  |
      | Empréstimos | /emprestimos    |

  # US-19 – Mensagens de erro claras
  Scenario: Erro de campo inválido
    Dado que o usuário tenta inserir dados inválidos em um campo
    Quando ele tenta submeter o formulário
    Então a mensagem de erro aparece imediatamente e indica exatamente o que está errado

  # US-20 – Menus consistentes
  Scenario: Menus consistentes em todas as páginas
    Dado que o usuário está em qualquer página
    Quando ele inspeciona o cabeçalho, barra lateral e rodapé
    Então os mesmos itens de menu aparecem em todas as páginas
    E o layout é responsivo em desktop, tablet e mobile
```

> **Observação**: Cada cenário cobre um dos critérios de aceitação definidos nas histórias de usuário. Eles podem ser utilizados diretamente em ferramentas de BDD (Cucumber, SpecFlow, etc.) para gerar testes automatizados.