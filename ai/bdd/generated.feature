## Feature: US01 – Cadastro de Usuário  
**Como** potencial cliente do ParaBank, **eu quero** preencher um formulário de cadastro para criar minha conta no sistema, **para** ter acesso aos serviços bancários online.

---

### Cenário: Cadastro com dados válidos  
```gherkin
Dado que eu estou na página de cadastro  
Quando eu preencho "Nome completo" com "João da Silva"  
E preencho "Data de nascimento" com "01/01/1990"  
E preencho "Endereço" com "Rua A, 123"  
E preencho "CEP" com "12345678"  
E preencho "Telefone" com "11987654321"  
E preencho "E‑mail" com "joao@example.com"  
E preencho "Senha" com "Password123"  
E subo o formulário  
Então devo ver a mensagem "Cadastro concluído com sucesso"  
E devo ser redirecionado para a página de login  
Quando eu faço login com "joao@example.com" e "Password123"  
Então devo ser direcionado para o "Dashboard"  
E devo ver o saldo da minha conta
```

---

### Cenário: Cadastro com campo obrigatório vazio  
```gherkin
Cenário Outline: Cadastro com campo obrigatório em branco
  Dado que eu estou na página de cadastro
  Quando eu deixo "<campo>" em branco
  E preencho os demais campos com dados válidos
  E subo o formulário
  Então devo ver a mensagem de erro "Campo obrigatório" para "<campo>"

  Exemplos:
    | campo             |
    | Nome completo     |
    | Data de nascimento|
    | Endereço          |
    | CEP                |
    | Telefone           |
    | E‑mail             |
    | Senha              |
```

---

### Cenário: Validação de telefone  
```gherkin
Cenário Outline: Cadastro com telefone inválido
  Dado que eu estou na página de cadastro
  Quando eu preencho "Telefone" com "<valor>"
  E preencho os demais campos com dados válidos
  E subo o formulário
  Então devo ver a mensagem de erro "Telefone inválido"

  Exemplos:
    | valor        | Motivo                                 |
    | abcdefg      | Não é numérico                         |
    | 1234567      | Menos de 10 dígitos                    |
    | 123456789012 | Mais de 11 dígitos                     |
```

---

### Cenário: Validação de CEP  
```gherkin
Cenário Outline: Cadastro com CEP inválido
  Dado que eu estou na página de cadastro
  Quando eu preencho "CEP" com "<valor>"
  E preencho os demais campos com dados válidos
  E subo o formulário
  Então devo ver a mensagem de erro "CEP inválido"

  Exemplos:
    | valor     | Motivo           |
    | 1234      | Menos de 8 dígitos |
    | 123456789 | Mais de 8 dígitos   |
    | abcdefgh  | Não é numérico     |
```

---

### Cenário: Validação de e‑mail  
```gherkin
Cenário Outline: Cadastro com e‑mail inválido
  Dado que eu estou na página de cadastro
  Quando eu preencho "E‑mail" com "<valor>"
  E preencho os demais campos com dados válidos
  E subo o formulário
  Então devo ver a mensagem de erro "E‑mail inválido"

  Exemplos:
    | valor               | Motivo                     |
    | joao.com            | Falta @                     |
    | joao@                 | Falta domínio               |
    | joao@example          | Falta TLD                    |
```

---

## Feature: US02 – Login do Usuário  
**Como** cliente já cadastrado, **eu quero** autenticar-me no ParaBank com meu e‑mail e senha, **para** acessar minha conta e realizar operações.

---

### Cenário: Login com credenciais válidas  
```gherkin
Dado que eu estou na página de login
Quando eu preencho "E‑mail" com "joao@example.com"
E preencho "Senha" com "Password123"
E clico no botão "Login"
Então devo ser redirecionado para o "Dashboard"
E devo ver a mensagem de boas‑vindas
```

---

### Cenário: Login com e‑mail inexistente  
```gherkin
Dado que eu estou na página de login
Quando eu preencho "E‑mail" com "naoexiste@example.com"
E preencho "Senha" com "Password123"
E clico no botão "Login"
Então devo ver a mensagem "Credenciais inválidas. Por favor, tente novamente."
```

---

### Cenário: Login com senha errada  
```gherkin
Dado que eu estou na página de login
Quando eu preencho "E‑mail" com "joao@example.com"
E preencho "Senha" com "SenhaErrada"
E clico no botão "Login"
Então devo ver a mensagem "Credenciais inválidas. Por favor, tente novamente."
```

---

