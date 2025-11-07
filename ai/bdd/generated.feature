**US01 – Cadastro de Novo Cliente**  
```yaml
titulo: US01 – Cadastro de Novo Cliente
cenario_bdd:
  - nome: Cadastro com todos os campos válidos
    tipo: positivo
    gherkin: |
      Feature: Cadastro de Novo Cliente
        Scenario: Cadastro bem‑sucedido com todos os campos corretos
          Given o usuário navega até a página de cadastro
          When ele preenche nome completo com "Ana Maria Silva"
          And preenche data de nascimento com "1990-05-15"
          And preenche endereço com "Rua das Flores, 123, Centro, São Paulo, SP, 01010-001"
          And preenche telefone com "+55 11 91234-5678"
          And preenche e‑mail com "ana.silva@example.com"
          And preenche senha com "SenhaSegura123"
          And confirma senha com "SenhaSegura123"
          And clica no botão “Cadastrar”
          Then o sistema exibe a mensagem “Cadastro concluído. Você pode fazer login agora.”
          And o usuário deve ser elegível a fazer login

  - nome: Cadastro com campo obrigatório em branco
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Novo Cliente
        Scenario: Falha de cadastro por campo obrigatório em branco
          Given o usuário navega até a página de cadastro
          When ele deixa o campo “Nome completo” em branco
          And preenche os demais campos corretamente
          And clica no botão “Cadastrar”
          Then o sistema exibe a mensagem de erro “Nome completo é obrigatório” ao lado do campo correspondente

  - nome: Cadastro com CEP inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Novo Cliente
        Scenario: Falha de cadastro por CEP inválido
          Given o usuário navega até a página de cadastro
          When ele preenche endereço com "Rua das Flores, 123, Centro, São Paulo, SP, 0101-001"
          And preenche os demais campos corretamente
          And clica no botão “Cadastrar”
          Then o sistema exibe a mensagem de erro “CEP inválido” ao lado do campo CEP

  - nome: Cadastro com e‑mail inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Novo Cliente
        Scenario: Falha de cadastro por e‑mail inválido
          Given o usuário navega até a página de cadastro
          When ele preenche e‑mail com "ana.silva@exemplo"
          And preenche os demais campos corretamente
          And clica no botão “Cadastrar”
          Then o sistema exibe a mensagem de erro “Formato de e‑mail inválido” ao lado do campo e‑mail

  - nome: Cadastro com telefone inválido
    tipo: negativo
    gherkin: |
      Feature: Cadastro de Novo Cliente
        Scenario: Falha de cadastro por telefone inválido
          Given o usuário navega até a página de cadastro
          When ele preenche telefone com "12345"
          And preenche os demais campos corretamente
          And clica no botão “Cadastrar”
          Then o sistema exibe a mensagem de erro “Formato de telefone inválido” ao lado do campo telefone
```

---

**US02 – Login de Cliente Cadastrado**  
```yaml
titulo: US02 – Login de Cliente Cadastrado
cenario_bdd:
  - nome: Login bem‑sucedido
    tipo: positivo
    gherkin: |
      Feature: Login de Cliente
        Scenario: Usuário faz login com credenciais válidas
          Given o usuário está na página de login
          When ele insere e‑mail "ana.silva@example.com"
          And insere senha "SenhaSegura123"
          And clica em “Entrar”
          Then o sistema cria sessão para o usuário
          And redireciona para a página “Dashboard”

  - nome: Login falha por e‑mail inexistente
    tipo: negativo
    gherkin: |
      Feature: Login de Cliente
        Scenario: Falha de login por e‑mail inexistente
          Given o usuário está na página de login
          When ele insere e‑mail "nao.existe@example.com"
          And insere senha "SenhaSegura123"
          And clica em “Entrar”
          Then o sistema exibe a mensagem “Credenciais inválidas. Verifique e tente novamente.”

  - nome: Login falha por senha incorreta
    tipo: negativo
    gherkin: |
      Feature: Login de Cliente
        Scenario: Falha de login por senha incorreta
          Given o usuário está na página de login
          When ele insere e‑mail "ana.silva@example.com"
          And insere senha "SenhaErrada"
          And clica em “Entrar”
          Then o sistema exibe a mensagem “Credenciais inválidas. Verifique e tente novamente.”

  - nome: Expiração de sessão após 30 minutos de inatividade
    tipo: negativo
    gherkin: |
      Feature: Expiração de sessão
        Scenario: Sessão expira após 30 minutos de inatividade
          Given o usuário está autenticado e na página “Dashboard”
          And não interage com a aplicação por 30 minutos
          When o usuário tenta clicar em qualquer link
          Then o sistema redireciona para a página de login
          And exibe a mensagem “Sessão expirada. Por favor, faça login novamente.”
```

