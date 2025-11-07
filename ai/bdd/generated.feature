```gherkin
# Features do Sistema ParaBank
# ==============================================================
# 1 – Cadastro de Usuário
# ==============================================================
Feature: Cadastro de Usuário
  Como novo cliente do ParaBank, eu quero criar uma conta
  Para poder acessar os serviços bancários online.

  Background:
    Dado que o usuário está na página de cadastro

  Scenario: Cadastro bem‑sucedido com todos os campos corretos
    When preencho o campo "Nome Completo" com "Maria Silva"
    And preencho o campo "Data de Nascimento" com "15/04/1990"
    And preencho o campo "CPF" com "12345678901"
    And preencho o campo "E‑mail" com "maria.silva@example.com"
    And preencho o campo "Telefone" com "(11) 98765-4321"
    And preencho o campo "CEP" com "01234567"
    And preencho o campo "Endereço" com "Rua das Flores, 123"
    And preencho o campo "Cidade" com "São Paulo"
    And preencho o campo "Estado" com "SP"
    And preencho o campo "Senha" com "S3gur0Pa$$"
    And confirmo a senha com "S3gur0Pa$$"
    And clica em "Cadastrar"
    Then devo ver a mensagem "Cadastro concluído – verifique seu e‑mail"
    And devo conseguir fazer login com o e‑mail e a senha cadastrados

  Scenario: Cadastro falha quando um campo obrigatório está vazio
    When preencho o campo "Nome Completo" com ""
    And preencho o campo "Data de Nascimento" com "15/04/1990"
    And preencho o campo "CPF" com "12345678901"
    And preencho o campo "E‑mail" com "maria.silva@example.com"
    And preencho o campo "Telefone" com "(11) 98765-4321"
    And preencho o campo "CEP" com "01234567"
    And preencho o campo "Endereço" com "Rua das Flores, 123"
    And preencho o campo "Cidade" com "São Paulo"
    And preencho o campo "Estado" com "SP"
    And preencho o campo "Senha" com "S3gur0Pa$$"
    And confirmo a senha com "S3gur0Pa$$"
    And clica em "Cadastrar"
    Then devo ver a mensagem de erro "Nome completo é obrigatório"

  Scenario: Cadastro falha com e‑mail no formato inválido
    When preencho o campo "E‑mail" com "maria.silva.com"
    And clica em "Cadastrar"
    Then devo ver a mensagem "Formato de e‑mail inválido" abaixo do campo

  Scenario: Cadastro falha quando o CPF já existe
    Given existe um usuário registrado com CPF "12345678901"
    When preencho o campo "CPF" com "12345678901"
    And clica em "Cadastrar"
    Then devo ver a mensagem "CPF já cadastrado"

  Scenario: Cadastro falha quando o e‑mail já existe
    Given existe um usuário registrado com e‑mail "maria.silva@example.com"
    When preencho o campo "E‑mail" com "maria.silva@example.com"
    And clica em "Cadastrar"
    Then devo ver a mensagem "E‑mail já em uso"

# ==============================================================
# 2 – Login
# ==============================================================
Feature: Login
  Como cliente registrado, eu quero fazer login
  Para acessar minha conta de forma segura.

  Background:
    Dado que o usuário está na página de login
    E o usuário "maria.silva@example.com" está cadastrado com senha "S3gur0Pa$$"

  Scenario: Login bem‑sucedido com e‑mail e senha corretos
    When preencho o campo "E‑mail" com "maria.silva@example.com"
    And preencho o campo "Senha" com "S3gur0Pa$$"
    And clica em "Entrar"
    Then devo ser redirecionado para a página "Conta"
    And devo ver o título "Olá, Maria Silva"

  Scenario: Login falha com credenciais inválidas
    When preencho o campo "E‑mail" com "maria.silva@example.com"
    And preencho o campo "Senha" com "SenhaErrada"
    And clica em "Entrar"
    Then devo ver a mensagem "Credenciais inválidas – tente novamente"
    And permanecerei na página de login

  Scenario: Conta bloqueada após cinco tentativas falhas consecutivas
    When tento fazer login 5 vezes com senha "SenhaErrada"
    And na quinta tentativa, clica em "Entrar"
    Then devo ver a mensagem "Conta bloqueada – tente novamente em 5 min"
    And a conta ficará bloqueada por 5 minutos

# ==============================================================
# 3 – Visualização de Saldo e Extrato
# ==============================================================
Feature: Visualização de Saldo e Extrato
  Como cliente autenticado, eu quero ver meu saldo e extrato
  Para acompanhar minhas finanças.

  Background:
    Dado que o usuário está na página "Conta"

  Scenario: Saldo exibido com duas casas decimais
    Then a visualização do saldo deve mostrar "R$ 1.234,56"

  Scenario: Exibir mensagem quando não há transações
    And não há transações registradas no extrato
    When clica em "Extrato"
    Then devo ver a mensagem "Nenhuma transação encontrada"

  Scenario: Lista de extrato ordenada por data (mais recente acima)
    And há pelo menos 3 transações registradas
    When clica em "Extrato"
    Then a primeira linha da lista deve conter a transação com a data mais recente

  Scenario: Exibir cada transação com data, descrição, valor e saldo final
    And há uma transação de "Transferência para 123‑456" de R$ 200,00
    When clica em "Extrato"
    Then a linha correspondente deve mostrar:
      | Data       | Descrição           | Valor     | Saldo Final |
      | 01/11/2025 | Transferência para  | -200,00   | 1.034,56    |

# ==============================================================
# 4 – Transferência de Fundos
# ==============================================================
Feature: Transferência de Fundos
  Como cliente, eu quero transferir um valor de minha conta
  Para pagar serviços ou amigos.

  Background:
    Dado que o usuário está na página "Transferências"
    E a conta possui saldo de R$ 5.000,00

  Scenario: Transferência bem‑sucedida para conta válida
    When preencho o campo "Conta de Destino" com "987654321"
    And preencho o campo "Valor" com "500,00"
    And clica em "Confirmar Transferência"
    Then devo ver a mensagem "Transferência concluída com sucesso"
    And o saldo da conta de origem deve diminuir em R$ 500,00
    And a conta de destino deve receber R$ 500,00

  Scenario: Transferência falha por saldo insuficiente
    When preencho o campo "Conta de Destino" com "987654321"
    And preencho o campo "Valor" com "10.000,00"
    And clica em "Confirmar Transferência"
    Then devo ver a mensagem "Saldo insuficiente"

  Scenario: Transferência falha quando conta de destino não existe
    When preencho o campo "Conta de Destino" com "000000000"
    And preencho o campo "Valor" com "100,00"
    And clica em "Confirmar Transferência"
    Then devo ver a mensagem "Conta de destino inválida"

  Scenario: Transferência falha por valor negativo
    When preencho o campo "Conta de Destino" com "987654321"
    And preencho o campo "Valor" com "-200,00"
    And clica em "Confirmar Transferência"
    Then devo ver a mensagem "Valor deve ser positivo"

# ==============================================================
# 5 – Solicitação de Empréstimo
# ==============================================================
Feature: Solicitação de Empréstimo
  Como cliente, eu quero solicitar um empréstimo
  Para obter recursos adicionais quando necessário.

  Background:
    Dado que o usuário está na página "Empréstimos"

  Scenario: Empréstimo aprovado quando renda ≥ 3× valor
    When preencho o campo "Valor do Empréstimo" com "2.000,00"
    And preencho o campo "Renda Anual" com "8.000,00"
    And clica em "Simular"
    Then devo ver a mensagem "Empréstimo Aprovado – crédito de R$ 2.000,00"
    And o registro aparece no histórico de solicitações

  Scenario: Empréstimo negado quando renda < 3× valor
    When preencho o campo "Valor do Empréstimo" com "2.000,00"
    And preencho o campo "Renda Anual" com "5.000,00"
    And clica em "Simular"
    Then devo ver a mensagem "Empréstimo Negado – renda insuficiente"
    And o registro aparece no histórico de solicitações

  Scenario: Empréstimo falha quando valor ou renda inválida
    When preencho o campo "Valor do Empréstimo" com "-1.000,00"
    And preencho o campo "Renda Anual" com "abc"
    And clica em "Simular"
    Then devo ver as mensagens de erro:
      | Campo                | Mensagem                     |
      | Valor do Empréstimo  | Valor deve ser positivo      |
      | Renda Anual          | Valor deve ser numérico      |

# ==============================================================
# 6 – Pagamento de Contas
# ==============================================================
Feature: Pagamento de Contas
  Como cliente, eu quero registrar e agendar pagamentos
  Para quitar contas de forma automatizada.

  Background:
    Dado que o usuário está na página "Pagamentos"

  Scenario: Pagamento agendado para data futura sem reduzir saldo imediatamente
    When preencho o campo "Beneficiário" com "José Pereira"
    And preencho o campo "Endereço" com "Av. Central, 200"
    And preencho o campo "Cidade" com "Rio de Janeiro"
    And preencho o campo "Estado" com "RJ"
    And preencho o campo "CEP" com "12345678"
    And preencho o campo "Telefone" com "(21) 99876-5432"
    And preencho o campo "Conta de Destino" com "123456789"
    And preencho o campo "Valor" com "150,00"
    And preencho o campo "Data de Pagamento" com "15/12/2025"
    And clica em "Agendar Pagamento"
    Then devo ver a mensagem "Pagamento de R$ 150,00 ao beneficiário José Pereira agendado para 15/12/2025"
    And o saldo da conta de origem não diminuiu ainda

  Scenario: Pagamento imediato reduz saldo imediatamente
    When preencho o campo "Valor" com "100,00"
    And preencho o campo "Data de Pagamento" com "01/11/2025"
    And clica em "Confirmar Pagamento"
    Then devo ver a mensagem "Pagamento de R$ 100,00 concluído"
    And o saldo da conta de origem diminuiu em R$ 100,00

  Scenario: Pagamento falha quando CEP inválido
    When preencho o campo "CEP" com "12A45678"
    And clica em "Agendar Pagamento"
    Then devo ver a mensagem "Formato inválido – por favor, insira 8 dígitos numéricos"

  Scenario: Pagamento falha quando campo obrigatório está vazio
    When deixo o campo "Beneficiário" em branco
    And clica em "Agendar Pagamento"
    Then devo ver a mensagem "Beneficiário é obrigatório"

# ==============================================================
# 7 – Navegação e Usabilidade Geral
# ==============================================================
Feature: Navegação e Usabilidade Geral
  Como usuário, eu quero que todas as páginas carreguem sem erros
  E que os menus sejam consistentes.

  Scenario: Todas as páginas carregam em ≤ 3 s em 3G
    When acesso a cada página do menu (Home, Conta, Transferências, Empréstimos, Pagamentos, Extrato, Ajuda)
    Then o tempo de carregamento deve ser ≤ 3 s

  Scenario: Todos os links do menu abrem a página correta
    When clica no link "Extrato" do menu
    Then devo ser redirecionado para a página "Extrato"

  Scenario: Botão “Sair” redireciona para login
    When clica em “Sair”
    Then devo ser redirecionado para a página de login

  Scenario: Mensagem amigável em erro 404
    When acessa uma URL inexistente
    Then devo ver a mensagem "O que aconteceu? Tente novamente"

# ==============================================================
# 8 – Mensagens de Erro e Validação de Dados
# ==============================================================
Feature: Mensagens de Erro e Validação de Dados
  Como usuário, eu quero receber mensagens claras quando digitar dados inválidos

  Scenario: Telefone com formato inválido
    When preencho o campo "Telefone" com "1234-5678"
    And perco foco no campo
    Then devo ver a mensagem "Formato inválido – por favor, insira (xx) xxxx‑xxxx ou +55 xxxx‑xxxx"

  Scenario: CEP com mais de 8 dígitos
    When preencho o campo "CEP" com "123456789"
    And perco foco no campo
    Then devo ver a mensagem "Formato inválido – por favor, insira 8 dígitos numéricos"

  Scenario: E‑mail sem “@” ou domínio
    When preencho o campo "E‑mail" com "usuarioexemplo.com"
    And perco foco no campo
    Then devo ver a mensagem "Formato inválido – por favor, insira e‑mail válido"

  Scenario: Data de pagamento no futuro (para pagamento) inválida
    When preencho o campo "Data de Pagamento" com "01/01/2100"
    And perco foco no campo
    Then devo ver a mensagem "Data não pode estar no futuro"

  Scenario: Valor monetário negativo ou maior que o máximo permitido
    When preencho o campo "Valor" com "-500,00"
    And perco foco no campo
    Then devo ver a mensagem "Valor deve ser positivo"
    When preencho o campo "Valor" com "1.000.000,00"
    And perco foco no campo
    Then devo ver a mensagem "Valor máximo permitido é 999 999,99"
```