### Cenário: Botão de login desabilitado quando campos vazios  
```gherkin
Dado que eu estou na página de login
Quando eu deixo o campo "E‑mail" vazio
E deixo o campo "Senha" vazio
Então o botão "Login" deve estar desabilitado
E ao preencher apenas um dos campos, o botão continua desabilitado
```

---

## Feature: US03 – Visualização do Saldo e Extrato  
**Como** cliente autenticado, **eu quero** ver o saldo atual da minha conta e o extrato das transações recentes, **para** acompanhar minhas finanças em tempo real.

---

### Cenário: Exibição correta do saldo  
```gherkin
Dado que eu estou autenticado
E tenho saldo disponível de R$ 1.234,56
Quando eu acesse a página da conta
Então devo ver o saldo exibido como "R$ 1.234,56"
```

---

### Cenário: Atualização do saldo após transferência  
```gherkin
Dado que eu tenho saldo de R$ 1.000,00
E realizo uma transferência de R$ 200,00 para a conta "123456789"
Quando eu retorno à página da conta
Então o saldo exibido deve ser "R$ 800,00"
```

---

### Cenário: Lista de transações no extrato  
```gherkin
Dado que eu tenho 7 transações nas últimas 30 dias
Quando eu visualizo o extrato
Então devo ver pelo menos 5 transações
E todas devem estar ordenadas pelo campo "data" em ordem decrescente
```

---

### Cenário: Menos de 5 transações no extrato  
```gherkin
Dado que eu tenho 3 transações nas últimas 30 dias
Quando eu visualizo o extrato
Então devo ver todas as 3 transações
E nenhuma mensagem de “mais transações” aparece
```

---

## Feature: US04 – Transferência de Fundos  
**Como** cliente autenticado, **eu quero** transferir dinheiro de minha conta para outra conta bancária, **para** movimentar recursos entre contas de forma segura e automática.

---

### Cenário: Transferência bem‑sucedida com saldo suficiente  
```gherkin
Dado que eu tenho saldo de R$ 1.500,00
Quando eu faço transferência de R$ 300,00 para a conta "987654321"
Então o saldo da minha conta deve ser "R$ 1.200,00"
E o saldo da conta destino deve ser aumentado em R$ 300,00
E a transação aparece no extrato de ambas as contas com descrição apropriada
```

---

### Cenário: Transferência com valor zero  
```gherkin
Dado que eu tenho saldo de R$ 1.000,00
Quando eu tento transferir R$ 0,00
Então devo ver a mensagem de erro "Valor deve ser maior que zero"
```

---

### Cenário: Transferência com valor negativo  
```gherkin
Dado que eu tenho saldo de R$ 1.000,00
Quando eu tento transferir R$ -50,00
Então devo ver a mensagem de erro "Valor deve ser positivo"
```

---

### Cenário: Transferência sem saldo suficiente  
```gherkin
Dado que eu tenho saldo de R$ 200,00
Quando eu tento transferir R$ 300,00
Então devo ver a mensagem "Saldo insuficiente"
```

---

### Cenário: Transferência para conta inexistente  
*(Caso de negócio não define, mas adicionamos para cobertura)*  
```gherkin
Dado que eu tenho saldo de R$ 1.000,00
Quando eu tento transferir R$ 100,00 para a conta "000000000"
Então devo ver a mensagem "Conta de destino não encontrada"
```

---

## Feature: US05 – Solicitação de Empréstimo  
**Como** cliente autenticado, **eu quero** solicitar um empréstimo informando o valor desejado e minha renda anual, **para** avaliar se o banco aprovará o pedido e ter acesso ao montante solicitado.

---

### Cenário: Empréstimo aprovado  
```gherkin
Dado que minha renda anual é R$ 80.000,00
Quando eu solicito um empréstimo de R$ 10.000,00
Então devo ver a mensagem "Seu empréstimo de R$ 10.000,00 foi aprovado."
```

---

### Cenário: Empréstimo negado por renda insuficiente  
```gherkin
Dado que minha renda anual é R$ 15.000,00
Quando eu solicito um empréstimo de R$ 10.000,00
Então devo ver a mensagem "Seu empréstimo de R$ 10.000,00 foi negado. Motivo: renda insuficiente."
```

---

### Cenário: Valor do empréstimo fora do limite  
```gherkin
Dado que minha renda anual é R$ 200.000,00
Quando eu solicito um empréstimo de R$ 12.000.000,00
Então devo ver a mensagem de erro "Valor excede o limite máximo permitido (10.000.000,00)"
```

---

### Cenário: Renda anual inválida (zero ou negativa)  
```gherkin
Quando eu preencho "Renda anual" com "0,00"
E submeto a solicitação
Então devo ver a mensagem de erro "Renda anual deve ser maior que zero"

Quando eu preencho "Renda anual" com "-1000,00"
E submeto a solicitação
Então devo ver a mensagem de erro "Renda anual deve ser maior que zero"
```

