**UserFlowTests.robot** – Automated Robot Framework suite (BDD → Robot Framework)

```robot
*** Settings ***
Library           SeleniumLibrary    timeout=10
Library           Collections
Library           OperatingSystem
Library           BuiltIn
Suite Setup       Open Browser To Home Page
Suite Teardown    Close Browser
Test Setup        Prepare Test Environment
Test Teardown     Capture Page Screenshot

# Tags that help to filter by feature or by positive/negative flow
Metadata          Author            Senior Test Automation Engineer
Metadata          Language          Portuguese

*** Variables ***
# Base URL of the application
${BASE_URL}          https://examplebank.com

# Common locators (use data-test or id where possible)
${REG_PAGE}          ${BASE_URL}/register
${LOGIN_PAGE}        ${BASE_URL}/login
${DASHBOARD_PAGE}    ${BASE_URL}/dashboard
${TRANSFER_PAGE}     ${BASE_URL}/transfer
${LOAN_PAGE}         ${BASE_URL}/loan
${PAYMENT_PAGE}      ${BASE_URL}/payment

# Field locators – keep them stable (id or name)
${FULLNAME_FIELD}     id=fullName
${EMAIL_FIELD}        id=email
${PHONE_FIELD}        id=phone
${ZIP_FIELD}          id=zip
${PASS_FIELD}         id=password
${CONFIRM_PASS_FIELD} id=confirmPassword
${CREATE_BTN}         xpath=//button[normalize-space()='Criar Conta']
${LOGIN_BTN}          xpath=//button[normalize-space()='Login']
${SUBMIT_TRANSFER}    xpath=//button[normalize-space()='Confirmar Transferência']
${SUBMIT_LOAN}        xpath=//button[normalize-space()='Confirmar Solicitação']
${SUBMIT_PAYMENT}     xpath=//button[normalize-space()='Confirmar Pagamento']

# Error / success messages (text)
${MSG_EMAIL_SENT}          Mensagem de confirmação de e‑mail enviado
${MSG_REQ_FIELDS}          Preencha todos os campos obrigatórios
${MSG_INVALID_EMAIL}       Formato de e‑mail inválido
${MSG_INVALID_ZIP}         CEP inválido
${MSG_INVALID_PHONE}       Telefone deve conter apenas números
${MSG_PASS_MISMATCH}       As senhas não correspondem
${MSG_LOGIN_SUCCESS}       Dashboard
${MSG_INCORRECT_CRED}      Credenciais inválidas. Tente novamente.
${MSG_NO_TRANSACTIONS}     Nenhuma transação encontrada
${MSG_TRANSFER_OK}         Transferência concluída – Ref:
${MSG_TRANSFER_FAIL}       Saldo insuficiente
${MSG_TRANSFER_INVALID}    Valor de transferência inválido
${MSG_LOAN_APPROVED}       Empréstimo Aprovado – 12% ao ano
${MSG_LOAN_DENIED_R}       Empréstimo Negado – Renda insuficiente
${MSG_LOAN_DENIED_L}       Dados fora do limite permitido
${MSG_PAYMENT_SCHEDULED}   Pagamento agendado para
${MSG_PAYMENT_INVALID_DATE} Data inválida – escolha uma data futura
${MSG_REQUIRED_FIELD}       Campo obrigatório
${MSG_404}                  Página não encontrada

# Test data
${VALID_USER}          João da Silva
${VALID_EMAIL}         joao.silva@email.com
${VALID_PHONE}         11987654321
${VALID_ZIP}           12345678
${VALID_PASS}          Segura123
${INVALID_EMAIL}       joaosilva@com
${INVALID_ZIP}         12345
${INVALID_PHONE}       11987-5432a
${MISMATCH_PASS}       Segura321

*** Test Cases ***
# ===================================================================== #
# US01 – Cadastro de Usuário
# ===================================================================== #
Cadastro De Conta Com Dados Válidos
    [Tags]    US01    positive
    Go To Registration Page
    Fill Registration Form    ${VALID_USER}    ${VALID_EMAIL}    ${VALID_PHONE}
    ...                        ${VALID_ZIP}      ${VALID_PASS}    ${VALID_PASS}
    Click Create Account
    Verify Email Sent Confirmation
    Verify Redirect To Login

Usuário Tenta Cadastrar Sem Preencher Campos Obrigatórios
    [Tags]    US01    negative
    Go To Registration Page
    Click Create Account
    Verify Mandatory Fields Error

E‑mail Inválido
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_USER}    ${INVALID_EMAIL}    ${VALID_PHONE}
    ...                        ${VALID_ZIP}      ${VALID_PASS}    ${VALID_PASS}
    Click Create Account
    Verify Error Message Below Field    ${EMAIL_FIELD}    ${MSG_INVALID_EMAIL}

CEP Com Menos De 8 Dígitos
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_USER}    ${VALID_EMAIL}    ${VALID_PHONE}
    ...                        ${INVALID_ZIP}    ${VALID_PASS}    ${VALID_PASS}
    Click Create Account
    Verify Error Message Below Field    ${ZIP_FIELD}    ${MSG_INVALID_ZIP}

Telefone Com Caracteres Não Numéricos
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_USER}    ${VALID_EMAIL}    ${INVALID_PHONE}
    ...                        ${VALID_ZIP}      ${VALID_PASS}    ${VALID_PASS}
    Click Create Account
    Verify Error Message Below Field    ${PHONE_FIELD}    ${MSG_INVALID_PHONE}

Senhas Não Correspondem
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_USER}    ${VALID_EMAIL}    ${VALID_PHONE}
    ...                        ${VALID_ZIP}      ${VALID_PASS}    ${MISMATCH_PASS}
    Click Create Account
    Verify Error Message Below Field    ${CONFIRM_PASS_FIELD}    ${MSG_PASS_MISMATCH}

# ===================================================================== #
# US02 – Login
# ===================================================================== #
Login Bem‑Sucedido
    [Tags]    US02    positive
    Go To Login Page
    Input Credentials    ${VALID_EMAIL}    ${VALID_PASS}
    Click Login
    Verify Redirect To Dashboard
    Verify Balance Displayed

Login Com Credenciais Inválidas
    [Tags]    US02    negative
    Go To Login Page
    Input Credentials    ${VALID_EMAIL}    Errada123
    Click Login
    Verify Error Message Center    ${MSG_INCORRECT_CRED}

Login Com Campos Vazios
    [Tags]    US02    negative
    Go To Login Page
    # Leave fields blank
    Click Login
    Verify Error Message Below Field    ${EMAIL_FIELD}    ${MSG_REQUIRED_FIELD}
    Verify Error Message Below Field    ${PASS_FIELD}    ${MSG_REQUIRED_FIELD}

# ===================================================================== #
# US03 – Exibir Saldo e Extrato
# ===================================================================== #
Dashboard Exibe Saldo E Extrato Mínimo
    [Tags]    US03    positive
    Authenticate And Navigate To Dashboard
    Verify Balance Displayed
    Verify Transaction List Size    10
    Verify Each Transaction Contains    data    description    amount    type

Carregamento De Extrato Completo Ao Clicar Em “Ver Mais”
    [Tags]    US03    positive
    Go To Dashboard
    Verify Transaction List Size    10
    Click Element    xpath=//button[normalize-space()='Ver mais']
    Verify Additional Transactions Loaded

Mensagem De Saldo Quando Nenhuma Transação
    [Tags]    US03    negative
    Authenticate And Navigate To Dashboard Without Transactions
    Verify No Transactions Message

# ===================================================================== #
# US04 – Transferência de Fundos
# ===================================================================== #
Transferência Bem‑Sucedida Dentro Do Saldo Disponível
    [Tags]    US04    positive
    Authenticate And Navigate To Transfer Page
    Set Current Balance    5000.00
    Fill Transfer Form    Conta Corrente    Conta Poupança    1000.00
    Confirm Transfer
    Verify Transfer Success Message    Ref: 123456
    Verify Balance Updated    4000.00
    Verify Destination Account Balance    1000.00

Transferência Com Valor Superior Ao Saldo
    [Tags]    US04    negative
    Authenticate And Navigate To Transfer Page
    Set Current Balance    500.00
    Fill Transfer Form    Conta Corrente    Conta Poupança    1000.00
    Confirm Transfer
    Verify Error Message Center    ${MSG_TRANSFER_FAIL}

Transferência Com Valor Inválido (Nulo Ou Negativo)
    [Tags]    US04    negative
    Go To Transfer Page
    Input Transfer Value    -100.00
    Confirm Transfer
    Verify Error Message Center    ${MSG_TRANSFER_INVALID}

# ===================================================================== #
# US05 – Solicitação de Empréstimo
# ===================================================================== #
Empréstimo Aprovado
    [Tags]    US05    positive
    Authenticate And Navigate To Loan Page
    Fill Loan Form    200000    300000
    Confirm Loan
    Verify Loan Approval Message

Empréstimo Negado Por Renda Insuficiente
    [Tags]    US05    negative
    Authenticate And Navigate To Loan Page
    Fill Loan Form    100000    20000
    Confirm Loan
    Verify Loan Denial Message    ${MSG_LOAN_DENIED_R}

Empréstimo Negado Por Valor Acima Do Limite
    [Tags]    US05    negative
    Authenticate And Navegatar Para Loan Page
    Fill Loan Form    600000    500000
    Confirm Loan
    Verify Loan Denial Message    ${MSG_LOAN_DENIED_L}

# ===================================================================== #
# US06 – Pagamento de Contas
# ===================================================================== #
Pagamento Agendado Para Data Futura
    [Tags]    US06    positive
    Go To Payment Page
    Fill Payment Form    Pedro    Rua A, 123    São Paulo    SP    12345678
    ...                     11987654321    123456789    200.00    25/12/2025
    Confirm Payment
    Verify Payment Scheduled Message    25/12/2025
    Verify Payment In History    Agendado

Pagamento Com Data No Passado
    [Tags]    US06    negative
    Go To Payment Page
    Fill Payment Form    Pedro    Rua A, 123    São Paulo    SP    12345678
    ...                     11987654321    123456789    200.00    01/01/2020
    Confirm Payment
    Verify Error Message Below Field    //input[@name='paymentDate']    ${MSG_PAYMENT_INVALID_DATE}

Pagamento Com Campo Obrigatório Em Branco
    [Tags]    US06    negative
    Go To Payment Page
    Input Payment Beneficiary    # leave blank intentionally
    Fill Rest Of Payment Fields
    Confirm Payment
    Verify Error Message Below Field    //input[@name='beneficiary']    ${MSG_REQUIRED_FIELD}

# ===================================================================== #
# US07 – Navegação e Usabilidade
# ===================================================================== #
Menu Principal Presente Em Todas As Páginas
    [Tags]    US07    positive
    Go To Dashboard
    Verify Main Menu Contains    Dashboard    Transferir    Empréstimos
    ...                                      Pagamentos    Extrato    Sair

Navegação Sem Erros 404
    [Tags]    US07    positive
    Go To Dashboard
    Click Element    //a[normalize-space()='Transferir']
    Verify Current Page Contains    Transferência
    Verify Page Does Not Contain    404

Mensagens De Erro Em Vermelho Alinhadas Ao Campo
    [Tags]    US07    positive
    Go To Registration Page
    Clear Field    ${EMAIL_FIELD}
    Click Create Account
    Verify Error Message Color And Position    ${EMAIL_FIELD}    ${MSG_REQUIRED_FIELD}    red

Tempo De Carregamento Do Dashboard Menor Que 2 Segundos
    [Tags]    US07    positive
    Authenticate
    ${load_time}=    Measure Page Load Time    ${DASHBOARD_PAGE}
    Should Be True    ${load_time} < 2    msg=Dashboard load time exceeded 2 seconds

Menu Colapsa Em Dispositivos Móveis
    [Tags]    US07    positive
    Set Window Size    320    800
    Go To Home Page
    Verify Menu Is Collapsed
    Click Element    //button[@aria-label='Menu']
    Verify All Menu Options Visible

Página Retorna 404 Ao Acessar Link Inexistente
    [Tags]    US07    negative
    Go To URL    ${BASE_URL}/pagina-inexistente
    Verify Page Contains    ${MSG_404}
```