---

**US03 – Visualização de Saldo e Extrato**  
```yaml
titulo: US03 – Visualização de Saldo e Extrato
cenario_bdd:
  - nome: Exibição de saldo em moeda local com duas casas decimais
    tipo: positivo
    gherkin: |
      Feature: Visualização de Saldo
        Scenario: Usuário visualiza saldo corretamente formatado
          Given o usuário está autenticado na “Dashboard”
          When ele observa o campo “Saldo”
          Then o saldo aparece em moeda local, por exemplo “R$ 1.234,56”

  - nome: Exibição de extrato com pelo menos 10 transações recentes
    tipo: positivo
    gherkin: |
      Feature: Visualização de Extrato
        Scenario: Usuário visualiza extrato com transações recentes
          Given o usuário está autenticado na “Dashboard”
          When ele clica em “Ver Extrato”
          Then o sistema exibe uma lista com pelo menos 10 linhas
          And cada linha contém data, descrição, tipo (Crédito/Débito), valor e saldo pós‑transação
```

---

**US04 – Transferência de Fundos**  
```yaml
titulo: US04 – Transferência de Fundos
cenario_bdd:
  - nome: Transferência bem‑sucedida com saldo suficiente
    tipo: positivo
    gherkin: |
      Feature: Transferência de Fundos
        Scenario: Usuário transfere valor dentro do saldo disponível
          Given o usuário tem saldo de R$ 5.000,00 em “Conta A”
          And está na página de transferências
          When ele seleciona “Conta A” como origem
          And insere “12345678” como destino
          And digita valor “1.000,00”
          And confirma a transferência
          Then o saldo de “Conta A” diminui para R$ 4.000,00
          And o saldo de “Conta B” aumenta para R$ 1.000,00
          And o histórico de ambas as contas mostra a transação com status “Transferência concluída”

  - nome: Transferência falha por saldo insuficiente
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
        Scenario: Falha de transferência quando saldo insuficiente
          Given o usuário tem saldo de R$ 200,00 em “Conta A”
          And está na página de transferências
          When ele tenta transferir R$ 300,00
          And confirma a transferência
          Then o sistema exibe a mensagem “Saldo insuficiente para esta transferência”

  - nome: Transferência falha por valor negativo ou zero
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
        Scenario: Falha de transferência com valor inválido
          Given o usuário está na página de transferências
          When ele tenta transferir R$ -50,00
          Or tenta transferir R$ 0,00
          Then o sistema exibe a mensagem “Valor da transferência deve ser positivo”

  - nome: Transferência falha por destino inválido
    tipo: negativo
    gherkin: |
      Feature: Transferência de Fundos
        Scenario: Falha de transferência com destino inválido
          Given o usuário está na página de transferências
          When ele insere “ABC123” como código de destino
          And tenta transferir R$ 100,00
          Then o sistema exibe a mensagem “Código de destino inválido”
```

---

**US05 – Solicitação de Empréstimo**  
```yaml
titulo: US05 – Solicitação de Empréstimo
cenario_bdd:
  - nome: Empréstimo aprovado com renda suficiente
    tipo: positivo
    gherkin: |
      Feature: Solicitação de Empréstimo
        Scenario: Usuário solicita empréstimo e é aprovado
          Given o usuário está autenticado e na página de empréstimos
          When ele insere valor de empréstimo R$ 10.000,00
          And insere renda anual R$ 120.000,00
          And confirma a solicitação
          Then o sistema exibe “Aprovado – Parabéns! Seu empréstimo de R$ 10.000,00 foi aprovado.”
          And registra a solicitação no histórico de empréstimos

  - nome: Empréstimo negado por renda insuficiente
    tipo: negativo
    gherkin: |
      Feature: Solicitação de Empréstimo
        Scenario: Usuário solicita empréstimo e é negado
          Given o usuário está autenticado e na página de empréstimos
          When ele insere valor de empréstimo R$ 10.000,00
          And insere renda anual R$ 100.000,00
          And confirma a solicitação
          Then o sistema exibe “Negado – Renda insuficiente para o valor solicitado.”
          And registra a solicitação no histórico de empréstimos
```

