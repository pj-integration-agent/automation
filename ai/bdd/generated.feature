**US01 – Cadastro de Usuário**  
```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: Registro com todos os campos válidos,
    tipo: positivo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Registro com todos os campos válidos\n  Given I am on the registration page\n  When I enter \"João Silva\" in the name field\n  And I enter \"12345678901\" in the CPF field\n  And I enter \"01/01/1990\" in the birth date field\n  And I enter \"(11) 98765-4321\" in the phone field\n  And I enter \"12345678\" in the ZIP code field\n  And I enter \"Rua Exemplo, 100\" in the address field\n  And I enter \"joao.silva@example.com\" in the email field\n  And I enter \"Password123\" in the password field\n  And I confirm \"Password123\" in the confirm password field\n  And I click the submit button\n  Then I should see the message \"Cadastro concluído com sucesso. Você pode agora fazer login.\""
```

```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: Telefone inválido com 9 dígitos,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Telefone inválido com 9 dígitos\n  Given I am on the registration page\n  When I enter \"(11) 9876-543\" in the phone field\n  And I fill all other required fields with valid data\n  And I click the submit button\n  Then I should see the error message \"Telefone inválido – insira 10 ou 11 dígitos\" below the phone field"
```

```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: CEP inválido com 7 dígitos,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: CEP inválido com 7 dígitos\n  Given I am on the registration page\n  When I enter \"1234567\" in the ZIP code field\n  And I fill all other required fields with valid data\n  And I click the submit button\n  Then I should see the error message \"CEP inválido – insira 8 dígitos\" below the ZIP code field"
```

```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: E‑mail inválido sem domínio,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: E‑mail inválido sem domínio\n  Given I am on the registration page\n  When I enter \"joao.silva@\" in the email field\n  And I fill all other required fields with valid data\n  And I click the submit button\n  Then I should see the error message \"E‑mail inválido\" below the email field"
```

```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: Senha e confirmação diferentes,
    tipo: negativo,
    gherkin: "Feature: Cadastro de Usuário\nScenario: Senha e confirmação diferentes\n  Given I am on the registration page\n  When I enter \"Password123\" in the password field\n  And I confirm \"Password321\" in the confirm password field\n  And I fill all other required fields with valid data\n  And I click the submit button\n  Then I should see the error message \"Senhas não correspondem\" below the confirm password field"
```

```
titulo: Cadastro de Usuário,
cenario_bdd:
    nome: Registro completo seguido de login imediato,
    tipo: positivo,
    gherkin: "Feature: Cadastro e Login\nScenario: Registro completo seguido de login imediato\n  Given I have successfully registered with valid data\n  When I navigate to the login page\n  And I enter the registered email \"joao.silva@example.com\" in the email field\n  And I enter the password \"Password123\" in the password field\n  And I click the login button\n  Then I should be redirected to the Dashboard\n  And I should see the message \"Olá, João\" in the top bar"
```

---

**US02 – Login**  
```
titulo: Login,
cenario_bdd:
    nome: Login com credenciais válidas,
    tipo: positivo,
    gherkin: "Feature: Login\nScenario: Login com credenciais válidas\n  Given I am on the login page\n  When I enter \"joao.silva@example.com\" in the email field\n  And I enter \"Password123\" in the password field\n  And I click the login button\n  Then I should be redirected to the Dashboard\n  And I should see the message \"Olá, João\" in the top bar"
```

```
titulo: Login,
cenario_bdd:
    nome: Login com credenciais inválidas,
    tipo: negativo,
    gherkin: "Feature: Login\nScenario: Login com credenciais inválidas\n  Given I am on the login page\n  When I enter \"joao.silva@example.com\" in the email field\n  And I enter \"WrongPass\" in the password field\n  And I click the login button\n  Then I should see the error message \"E‑mail ou senha incorretos. Tente novamente.\""
```

