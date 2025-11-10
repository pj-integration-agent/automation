titulo: US01 - Cadastro de Usuário,  
cenario_bdd:  
    nome: Cadastro com dados válidos,  
    tipo: positivo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário registra conta com dados completos e válidos\n    Given o usuário está na página de cadastro\n    When ele preenche o nome completo, e‑mail válido, telefone nacional, CEP no formato XXXXX‑XXX, endereço, senha e confirmação de senha\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem \"Cadastro concluído com sucesso\"\n    And o usuário pode prosseguir para a página de login\n\n",  
cenario_bdd:  
    nome: Cadastro com campo obrigatório vazio,  
    tipo: negativo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário tenta cadastrar sem preencher campo obrigatório\n    Given o usuário está na página de cadastro\n    When ele deixa o campo \"Telefone\" vazio e preenche os demais campos corretamente\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem de erro \"Telefone é obrigatório\" ao lado do campo\n\n",  
cenario_bdd:  
    nome: Cadastro com e‑mail inválido,  
    tipo: negativo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário tenta cadastrar com e‑mail em formato inválido\n    Given o usuário está na página de cadastro\n    When ele preenche o e‑mail com \"usuario.com\" e preenche os demais campos corretamente\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem de erro \"Formato de e‑mail inválido\" ao lado do campo\n\n",  
cenario_bdd:  
    nome: Cadastro com telefone no formato errado,  
    tipo: negativo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário tenta cadastrar com telefone fora do padrão nacional\n    Given o usuário está na página de cadastro\n    When ele preenche o telefone com \"1234567\" e preenche os demais campos corretamente\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem de erro \"Formato de telefone inválido\" ao lado do campo\n\n",  
cenario_bdd:  
    nome: Cadastro com CEP inválido,  
    tipo: negativo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário tenta cadastrar com CEP fora do formato XXXXX‑XXX\n    Given o usuário está na página de cadastro\n    When ele preenche o CEP com \"123456\" e preenche os demais campos corretamente\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem de erro \"Formato de CEP inválido\" ao lado do campo\n\n",  
cenario_bdd:  
    nome: Cadastro com senha e confirmação divergentes,  
    tipo: negativo,  
    gherkin: "Feature: Cadastro de Usuário\n  Scenario: Usuário tenta cadastrar com senhas diferentes\n    Given o usuário está na página de cadastro\n    When ele preenche a senha com \"Senha123!\" e a confirmação com \"Senha321!\"\n    And preenche os demais campos corretamente\n    And ele clica em \"Cadastrar\"\n    Then o sistema exibe a mensagem de erro \"Senhas não coincidem\" ao lado do campo de confirmação\n\n",  

titulo: US02 - Login,  
cenario_bdd:  
    nome: Login com credenciais válidas,  
    tipo: positivo,  
    gherkin: "Feature: Login de Usuário\n  Scenario: Usuário faz login com e‑mail e senha corretos\n    Given o usuário está na página de login\n    When ele digita o e‑mail cadastrado e a senha correspondente\n    And ele clica em \"Entrar\"\n    Then o usuário é redirecionado para o dashboard da conta\n\n",  
cenario_bdd:  
    nome: Login com e‑mail inválido,  
    tipo: negativo,  
    gherkin: "Feature: Login de Usuário\n  Scenario: Usuário tenta fazer login com e‑mail que não existe\n    Given o usuário está na página de login\n    When ele digita um e‑mail não cadastrado e uma senha válida\n    And ele clica em \"Entrar\"\n    Then o sistema exibe a mensagem \"E‑mail ou senha inválidos\"\n\n",  
cenario_bdd:  
    nome: Login com senha inválida,  
    tipo: negativo,  
    gherkin: "Feature: Login de Usuário\n  Scenario: Usuário tenta fazer login com senha errada\n    Given o usuário está na página de login\n    When ele digita o e‑mail correto e a senha incorreta\n    And ele clica em \"Entrar\"\n    Then o sistema exibe a mensagem \"E‑mail ou senha inválidos\"\n\n",  
cenario_bdd:  
    nome: Login com campos vazios,  
    tipo: negativo,  
    gherkin: "Feature: Login de Usuário\n  Scenario: Usuário tenta fazer login sem preencher os campos\n    Given o usuário está na página de login\n    When ele deixa os campos de e‑mail e senha vazios\n    And ele clica em \"Entrar\"\n    Then o sistema exibe a mensagem de erro \"Campos obrigatórios\" ao lado de cada campo\n\n",  
