```gherkin
# =============================================================
# US‑01 – Cadastro de Usuário
# =============================================================

@US-01
Feature: Cadastro de Usuário
  Como novo cliente do ParaBank
  Quero cadastrar minha conta no sistema
  Para que eu possa usar os serviços bancários

  Scenario: Cadastro com dados válidos
    Dado que eu esteja na tela de cadastro
    Quando eu preencho "Nome" com "João Silva"
    E eu preencho "E‑mail" com "joao.silva@example.com"
    E eu preencho "Senha" com "Senha123!"
    E eu preencho "Telefone" com "(11) 98765‑4321"
    E eu preencho "CEP" com "01234‑567"
    E eu preencho "Endereço" com "Rua A, 123"
    E eu preencho "Cidade" com "São Paulo"
    E eu preencho "Estado" com "SP"
    E eu preencho "CPF" com "123.456.789‑09"
    E eu clico em "Cadastrar"
    Então devo ver a mensagem "Cadastro realizado com sucesso"
    E devo ser redirecionado para a tela de login em 3 s

  Scenario: Cadastro sem preencher campo obrigatório
    Dado que eu esteja na tela de cadastro
    Quando eu preencho "Nome" com "Ana Maria"
    E eu deixo em branco o campo "E‑mail"
    E eu preencho "Senha" com "Senha123!"
    E eu preencho "Telefone" com "(11) 98765‑4321"
    E eu preencho "CEP" com "01234‑567"
    E eu preencho "Endereço" com "Rua B, 456"
    E eu preencho "Cidade" com "Rio de Janeiro"
    E eu preencho "Estado" com "RJ"
    E eu preencho "CPF" com "987.654.321‑00"
    E eu clico em "Cadastrar"
    Então devo ver a mensagem "Campo obrigatório" abaixo do campo "E‑mail"

  Scenario: Cadastro com e‑mail inválido
    Dado que eu esteja na tela de cadastro
    Quando eu preencho "Nome" com "Pedro Santos"
    E eu preencho "E‑mail" com "pedro.santos"
    E eu preencho "Senha" com "Senha123!"
    E eu preencho "Telefone" com "(11) 98765‑4321"
    E eu preencho "CEP" com "01234‑567"
    E eu preencho "Endereço" com "Av. C, 789"
    E eu preencho "Cidade" com "Belo Horizonte"
    E eu preencho "Estado" com "MG"
    E eu preencho "CPF" com "321.654.987‑10"
    E eu clico em "Cadastrar"
    Então devo ver a mensagem "E‑mail inválido" abaixo do campo "E‑mail"

  Scenario: Cadastro com CEP inválido
    Dado que eu esteja na tela de cadastro
    Quando eu preencho "Nome" com "Mariana Lima"
    E eu preencho "E‑mail" com "mariana.lima@example.com"
    E eu preencho "Senha" com "Senha123!"
    E eu preencho "Telefone" com "(11) 98765‑4321"
    E eu preencho "CEP" com "ABC-123"
    E eu preencho "Endereço" com "Rua D, 101"
    E eu preencho "Cidade" com "Curitiba"
    E eu preencho "Estado" com "PR"
    E eu preencho "CPF" com "456.123.789‑01"
    E eu clico em "Cadastrar"
    Então devo ver a mensagem "CEP inválido" abaixo do campo "CEP"

  Scenario: Cadastro com CPF inválido
    Dado que eu esteja na tela de cadastro
    Quando eu preencho "Nome" com "Carlos Eduardo"
    E eu preencho "E‑mail" com "carlos.e@example.com"
    E eu preencho "Senha" com "Senha123!"
    E eu preencho "Telefone" com "(11) 98765‑4321"
    E eu preencho "CEP" com "01234‑567"
    E eu preencho "Endereço" com "Avenida E, 202"
    E eu preencho "Cidade" com "Porto Alegre"
    E eu preencho "Estado" com "RS"
    E eu preencho "CPF" com "111.222.333‑44"
    E eu clico em "Cadastrar"
    Então devo ver a mensagem "CPF inválido" abaixo do campo "CPF"


# =============================================================
# US‑02 – Login
# =============================================================

@US-02
Feature: Login
  Como cliente já cadastrado
  Quero fazer login
  Para que eu acesse minha conta

  Scenario: Login com credenciais válidas
    Dado que eu esteja na tela de login
    E eu já tenha cadastro com e-mail "joao.silva@example.com" e senha "Senha123!"
    Quando eu preencho "E‑mail" com "joao.silva@example.com"
    E eu preencho "Senha" com "Senha123!"
    E eu clico em "Entrar"
    Então devo ser redirecionado para o dashboard
    E devo ver meu saldo atual

  Scenario: Login com e‑mail inexistente
    Dado que eu esteja na tela de login
    Quando eu preencho "E‑mail" com "naoexiste@example.com"
    E eu preencho "Senha" com "Senha123!"
    E eu clico em "Entrar"
    Então devo ver a mensagem "Usuário ou senha incorretos"

  Scenario: Login com senha incorreta
    Dado que eu esteja na tela de login
    Quando eu preencho "E‑mail" com "joao.silva@example.com"
    E eu preencho "Senha" com "SenhaErrada!"
    E eu clico em "Entrar"
    Então devo ver a mensagem "Usuário ou senha incorretos"

  Scenario: Login com campos vazios
    Dado que eu esteja na tela de login
    Quando eu deixo o campo "E‑mail" em branco
    E eu deixo o campo "Senha" em branco
    E eu clico em "Entrar"
    Então devo ver a mensagem "Campo obrigatório" abaixo do campo "E‑mail"
    E devo ver a mensagem "Campo obrigatório" abaixo do campo "Senha"


# =============================================================
# US‑03 – Dashboard – Saldo e Extrato
# =============================================================

@US-03
Feature: Dashboard – Saldo e Extrato
  Como cliente autenticado
  Quero ver meu saldo e extrato atualizados
  Para que eu tenha controle sobre minhas finanças

  Scenario: Exibir saldo e extrato após login
    Dado que eu esteja logado na minha conta
    Quando eu acesso o dashboard
    Então devo ver meu saldo atual refletindo todas as transações recentes
    E devo ver a lista das 5 transações mais recentes em ordem cronológica

  Scenario: Atualização de saldo em tempo real após transferência
    Dado que eu esteja logado e a minha conta tenha saldo de R$ 1.000,00
    Quando eu realizo uma transferência de R$ 200,00 para outra conta
    Então o saldo exibido no dashboard deve ser R$ 800,00 imediatamente


# =============================================================
# US‑04 – Transferência de Fundos
# =============================================================

@US-04
Feature: Transferência de Fundos
  Como cliente autenticado
  Quero transferir fundos entre minhas contas
  Para que eu possa mover dinheiro de forma segura

  Scenario: Transferência bem‑sucedida
    Dado que eu esteja logado e minha conta Corrente tenha saldo de R$ 500,00
    Quando eu abrir a tela "Transferir"
    E eu selecioar "Conta Corrente" como origem
    E eu selecioar "Conta Poupança" como destino
    E eu digitar "200,00" no campo Valor
    E eu clicar em "Confirmar"
    Então devo ver a mensagem "Transferência concluída com sucesso"
    E o saldo da conta Corrente deve ser R$ 300,00
    E o saldo da conta Poupança deve ser R$ 200,00
    E a transação deve aparecer no extrato das duas contas

  Scenario: Transferência com saldo insuficiente
    Dado que eu esteja logado e minha conta Corrente tenha saldo de R$ 150,00
    Quando eu abrir a tela "Transferir"
    E eu selecioar "Conta Corrente" como origem
    E eu selecioar "Conta Poupança" como destino
    E eu digitar "200,00" no campo Valor
    Então o botão "Confirmar" deve estar desabilitado
    E devo ver a mensagem "Saldo insuficiente" abaixo do campo Valor

  Scenario: Transferência para a própria conta
    Dado que eu esteja logado e minha conta Corrente tenha saldo de R$ 500,00
    Quando eu abrir a tela "Transferir"
    E eu selecioar "Conta Corrente" como origem
    E eu selecioar "Conta Corrente" como destino
    E eu digitar "100,00" no campo Valor
    Então devo ver a mensagem "Conta de origem e destino não podem ser iguais"

  Scenario: Transferência com valor negativo
    Dado que eu esteja logado e minha conta Corrente tenha saldo de R$ 500,00
    Quando eu abrir a tela "Transferir"
    E eu selecioar "Conta Corrente" como origem
    E eu selecioar "Conta Poupança" como destino
    E eu digitar "-50,00" no campo Valor
    Então devo ver a mensagem "Valor deve ser positivo"


# =============================================================
# US‑05 – Solicitação de Empréstimo
# =============================================================

@US-05
Feature: Solicitação de Empréstimo
  Como cliente autenticado
  Quero solicitar um empréstimo
  Para que eu possa obter crédito quando necessário

  Scenario: Solicitação aprovada com renda suficiente
    Dado que eu esteja logado
    Quando eu abrir a tela "Solicitar Empréstimo"
    E eu digitar "5.000,00" no campo "Valor"
    E eu digitar "80.000,00" no campo "Renda Anual"
    E eu clicar em "Enviar"
    Então devo ver a mensagem "Aprovado" em destaque
    E devo ver a justificativa "Renda suficiente"

  Scenario: Solicitação negada por renda insuficiente
    Dado que eu esteja logado
    Quando eu abrir a tela "Solicitar Empréstimo"
    E eu digitar "5.000,00" no campo "Valor"
    E eu digitar "30.000,00" no campo "Renda Anual"
    E eu clicar em "Enviar"
    Então devo ver a mensagem "Negado" em destaque
    E devo ver a justificativa "Renda insuficiente"


# =============================================================
# US‑06 – Pagamento de Contas
# =============================================================

@US-06
Feature: Pagamento de Contas
  Como cliente autenticado
  Quero registrar pagamentos de contas
  Para que eu mantenha meus débitos em dia

  Scenario: Agendar pagamento futuro
    Dado que eu esteja logado
    Quando eu abrir a tela "Pagamentos"
    E eu preencher "Beneficiário" com "Electric Co."
    E eu preencher "Endereço" com "Rua X, 123"
    E eu preencher "Cidade" com "São Paulo"
    E eu preencher "Estado" com "SP"
    E eu preencher "CEP" com "01234‑567"
    E eu preencher "Telefone" com "(11) 91234‑5678"
    E eu preencher "Conta de Destino" com "987654321"
    E eu preencher "Valor" com "150,00"
    E eu preencher "Data de Pagamento" com "2025‑12‑15"
    E eu clicar em "Agendar"
    Então devo ver a mensagem "Pagamento agendado para 15/12/2025"

  Scenario: Agendar pagamento com data passada
    Dado que eu esteja logado
    Quando eu abrir a tela "Pagamentos"
    E eu preencher "Beneficiário" com "Water Co."
    E eu preencher "Endereço" com "Av. Y, 456"
    E eu preencher "Cidade" com "Rio de Janeiro"
    E eu preencher "Estado" com "RJ"
    E eu preencher "CEP" com "12345‑678"
    E eu preencher "Telefone" com "(21) 98765‑4321"
    E eu preencher "Conta de Destino" com "123456789"
    E eu preencher "Valor" com "75,00"
    E eu preencher "Data de Pagamento" com "2020‑01‑01"
    E eu clicar em "Agendar"
    Então devo ver a mensagem "Data de pagamento inválida – deve ser futura"

  Scenario: Pagamento com campo obrigatório vazio
    Dado que eu esteja logado
    Quando eu abrir a tela "Pagamentos"
    E eu deixo em branco o campo "Beneficiário"
    E eu preencher "Endereço" com "Av. Z, 789"
    E eu preencher "Cidade" com "Belo Horizonte"
    E eu preencher "Estado" com "MG"
    E eu preencher "CEP" com "87654‑321"
    E eu preencher "Telefone" com "(31) 91234‑5678"
    E eu preencher "Conta de Destino" com "555555555"
    E eu preencher "Valor" com "100,00"
    E eu preencher "Data de Pagamento" com "2025‑10‑20"
    E eu clicar em "Agendar"
    Então devo ver a mensagem "Campo obrigatório" abaixo de "Beneficiário"


# =============================================================
# US‑07 – Navegação e Usabilidade
# =============================================================

@US-07
Feature: Navegação e Usabilidade
  Como usuário de qualquer página
  Quero que a navegação seja consistente e livre de erros
  Para que eu possa usar o sistema sem confusão

  Scenario: Todos os links de navegação são válidos
    Dado que eu esteja logado
    Quando eu clicar em "Home"
    Então devo ser redirecionado para o dashboard
    Quando eu clicar em "Saldo"
    Então devo permanecer no dashboard
    Quando eu clicar em "Extrato"
    Então devo ser redirecionado para a página de extrato
    Quando eu clicar em "Transferir"
    Então devo ser redirecionado para a tela de transferência
    Quando eu clicar em "Empréstimo"
    Então devo ser redirecionado para a tela de solicitação de empréstimo
    Quando eu clicar em "Pagamento"
    Então devo ser redirecionado para a tela de pagamento de contas
    Quando eu clicar em "Logout"
    Então devo ser redirecionado para a tela de login

  Scenario: Mensagens de erro aparecem perto do campo afetado
    Dado que eu esteja na tela de cadastro
    Quando eu deixo em branco o campo "Nome"
    E eu tento enviar o formulário
    Então a mensagem "Campo obrigatório" deve aparecer imediatamente abaixo do campo "Nome"


# =============================================================
# US‑08 – Segurança e Validação
# =============================================================

@US-08
Feature: Segurança e Validação
  Como desenvolvedor QA
  Quero que todas as validações sejam testáveis
  Para que eu garanta qualidade

  Scenario: API retorna 400 em requisição inválida
    Given Eu faço uma requisição POST /api/users com payload {"email":"invalid", "senha":"123"}
    When a resposta for retornada
    Then o status HTTP deve ser 400
    And o corpo JSON deve conter {"erro":"E‑mail inválido"}

  Scenario: API retorna 401 em requisição não autenticada
    Given Eu faço uma requisição GET /api/dashboard sem token
    When a resposta for retornada
    Then o status HTTP deve ser 401
    And o corpo JSON deve conter {"erro":"Não autenticado"}

  Scenario: Logs de erro não expõem dados sensíveis
    Given Um erro de validação ocorre ao tentar criar usuário com senha curta
    When o log de erro é registrado
    Then o log deve conter a mensagem "Senha curta" mas não deve conter a senha em texto plano

```