---

## Explanation of the Key Parts

### Settings
* `Suite Setup` opens a browser once per test‑suite and navigates to the home page.
* `Test Setup`/`Test Teardown` are used for pre‑test preparation (e.g., clean cookies) and for debugging screenshots.
* Tags (`US01`, `positive`, etc.) let you run only a subset of tests (`robot -t US01`).

### Variables
* Centralised locators and messages keep the suite maintainable: when the UI changes you only edit one place.
* Data‑driven variables (valid/invalid credentials, amounts, etc.) make the test data easy to read.

### Test Cases
* Each Gherkin scenario has its own Robot test case.
* Every step is mapped to a keyword that contains a concise, reusable implementation.
* Comments (the “Verify …” lines) clearly explain what each step is doing, which is a Robot‑friendly alternative to the Gherkin `#` comments.

### Keywords (Skeleton)

```robot
*** Keywords ***
Open Browser To Home Page
    Open Browser    ${BASE_URL}    Chrome
    Maximize Browser Window

Prepare Test Environment
    # Clear cookies, localStorage, etc., so tests are idempotent
    Delete All Cookies
    Page Should Contain Element    id=someHomeElement

Authenticate
    # Helper to login once and stay authenticated
    Go To Login Page
    Input Credentials    ${VALID_EMAIL}    ${VALID_PASS}
    Click Login
    Wait Until Page Contains    ${MSG_LOGIN_SUCCESS}    timeout=15

Go To Registration Page
    Go To    ${REG_PAGE}
    Wait Until Page Contains Element    ${FULLNAME_FIELD}

Go To Login Page
    Go To    ${LOGIN_PAGE}
    Wait Until Page Contains Element    ${EMAIL_FIELD}

Go To Dashboard
    Go To    ${DASHBOARD_PAGE}
    Wait Until Page Contains    ${MSG_LOGIN_SUCCESS}

Go To Transfer Page
    Go To    ${TRANSFER_PAGE}
    Wait Until Page Contains Element    ${CREATE_BTN}

Go To Loan Page
    Go To    ${LOAN_PAGE}
    Wait Until Page Contains Element    ${CREATE_BTN}

Go To Payment Page
    Go To    ${PAYMENT_PAGE}
    Wait Until Page Contains Element    ${CREATE_BTN}

Input Credentials
    [Arguments]    ${email}    ${password}
    Input Text    ${EMAIL_FIELD}    ${email}
    Input Text    ${PASS_FIELD}     ${password}

Click Login
    Click Button    ${LOGIN_BTN}

Click Create Account
    Click Button    ${CREATE_BTN}

Verify Email Sent Confirmation
    Page Should Contain    ${MSG_EMAIL_SENT}

Verify Redirect To Login
    Wait Until Page Contains    Login
    Page Should Contain    Login

Fill Registration Form
    [Arguments]    ${name}    ${email}    ${phone}    ${zip}
    ...              ${password}    ${confirmPassword}
    Input Text    ${FULLNAME_FIELD}    ${name}
    Input Text    ${EMAIL_FIELD}      ${email}
    Input Text    ${PHONE_FIELD}      ${phone}
    Input Text    ${ZIP_FIELD}        ${zip}
    Input Text    ${PASS_FIELD}       ${password}
    Input Text    ${CONFIRM_PASS_FIELD}   ${confirmPassword}

Verify Mandatory Fields Error
    [Arguments]    ${message}= ${MSG_REQ_FIELDS}
    # Assuming the page displays the message near each field
    Page Should Contain    ${message}

Verify Error Message Below Field
    [Arguments]    ${fieldLocator}    ${expectedMessage}
    Wait Until Element Is Visible    ${fieldLocator}_error
    Element Text Should Be            ${fieldLocator}_error    ${expectedMessage}

Verify Error Message Center
    [Arguments]    ${expectedMessage}
    Page Should Contain    ${expectedMessage}

Verify Balance Displayed
    Page Should Contain Element    xpath=//span[contains(@class,'balance')]
    ${balance}=    Get Text    xpath=//span[contains(@class,'balance')]
    Log    Current balance: ${balance}

Verify Transaction List Size
    [Arguments]    ${minCount}
    ${items}=    Get WebElements    xpath=//ul[@id='transactionList']/li
    Length Should Be At Least    ${items}    ${minCount}

Verify Each Transaction Contains
    [Arguments]    @{fields}
    ${items}=    Get WebElements    xpath=//ul[@id='transactionList']/li
    :FOR    ${item}    IN    @{items}
    \   :FOR    ${field}    IN    @{fields}
    \   \   ${value}=    Get Text    ${item}//div[@class='${field}']
    \   \   Should Not Be Empty    ${value}

Click Element
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}

# ... more keyword skeletons continue for the remaining steps
```

> **Tip** – Every keyword should be documented with a short comment (one line) so that new testers understand the intention.

---

## How to Run

```bash
# Run all tests
robot -d results UserFlowTests.robot

# Run only positive tests
robot -t positive -d results UserFlowTests.robot

# Run a single test by name
robot -t "Cadastro De Conta Com Dados Válidos" -d results UserFlowTests.robot
```

The generated **`results`** folder will contain the logs, screenshots, and the test report in `report.html`. Adjust the browser (e.g., Chrome, Firefox) or headless mode in the `Open Browser To Home Page` keyword if needed.

---

### Final Note
This skeleton captures every scenario from the BDD file, keeps the suite modular, and follows best practices such as:

* **Stable, reusable selectors** (IDs or `data-test` attributes).
* **Explicit waits** (`Wait Until Page Contains`, `Wait Until Element Is Visible`).
* **Clear comments** above each step.
* **Variables** for data and locators to ease maintenance.
* **Tagging** for selective execution.

You can now extend or modify individual keywords without touching the test cases – a hallmark of a sustainable Robot Framework automation suite.