cenario_bdd:  
    nome: Recuperação de senha,  
    tipo: positivo,  
    gherkin: "Feature: Recuperação de Senha\n  Scenario: Usuário clica no link \"Esqueci minha senha\"\n    Given o usuário está na página de login\n    When ele clica em \"Esqueci minha senha\"\n    Then o sistema redireciona para a página de recuperação de senha\n    And exibe o campo para inserir o e‑mail\n\n",  

titulo: US03 - Visualização de saldo e extrato,  
cenario_bdd:  
    nome: Exibir saldo e extrato completo,  
    tipo: positivo,  
    gherkin: "Feature: Dashboard de Conta\n  Scenario: Usuário visualiza saldo e extrato após login\n    Given o usuário está autenticado e na página do dashboard\n    When ele observa o saldo exibido em destaque\n    Then o saldo corresponde ao valor atual da conta\n    And o extrato lista pelo menos 10 transações ordenadas cronologicamente\n    And cada linha exibe data, descrição, valor e saldo pós‑transação\n\n",  
cenario_bdd:  
    nome: Exibir detalhe da transação ao clicar,  
    tipo: positivo,  
    gherkin: "Feature: Detalhe de Transação\n  Scenario: Usuário clica em uma linha do extrato para ver detalhes\n    Given o usuário está no dashboard e há um extrato exibido\n    When ele clica na transação com descrição \"Transferência interna\"\n    Then o sistema abre o modal de detalhes com data, descrição, valor, saldo anterior e posterior\n\n",  

titulo: US04 - Transferência de fundos,  
cenario_bdd:  
    nome: Transferência entre contas com saldo suficiente,  
    tipo: positivo,  
    gherkin: "Feature: Transferência de Fundos\n  Scenario: Usuário transfere valor dentro do limite de saldo\n    Given o usuário está autenticado e na tela de transferência\n    And ele tem saldo de R$ 1.000,00 na conta A\n    When ele seleciona conta A como origem, conta B como destino\n    And insere o valor \"R$ 200,00\"\n    And confirma a transferência\n    Then o sistema debita R$ 200,00 da conta A e credita R$ 200,00 na conta B\n    And exibe a mensagem de sucesso \"Transferência concluída\"\n    And a transação aparece no extrato de ambas as contas\n\n",  
cenario_bdd:  
    nome: Transferência excedendo saldo disponível,  
    tipo: negativo,  
    gherkin: "Feature: Transferência de Fundos\n  Scenario: Usuário tenta transferir um valor maior que o saldo\n    Given o usuário está autenticado e na tela de transferência\n    And ele tem saldo de R$ 100,00 na conta A\n    When ele seleciona conta A como origem, conta B como destino\n    And insere o valor \"R$ 200,00\"\n    And confirma a transferência\n    Then o sistema exibe a mensagem de erro \"Saldo insuficiente\"\n    And nenhuma alteração é feita nos saldos\n\n",  
cenario_bdd:  
    nome: Transferência com valor negativo,  
    tipo: negativo,  
    gherkin: "Feature: Transferência de Fundos\n  Scenario: Usuário tenta inserir valor negativo na transferência\n    Given o usuário está na tela de transferência\n    When ele insere o valor \"-R$ 50,00\"\n    And tenta confirmar a transferência\n    Then o sistema exibe a mensagem de erro \"Valor deve ser positivo\"\n\n",  

titulo: US05 - Solicitação de Empréstimo,  
cenario_bdd:  
    nome: Solicitar empréstimo com aprovação,  
    tipo: positivo,  
    gherkin: "Feature: Solicitação de Empréstimo\n  Scenario: Usuário solicita empréstimo que atende critérios de aprovação\n    Given o usuário está autenticado e na página de solicitação de empréstimo\n    When ele insere o valor \"R$ 5.000,00\" e renda anual \"R$ 120.000,00\"\n    And confirma a solicitação\n    Then o sistema exibe a mensagem \"Empréstimo Aprovado\" com taxa e prazo\n\n",  
cenario_bdd:  
    nome: Solicitar empréstimo com renda insuficiente,  
    tipo: negativo,  
    gherkin: "Feature: Solicitação de Empréstimo\n  Scenario: Usuário solicita empréstimo que não atende critérios de renda\n    Given o usuário está autenticado e na página de solicitação de empréstimo\n    When ele insere o valor \"R$ 10.000,00\" e renda anual \"R$ 30.000,00\"\n    And confirma a solicitação\n    Then o sistema exibe a mensagem \"Empréstimo Negado\" com justificativa\n\n",  