```
titulo: Login,
cenario_bdd:
    nome: Login com campo de e‑mail vazio,
    tipo: negativo,
    gherkin: "Feature: Login\nScenario: Login com campo de e‑mail vazio\n  Given I am on the login page\n  When I leave the email field blank\n  And I enter \"Password123\" in the password field\n  And I click the login button\n  Then I should see the error message \"E‑mail ou senha incorretos. Tente novamente.\""
```

---

**US03 – Acesso à Conta (Saldo e Extrato)**  
```
titulo: Acesso à Conta,
cenario_bdd:
    nome: Exibição do saldo atual na Dashboard,
    tipo: positivo,
    gherkin: "Feature: Acesso à Conta\nScenario: Exibição do saldo atual na Dashboard\n  Given I am logged in and on the Dashboard\n  Then I should see my current account balance displayed prominently"
```

```
titulo: Acesso à Conta,
cenario_bdd:
    nome: Exibir extrato com pelo menos 10 transações,
    tipo: positivo,
    gherkin: "Feature: Acesso à Conta\nScenario: Exibir extrato com pelo menos 10 transações\n  Given I am logged in and click \"Extrato\"\n  Then I should see a list containing at least 10 transaction entries sorted from most recent to oldest"
```

```
titulo: Acesso à Conta,
cenario_bdd:
    nome: Mensagem quando não há transações,
    tipo: negativo,
    gherkin: "Feature: Acesso à Conta\nScenario: Mensagem quando não há transações\n  Given I am logged in and my account has zero transactions\n  And I click \"Extrato\"\n  Then I should see the message \"Nenhuma transação encontrada\""
```

```
titulo: Acesso à Conta,
cenario_bdd:
    nome: Filtrar extrato por intervalo de datas,
    tipo: positivo,
    gherkin: "Feature: Acesso à Conta\nScenario: Filtrar extrato por intervalo de datas\n  Given I am logged in and click \"Extrato\"\n  When I set the start date to \"01/01/2024\"\n  And I set the end date to \"31/01/2024\"\n  And I apply the filter\n  Then I should see only transactions dated between 01/01/2024 and 31/01/2024"
```

---

**US04 – Transferência de Fundos**  
```
titulo: Transferência de Fundos,
cenario_bdd:
    nome: Transferência com saldo suficiente,
    tipo: positivo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência com saldo suficiente\n  Given I am logged in and have a balance of at least R$200\n  And I navigate to the Transfer page\n  When I select my checking account as origin\n  And I select my savings account as destination\n  And I enter \"100\" as the amount\n  And I confirm the transfer\n  Then I should see the message \"Transferência realizada com sucesso\"\n  And the origin account balance should decrease by 100\n  And the destination account balance should increase by 100\n  And the transaction should appear in both accounts’ extrato"
```

```
titulo: Transferência de Fundos,
cenario_bdd:
    nome: Transferência com saldo insuficiente,
    tipo: negativo,
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência com saldo insuficiente\n  Given I am logged in and have a balance of R$50\n  And I navigate to the Transfer page\n  When I select my checking account as origin\n  And I select my savings account as destination\n  And I enter \"100\" as the amount\n  And I confirm the transfer\n  Then I should see the error message \"Saldo insuficiente\" and no transaction should be recorded"
```

---

**US05 – Solicitação de Empréstimo**  
```
titulo: Solicitação de Empréstimo,
cenario_bdd:
    nome: Empréstimo aprovado por renda suficiente,
    tipo: positivo,
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo aprovado por renda suficiente\n  Given I am logged in and navigate to the Loan page\n  When I enter \"5000\" as loan amount\n  And I enter \"60000\" as annual income\n  And I submit the request\n  Then I should see the message \"Empréstimo aprovado\"\n  And the loan record should be saved in my loan history"
```

```
titulo: Solicitação de Empréstimo,
cenario_bdd:
    nome: Empréstimo negado por renda insuficiente,
    tipo: negativo,
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Empréstimo negado por renda insuficiente\n  Given I am logged in and navigate to the Loan page\n  When I enter \"5000\" as loan amount\n  And I enter \"12000\" as annual income\n  And I submit the request\n  Then I should see the message \"Empréstimo negado – renda insuficiente\"\n  And no loan record should be created"
```

