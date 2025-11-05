```gherkin
# ---------------------------------------------
# US001 – Cadastro de Usuário
# ---------------------------------------------
Feature: Cadastro de Usuário
  Como novo usuário do ParaBank
  Quero criar minha conta
  Para ter acesso ao sistema e à minha conta bancária

  # Cenário positivo: registro com dados válidos
  Scenario: Registro bem‑sucedido com todos os campos preenchidos corretamente
    Given que estou na página de registro
    When preencho o campo "Nome" com "Ana Silva"
    And preencho o campo "E‑mail" com "ana.silva@email.com"
    And preencho o campo "Telefone" com "11987654321"
    And preencho o campo "CEP" com "12345000"
    And preencho o campo "Senha" com "S3nhaSegura123"
    And confirmo a senha com "S3nhaSegura123"
    And clico no botão "Registrar"
    Then devo ver a mensagem "Cadastro concluído com sucesso! Você pode fazer login agora."
    And o usuário "ana.silva@email.com" deve existir no banco com hash da senha

  # Cenário negativo: campo obrigatório em branco
  Scenario Outline: Registro falha quando o campo <campo> está vazio
    Given que estou na página de registro
    When deixo o campo "<campo>" em branco
    And preencho os demais campos com valores válidos
    And clico no botão "Registrar"
    Then devo ver a mensagem "Este campo é obrigatório" ao lado do campo "<campo>"

    Examples:
      | campo        |
      | Nome         |
      | E‑mail       |
      | Telefone     |
      | CEP          |
      | Senha        |
      | Confirmar Senha |

  # Cenário negativo: dados inválidos
  Scenario Outline: Registro falha com valor inválido em <campo>
    Given que estou na página de registro
    When preencho o campo "<campo>" com "<valor>"
    And preencho os demais campos com valores válidos
    And clico no botão "Registrar"
    Then devo ver a mensagem "<mensagem>" ao lado do campo "<campo>"

    Examples:
      | campo        | valor                    | mensagem          |
      | E‑mail       | "ana.silvaemail.com"     | "E‑mail inválido"|
      | CEP          | "CEP12345"               | "CEP inválido"   |
      | Telefone     | "1234"                   | "Telefone inválido" |

  # Cenário negativo: senha e confirmação diferentes
  Scenario: Registro falha quando senha e confirmação não coincidem
    Given que estou na página de registro
    When preencho o campo "Senha" com "S3nhaSegura123"
    And preencho o campo "Confirmar Senha" com "SenhaErrada"
    And preencho os demais campos com valores válidos
    And clico no botão "Registrar"
    Then devo ver a mensagem "Senhas não coincidem" ao lado do campo "Confirmar Senha"

# ---------------------------------------------
# US002 – Login
# ---------------------------------------------
Feature: Login
  Como usuário existente do ParaBank
  Quero fazer login
  Para ter acesso ao dashboard da minha conta

  # Cenário positivo: login com credenciais válidas
  Scenario: Login bem‑sucedido
    Given que estou na página de login
    When preencho o campo "E‑mail" com "ana.silva@email.com"
    And preencho o campo "Senha" com "S3nhaSegura123"
    And clico no botão "Entrar"
    Then devo ser redirecionado para a página "Home"
    And devo ver meu nome de usuário "Ana Silva" no cabeçalho

  # Cenário negativo: credenciais inválidas
  Scenario Outline: Login falha com credenciais inválidas
    Given que estou na página de login
    When preencho o campo "E‑mail" com "<email>"
    And preencho o campo "Senha" com "<senha>"
    And clico no botão "Entrar"
    Then devo ver a mensagem "Credenciais inválidas. Por favor, tente novamente."

    Examples:
      | email                     | senha              |
      | "nao.existe@email.com"    | "S3nhaSegura123"  |
      | "ana.silva@email.com"     | "senhaErrada"     |

  # Cenário negativo: campos obrigatórios em branco
  Scenario Outline: Login falha quando o campo <campo> está vazio
    Given que estou na página de login
    When deixo o campo "<campo>" em branco
    And preencho os demais campos com valores válidos
    And clico no botão "Entrar"
    Then devo ver a mensagem "Este campo é obrigatório" ao lado do campo "<campo>"

    Examples:
      | campo |
      | E‑mail |
      | Senha |

  # Cenário negativo: bloqueio após 5 tentativas falhadas
  Scenario: Conta bloqueada após 5 tentativas de login falhadas
    Given que estou na página de login
    And o usuário "ana.silva@email.com" tem 0 tentativas de login bloqueadas
    When tento fazer login com senha incorreta 5 vezes
    Then devo ver a mensagem "Conta bloqueada, tente novamente em 15 min"

# ---------------------------------------------
# US003 – Exibição de Saldo
# ---------------------------------------------
Feature: Exibição de Saldo
  Como usuário logado
  Quero visualizar meu saldo atual
  Para saber quanto dinheiro tenho disponível

  # Cenário positivo: saldo reflete transações recentes
  Scenario: Saldo atualizado imediatamente após transferência
    Given que estou na página inicial da conta
    And meu saldo atual é "R$ 1.000,00"
    When faço uma transferência de "R$ 200,00" para outra conta
    And aguardo 2 segundos
    Then o saldo exibido deve ser "R$ 800,00"

  # Cenário positivo: saldo zero quando não há transações
  Scenario: Saldo zero ao criar conta sem transações
    Given que criei uma nova conta sem movimentações
    And estou na página inicial da conta
    Then o saldo exibido deve ser "R$ 0,00"

# ---------------------------------------------
# US004 – Exibição de Extrato
# ---------------------------------------------
Feature: Exibição de Extrato
  Como usuário logado
  Quero ver extrato de transações
  Para entender histórico financeiro

  # Cenário positivo: exibe as últimas 10 transações
  Scenario: Exibir 10 transações mais recentes
    Given que tenho 12 transações no histórico
    When navego para a página de extrato
    Then devo ver 10 linhas de transação listadas
    And a primeira linha deve ter a data mais recente
    And cada linha deve conter data, descrição, tipo, valor e saldo pós‑operação

  # Cenário positivo: exibir menos de 10 quando houver menos transações
  Scenario: Exibir todas as transações quando houver menos de 10
    Given que tenho 7 transações no histórico
    When navego para a página de extrato
    Then devo ver 7 linhas de transação listadas

  # Cenário positivo: botão "Ver Mais" abre extrato completo
  Scenario: Navegar para extrato completo
    Given que tenho 25 transações no histórico
    When clico no botão "Ver Mais"
    Then devo ser redirecionado para a página de extrato completo
    And devo ver todas as 25 transações listadas

  # Cenário negativo: página 404 ao tentar acessar extrato sem permissão
  Scenario: Acesso não autorizado ao extrato
    Given que estou autenticado como "Ana Silva"
    When tento acessar "/extrato" enquanto não tenho permissão
    Then devo ser redirecionado para a página "Home"
    And devo ver a mensagem "Acesso não autorizado"

# ---------------------------------------------
# US005 – Transferência de Fundos
# ---------------------------------------------
Feature: Transferência de Fundos
  Como usuário logado
  Quero transferir valor para outra conta
  Para mover dinheiro entre minhas contas ou para terceiros

  # Cenário positivo: transferência dentro do saldo disponível
  Scenario: Transferência bem‑sucedida
    Given que tenho saldo de "R$ 500,00" na conta A
    When seleciono a conta origem "Conta A"
    And seleciono a conta destino "Conta B"
    And preencho o valor "R$ 150,00"
    And confirmo a transferência
    Then devo ver a mensagem "Transferência concluída em 10:15"
    And o saldo da conta A deve ser "R$ 350,00"
    And o saldo da conta B deve ser "R$ 150,00"
    And ambas as contas devem ter o registro de transação no histórico

  # Cenário negativo: valor superior ao saldo
  Scenario: Transferência falha por saldo insuficiente
    Given que tenho saldo de "R$ 100,00" na conta A
    When seleciono a conta origem "Conta A"
    And seleciono a conta destino "Conta B"
    And preencho o valor "R$ 150,00"
    And confirmo a transferência
    Then devo ver a mensagem "Saldo insuficiente"

  # Cenário negativo: valor inválido (texto ou negativo)
  Scenario Outline: Transferência falha com valor inválido "<valor>"
    Given que tenho saldo de "R$ 500,00" na conta A
    When seleciono a conta origem "Conta A"
    And seleciono a conta destino "Conta B"
    And preencho o valor "<valor>"
    And confirmo a transferência
    Then devo ver a mensagem "Valor inválido"

    Examples:
      | valor     |
      | "-50"     |
      | "abc"     |
      | "0"       |

  # Cenário negativo: destino não selecionado
  Scenario: Transferência falha sem conta destino
    Given que tenho saldo de "R$ 500,00" na conta A
    When seleciono a conta origem "Conta A"
    And deixo a conta destino em branco
    And preencho o valor "R$ 50,00"
    And confirmo a transferência
    Then devo ver a mensagem "Conta destino obrigatória"

# ---------------------------------------------
# US006 – Solicitação de Empréstimo
# ---------------------------------------------
Feature: Solicitação de Empréstimo
  Como usuário logado
  Quero solicitar empréstimo
  Para obter crédito

  # Cenário positivo: aprovação
  Scenario: Empréstimo aprovado
    Given que minha renda anual é "R$ 120.000,00"
    When preencho o valor do empréstimo com "R$ 10.000,00"
    And preencho a renda anual com "R$ 120.000,00"
    And envio o pedido
    Then devo ver a mensagem "Aprovado" em verde
    And o status do empréstimo deve ser "Aprovado"

  # Cenário negativo: renda baixa
  Scenario: Empréstimo negado por baixa renda
    Given que minha renda anual é "R$ 20.000,00"
    When preencho o valor do empréstimo com "R$ 10.000,00"
    And preencho a renda anual com "R$ 20.000,00"
    And envio o pedido
    Then devo ver a mensagem "Empréstimo negado devido a baixa renda" em vermelho

  # Cenário negativo: valor ou renda inválidos
  Scenario Outline: Empréstimo falha com valor/renda inválido
    Given que minha renda anual é "<renda>"
    When preencho o valor do empréstimo com "<valor>"
    And preencho a renda anual com "<renda>"
    And envio o pedido
    Then devo ver a mensagem "<mensagem>" em vermelho

    Examples:
      | valor     | renda    | mensagem                                 |
      | "-5.000"  | "120000" | "Valor do Empréstimo inválido"          |
      | "5000"    | "0"      | "Renda Anual inválida"                  |
      | "abc"     | "120000" | "Valor do Empréstimo inválido"          |

# ---------------------------------------------
# US007 – Pagamento de Contas
# ---------------------------------------------
Feature: Pagamento de Contas
  Como usuário logado
  Quero registrar pagamento futuro
  Para gerenciar contas a pagar

  # Cenário positivo: agendamento com data futura
  Scenario: Pagamento agendado corretamente
    Given que estou na página de pagamento
    When preencho "Beneficiário" com "Empresa X"
    And preencho "Endereço" com "Rua Y, 123"
    And preencho "Cidade" com "São Paulo"
    And preencho "Estado" com "SP"
    And preencho "CEP" com "01234000"
    And preencho "Telefone" com "11999999999"
    And preencho "Conta de Destino" com "Conta 123456"
    And preencho "Valor" com "R$ 300,00"
    And preencho "Data de Pagamento" com "15/12/2025"
    And confirmo o pagamento
    Then devo ver a mensagem "Pagamento agendado para 15/12/2025"
    And o pagamento deve aparecer no histórico marcado como "PAGAMENTO FUTURO"

  # Cenário negativo: data no passado
  Scenario: Agendamento falha com data de pagamento passada
    Given que estou na página de pagamento
    When preencho "Data de Pagamento" com "01/01/2020"
    And confirmo o pagamento
    Then devo ver a mensagem "Data de pagamento inválida"

  # Cenário negativo: CEP inválido
  Scenario: Agendamento falha com CEP inválido
    Given que estou na página de pagamento
    When preencho "CEP" com "CEP123"
    And confirmo o pagamento
    Then devo ver a mensagem "CEP inválido"

  # Cenário negativo: valor inválido
  Scenario: Agendamento falha com valor não positivo
    Given que estou na página de pagamento
    When preencho "Valor" com "R$ -50,00"
    And confirmo o pagamento
    Then devo ver a mensagem "Valor inválido"

# ---------------------------------------------
# US008 – Navegação Consistente
# ---------------------------------------------
Feature: Navegação Consistente
  Como usuário logado
  Quero navegar entre páginas do ParaBank
  Para ter experiência fluida

  # Cenário positivo: menu presente em todas as páginas
  Scenario Outline: Menu aparece em <página>
    Given que estou na página "<página>"
    Then devo ver os itens de menu: Home, Saldo, Extrato, Transferência, Empréstimo, Pagamento, Logout

    Examples:
      | página          |
      | Home            |
      | Saldo           |
      | Extrato         |
      | Transferência   |
      | Empréstimo      |
      | Pagamento       |
      | Logout          |

  # Cenário negativo: link 404
  Scenario: Acesso a página inexistente
    Given que estou autenticado
    When navego para "/pagina-inexistente"
    Then devo ver a mensagem "Página não encontrada"

  # Cenário negativo: acesso não autorizado a página protegida
  Scenario: Usuário sem permissão tenta acessar página restrita
    Given que sou um usuário sem acesso à área de administração
    When tento acessar "/admin"
    Then devo ser redirecionado para "Home"
    And devo ver a mensagem "Acesso não autorizado"

# ---------------------------------------------
# US009 – Mensagens de Erro Claras
# ---------------------------------------------
Feature: Mensagens de Erro Claras
  Como usuário (logado ou não)
  Quero receber feedback claro em caso de erro
  Para entender imediatamente o problema

  # Cenário positivo: erro de campo exibido em caixa de alerta
  Scenario: Exibir alerta de erro ao submeter formulário inválido
    Given que estou na página de registro
    And deixo o campo "E‑mail" em branco
    When clico no botão "Registrar"
    Then devo ver uma caixa de alerta acima do formulário com mensagem "E‑mail inválido"

  # Cenário negativo: não exibir mensagem genérica
  Scenario: Nenhum erro genérico aparece
    Given que estou na página de login
    And deixo todos os campos em branco
    When clico no botão "Entrar"
    Then apenas as mensagens específicas de campo obrigatório são exibidas
    And não há mensagem "Erro inesperado"

# ---------------------------------------------
# US010 – Segurança de Dados
# ---------------------------------------------
Feature: Segurança de Dados
  Como usuário logado
  Quero garantir que meus dados estejam protegidos

  # Cenário positivo: senha armazenada em hash
  Scenario: Senha salva como hash bcrypt
    Given que criei uma conta com a senha "MinhaSegura123"
    When verifico os dados no banco de dados
    Then a coluna senha deve conter um hash bcrypt e não o texto plano

  # Cenário positivo: bloqueio de conta após 5 falhas
  Scenario: Conta bloqueada após 5 tentativas de login falhadas
    Given que estou na página de login
    When faço 5 tentativas com senha incorreta
    Then a conta deve estar bloqueada
    And devo ver a mensagem "Conta bloqueada, tente novamente em 15 min"

  # Cenário positivo: HTTPS utilizado
  Scenario: Todas as chamadas API são feitas via HTTPS
    When faço uma chamada para "/transfer"
    Then a requisição deve usar protocolo "https"
``` 

> **Observação:**  
> Cada `Feature` corresponde a uma história de usuário (US) e contém cenários positivos e negativos que cobrem os critérios de aceitação apresentados.  
> Os cenários podem ser refinados para a ferramenta específica de automação (Cypress, Postman, etc.), adicionando comandos de navegação e de verificação de elementos visuais conforme necessário.