cenario_bdd:  
    nome: Solicitação de empréstimo com campo vazio,  
    tipo: negativo,  
    gherkin: "Feature: Solicitação de Empréstimo\n  Scenario: Usuário tenta solicitar empréstimo sem preencher a renda\n    Given o usuário está na página de solicitação de empréstimo\n    When ele preenche apenas o valor e deixa a renda em branco\n    And confirma a solicitação\n    Then o sistema exibe a mensagem de erro \"Renda anual é obrigatória\"\n\n",  

titulo: US06 - Pagamento de contas,  
cenario_bdd:  
    nome: Registrar pagamento com data de hoje,  
    tipo: positivo,  
    gherkin: "Feature: Pagamento de Contas\n  Scenario: Usuário agenda pagamento para a data atual\n    Given o usuário está autenticado e na página de pagamento de contas\n    When ele preenche beneficiário, endereço, cidade, estado, CEP válido, telefone, conta de destino, valor \"R$ 100,00\" e data \"Hoje\"\n    And confirma o pagamento\n    Then o sistema debita R$ 100,00 da conta imediatamente\n    And exibe a mensagem de confirmação com detalhes do pagamento\n    And a transação aparece no extrato\n\n",  
cenario_bdd:  
    nome: Registrar pagamento com data futura,  
    tipo: positivo,  
    gherkin: "Feature: Pagamento de Contas\n  Scenario: Usuário agenda pagamento para uma data futura\n    Given o usuário está autenticado e na página de pagamento de contas\n    When ele preenche todos os campos e define a data \"30/12/2025\"\n    And confirma o pagamento\n    Then o sistema marca a transação como \"pendente\"\n    And exibe a mensagem de confirmação com data de agendamento\n    And a transação aparece no extrato como pendente\n\n",  
cenario_bdd:  
    nome: Pagamento com CEP inválido,  
    tipo: negativo,  
    gherkin: "Feature: Pagamento de Contas\n  Scenario: Usuário tenta registrar pagamento com CEP incorreto\n    Given o usuário está na página de pagamento de contas\n    When ele preenche o CEP com \"123456\"\n    And confirma o pagamento\n    Then o sistema exibe a mensagem de erro \"Formato de CEP inválido\"\n\n",  
cenario_bdd:  
    nome: Pagamento com valor negativo,  
    tipo: negativo,  
    gherkin: "Feature: Pagamento de Contas\n  Scenario: Usuário tenta registrar pagamento com valor negativo\n    Given o usuário está na página de pagamento de contas\n    When ele insere o valor \"-R$ 50,00\"\n    And confirma o pagamento\n    Then o sistema exibe a mensagem de erro \"Valor deve ser positivo\"\n\n",  

titulo: US07 - Navegação e mensagens de erro,  
cenario_bdd:  
    nome: Navegar entre páginas via menu principal,  
    tipo: positivo,  
    gherkin: "Feature: Navegação do Sistema\n  Scenario: Usuário clica nos links do menu principal\n    Given o usuário está em qualquer página autenticada\n    When ele clica no link \"Dashboard\"\n    Then o sistema redireciona para a página do dashboard\n    And a navegação não gera erros 404 ou 500\n\n",  
cenario_bdd:  
    nome: Mensagem de erro visível em campo inválido,  
    tipo: positivo,  
    gherkin: "Feature: Mensagens de Erro\n  Scenario: Usuário entra em campo inválido na tela de cadastro\n    Given o usuário está na página de cadastro\n    When ele insere telefone no formato inválido\n    And tenta salvar\n    Then o sistema exibe a mensagem de erro diretamente ao lado do campo, visível e legível\n\n",  
cenario_bdd:  
    nome: Consistência de layout de navegação em dispositivos mobile,  
    tipo: positivo,  
    gherkin: "Feature: Responsividade\n  Scenario: Usuário acessa o site em um dispositivo mobile\n    Given o usuário abre o navegador em tela pequena\n    When ele navega entre as páginas usando o menu lateral\n    Then o layout do menu permanece consistente e funcional\n    And não há 404 ou 500 durante a navegação\n\n",  
cenario_bdd:  
    nome: Link inexistente gera mensagem de erro,  
    tipo: negativo,  
    gherkin: "Feature: Navegação\n  Scenario: Usuário tenta clicar em um link que não existe\n    Given o usuário está na página de dashboard\n    When ele clica em um link \"Conta inexistente\"\n    Then o sistema exibe a mensagem de erro \"Página não encontrada\"\n    And o usuário pode voltar ao dashboard via botão de voltar\n\n"