```
titulo: Solicitação de Empréstimo,
cenario_bdd:
    nome: Visualizar histórico de empréstimos,
    tipo: positivo,
    gherkin: "Feature: Solicitação de Empréstimo\nScenario: Visualizar histórico de empréstimos\n  Given I have previously requested a loan\n  And I am logged in and navigate to the Loans section\n  Then I should see my past loan requests listed with status and dates"
```

---

**US06 – Pagamento de Contas**  
```
titulo: Pagamento de Contas,
cenario_bdd:
    nome: Pagamento registrado com sucesso,
    tipo: positivo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento registrado com sucesso\n  Given I am logged in and navigate to the Payments page\n  When I enter \"Conta de Luz\" as beneficiary\n  And I provide address, city, state, \"12345678\" as CEP, \"(11) 91234-5678\" as phone\n  And I select my checking account as destination\n  And I enter \"200\" as amount\n  And I set the payment date to tomorrow\n  And I confirm the payment\n  Then I should see the message \"Pagamento registrado com sucesso\"\n  And the payment should appear in the extrato with status \"Pendente\""
```

```
titulo: Pagamento de Contas,
cenario_bdd:
    nome: Data inválida (passado) ao registrar pagamento,
    tipo: negativo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Data inválida (passado) ao registrar pagamento\n  Given I am logged in and navigate to the Payments page\n  When I set the payment date to yesterday\n  And I attempt to confirm the payment\n  Then I should see the error message \"Data inválida – não pode ser anterior a hoje\""
```

```
titulo: Pagamento de Contas,
cenario_bdd:
    nome: Pagamento aparece no extrato com status Pendente,
    tipo: positivo,
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento aparece no extrato com status Pendente\n  Given I have scheduled a future payment\n  And I navigate to the Extrato page\n  Then I should see the payment entry with status \"Pendente\" and the scheduled date"
```

---

**US07 – Navegação & Usabilidade**  
```
titulo: Navegação & Usabilidade,
cenario_bdd:
    nome: Menu principal visível em todas as páginas,
    tipo: positivo,
    gherkin: "Feature: Navegação & Usabilidade\nScenario: Menu principal visível em todas as páginas\n  Given I am logged in\n  When I navigate to any page (Dashboard, Extrato, Transfer, Loan, Payments)\n  Then the main menu with links to Login, Cadastro, Dashboard, Extrato, Transferência, Empréstimo, Pagamentos should be present"
```

```
titulo: Navegação & Usabilidade,
cenario_bdd:
    nome: Links de navegação levam à página correta,
    tipo: positivo,
    gherkin: "Feature: Navegação & Usabilidade\nScenario: Links de navegação levam à página correta\n  Given I am on the Dashboard\n  When I click the \"Extrato\" link\n  Then I should be on the Extrato page\n  And the URL should contain \"/extrato\"\n  And there should be no 404 or navigation error"
```

```
titulo: Navegação & Usabilidade,
cenario_bdd:
    nome: Mensagem de erro exibida imediatamente abaixo do campo obrigatório em branco,
    tipo: negativo,
    gherkin: "Feature: Navegação & Usabilidade\nScenario: Mensagem de erro exibida imediatamente abaixo do campo obrigatório em branco\n  Given I am on the registration page\n  And I leave the CPF field empty\n  When I attempt to submit the form\n  Then I should see the error message \"CPF é obrigatório\" displayed directly below the CPF field"
```

```
titulo: Navegação & Usabilidade,
cenario_bdd:
    nome: Layout responsivo adapta-se a diferentes larguras de tela,
    tipo: positivo,
    gherkin: "Feature: Navegação & Usabilidade\nScenario: Layout responsivo adapta-se a diferentes larguras de tela\n  Given I open the application on a device with width 320px\n  Then all UI elements should be visible and usable\n  And I repeat the test on a device with width 1920px\n  Then the layout should remain functional and aesthetically consistent"
```

---