---

## Feature: US06 – Pagamento de Contas  
**Como** cliente autenticado, **eu quero** registrar pagamentos de contas (bancos, serviços, etc.) informando beneficiário e dados da fatura, **para** garantir que as contas sejam salvas no histórico e que futuros pagamentos sejam agendados corretamente.

---

### Cenário: Pagamento imediato (data hoje)  
```gherkin
Dado que eu estou na página de pagamento de contas
Quando eu preencho todos os campos obrigatórios, incluindo "Data de pagamento" com a data de hoje
E confirmo o pagamento
Então devo ver a transação no extrato com data de hoje
E o saldo da conta de destino deve ser reduzido imediatamente
```

---

### Cenário: Pagamento futuro (agendamento)  
```gherkin
Dado que eu estou na página de pagamento de contas
Quando eu preencho todos os campos obrigatórios, incluindo "Data de pagamento" com uma data 5 dias à frente
E confirmo o pagamento
Então devo ver a transação no extrato com a data marcada
E o saldo da conta não é alterado agora
E no dia da data de pagamento, o saldo é automaticamente debitado
```

---

### Cenário: Data de pagamento passada  
```gherkin
Dado que eu estou na página de pagamento de contas
Quando eu preencho todos os campos obrigatórios, incluindo "Data de pagamento" com a data de ontem
E confirmo o pagamento
Então devo ver a mensagem de erro "Data inválida"
```

---

### Cenário: Valor do pagamento inválido (zero)  
```gherkin
Quando eu preencho "Valor" com "0,00"
E submeto o pagamento
Então devo ver a mensagem de erro "Valor deve ser maior que zero"
```

---

### Cenário: Valor do pagamento inválido (negativo)  
```gherkin
Quando eu preencho "Valor" com "-100,00"
E submeto o pagamento
Então devo ver a mensagem de erro "Valor deve ser positivo"
```

---

### Cenário: Campos obrigatórios ausentes  
```gherkin
Cenário Outline: Pagamento com campo obrigatório em branco
  Dado que eu estou na página de pagamento de contas
  Quando eu deixo "<campo>" em branco
  E preencho os demais campos com dados válidos
  E submeto o pagamento
  Então devo ver a mensagem de erro "Campo obrigatório"

  Exemplos:
    | campo           |
    | Beneficiário    |
    | Endereço        |
    | Cidade          |
    | Estado          |
    | CEP             |
    | Telefone        |
    | Conta de destino|
    | Valor           |
    | Data de pagamento |
```

---

## Feature: US07 – Navegação e Usabilidade Consistente  
**Como** usuário do ParaBank, **eu quero** navegar de forma intuitiva, com menus e links consistentes e mensagens de erro claras, **para** ter uma experiência de uso sem confusão e erros técnicos.

---

### Cenário: Navegação entre páginas em tempo aceitável  
```gherkin
Dado que eu estou em qualquer página do portal
Quando eu clico em qualquer link de menu (Home, Conta, Transferências, Empréstimos, Pagamentos, Logout)
Então a nova página deve carregar em ≤ 3 segundos
E não deve apresentar erro 404
```

---

### Cenário: Mensagens de erro em modal ou banner  
```gherkin
Dado que eu tento submeter um formulário com campos inválidos
Quando o sistema gera um erro
Então a mensagem de erro aparece em um modal ou banner com cor vermelha
E o texto da mensagem é claro e específico (ex.: "Campo obrigatório", "Saldo insuficiente", "Data inválida")
```

---

### Cenário: Responsividade da navegação  
```gherkin
Cenário Outline: Estrutura de navegação responsiva
  Dado que eu acesso a aplicação no dispositivo "<dispositivo>"
  Quando eu visualizo a barra de navegação
  Então os links devem estar visíveis e em ordem consistente
  E o layout deve se ajustar ao tamanho da tela

  Exemplos:
    | dispositivo |
    | desktop     |
    | tablet      |
    | mobile      |
```

---

### Cenário: Links de menu ativos e corretos  
```gherkin
Dado que eu estou em cada página (Home, Conta, Transferências, Empréstimos, Pagamentos, Logout)
Quando eu olho os links de menu
Então todos os links estão ativos
E cada link leva à página correta
```

---

> **Observação**: Cada cenário acima cobre tanto casos positivos quanto negativos, alinhando‑se aos critérios de aceitação de cada User Story. Eles são independentes e podem ser executados de forma incremental para garantir entregas contínuas e testabilidade.