---

**US06 – Registro de Pagamento de Contas**  
```yaml
titulo: US06 – Registro de Pagamento de Contas
cenario_bdd:
  - nome: Pagamento agendado para data futura
    tipo: positivo
    gherkin: |
      Feature: Registro de Pagamento
        Scenario: Usuário agenda pagamento para data futura
          Given o usuário está autenticado e na página de pagamentos
          When ele preenche beneficiário “Conta de Luz”
          And preenche endereço, cidade, estado, CEP e telefone corretamente
          And preenche número da conta de destino “987654321”
          And digita valor “150,00”
          And seleciona data de pagamento “2025-12-25”
          And confirma o pagamento
          Then o sistema exibe “Pagamento agendado para 25/12/2025”
          And o pagamento aparece no histórico como “Pagamento – Beneficiário Conta de Luz – R$ 150,00”

  - nome: Pagamento realizado imediatamente (hoje)
    tipo: positivo
    gherkin: |
      Feature: Registro de Pagamento
        Scenario: Usuário efetua pagamento na data de hoje
          Given o usuário está autenticado e na página de pagamentos
          When ele preenche os campos obrigatórios com data “2025-10-01” (hoje)
          And confirma o pagamento
          Then o sistema exibe “Pagamento realizado”
          And debita R$ 150,00 imediatamente
          And atualiza o saldo
          And registra o pagamento no histórico

  - nome: Falha de pagamento por data passada
    tipo: negativo
    gherkin: |
      Feature: Registro de Pagamento
        Scenario: Falha ao agendar pagamento com data no passado
          Given o usuário está autenticado e na página de pagamentos
          When ele seleciona data “2023-01-01”
          And tenta confirmar o pagamento
          Then o sistema exibe a mensagem “Data de pagamento não pode ser no passado”

  - nome: Falha de pagamento por valor zero
    tipo: negativo
    gherkin: |
      Feature: Registro de Pagamento
        Scenario: Falha ao registrar pagamento com valor zero
          Given o usuário está na página de pagamentos
          When ele digita valor “0,00”
          And tenta confirmar
          Then o sistema exibe a mensagem “Valor do pagamento deve ser positivo”

  - nome: Falha de pagamento por campo obrigatório faltando
    tipo: negativo
    gherkin: |
      Feature: Registro de Pagamento
        Scenario: Falha ao registrar pagamento sem preencher beneficiário
          Given o usuário está na página de pagamentos
          When ele deixa o campo “Beneficiário” em branco
          And tenta confirmar
          Then o sistema exibe “Beneficiário é obrigatório”
```

---

**US07 – Navegação Consistente e Usabilidade**  
```yaml
titulo: US07 – Navegação Consistente
cenario_bdd:
  - nome: Header contém logo, menu principal e links corretos
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
        Scenario: Verificação do Header em todas as páginas
          Given o usuário navega em qualquer página da aplicação
          Then o header exibe o logo da empresa
          And exibe menu principal com “Login”, “Cadastro” e “Dashboard”

  - nome: Footer contém links úteis
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
        Scenario: Verificação do Footer em todas as páginas
          Given o usuário navega em qualquer página da aplicação
          Then o footer exibe links “Contato”, “Políticas” e “FAQ”

  - nome: Exibição de mensagem de erro 404 em modal
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
        Scenario: Usuário acessa URL inexistente
          Given o usuário digita “/pagina-inexistente”
          When ele tenta acessar
          Then o sistema exibe um modal com mensagem “Página não encontrada”

  - nome: Tempo de carregamento menor que 2 s em rede 3G
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
        Scenario: Tempo de carregamento da aplicação
          Given o usuário está em rede 3G
          When ele carrega qualquer página
          Then o tempo total de carregamento é inferior a 2 segundos

  - nome: Layout responsivo em dispositivos mobile
    tipo: positivo
    gherkin: |
      Feature: Navegação Consistente
        Scenario: Layout adapta-se a telas menores
          Given o usuário abre a aplicação em um dispositivo com largura < 768px
          When ele visualiza a página
          Then os elementos se reorganizam para visualização mobile
```

---