```robot
*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           String
Library           OperatingSystem
# -------------- Custom keyword libraries --------------
# If you need to interact with an API or database you can create
# your own python modules and import them here.
# Example: Library           ../resources/api_keywords.py
# -------------- Suite Setup & Teardown --------------
Suite Setup       Open Browser To Base URL
Suite Teardown    Close Browser

# -------------- Test Teardown --------------
Test Teardown      Capture Page Screenshot    # useful for debugging

# -------------- Test Timeouts --------------
Test Timeout       3 minutes
Resource           ../resources/common_keywords.robot   # reusable keywords

*** Variables ***
${BASE_URL}         https://app.example.com
${BROWSER}          Chrome
${IMPLICIT_WAIT}    5s
${DEFAULT_TIMEOUT}  15s
${WAIT_TIME}        0.5s   # small pause after actions

# Locators – use stable attributes (id, data-testid, name, etc.)
# Example placeholders – replace with real selectors
${REG_PAGE}           css:#registration-page
${LOGIN_PAGE}         css:#login-page
${DASHBOARD}          css:#dashboard
${EXTRATO_PAGE}       css:#extrato
${EMPRÉSTIMO_PAGE}    css:#emprestimo
${TRANSFERIR_PAGE}    css:#transferencia

# Field locators by label – dynamic lookup
# Example:  label[for="email"] + input
${FIELD}              css:label[for="${FIELD_ID}"] + input

# Buttons by visible text
${BUTTON}             xpath://button[normalize-space()="${BUTTON_TEXT}"]

# Messages under a field
${FIELD_ERROR}        xpath://label[normalize-space()="${FIELD_TEXT}"]/following-sibling::span[contains(@class, "error")]

# ----------------------- Test Cases ---------------------------------

*** Test Cases ***
US01 - Cadastro de Usuário
  # Positive scenario – successful registration
  [Documentation]    Registro de usuário com dados válidos
  Go To Page    ${REG_PAGE}
  Fill Field    Nome    Ana Costa
  Fill Field    E‑mail    ana.costa@example.com
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Set Password  Senha123
  Set Password Confirmation  Senha123
  Click Button  Registrar
  Wait For Message    Cadastro concluído. Você pode agora fazer login.

  # Negative – button disabled if required field empty
  [Documentation]    Registrar desabilitado quando campo obrigatório em branco
  Go To Page    ${REG_PAGE}
  Clear Field   Nome
  Fill Field    E‑mail    ana.costa@example.com
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Set Password  Senha123
  Set Password Confirmation  Senha123
  Element Should Be Disabled   ${BUTTON}    Registrar

  # Negative – invalid e‑mail format
  [Documentation]    Mensagem de erro para e‑mail inválido
  Go To Page    ${REG_PAGE}
  Fill Field    E‑mail    ana.costa@exemplo
  Fill Field    Nome    Ana Costa
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Set Password  Senha123
  Set Password Confirmation  Senha123
  Wait For Field Error  E‑mail    Formato de e‑mail inválido

US02 - Validação de Campos de Cadastro
  # Negative – password without numbers
  [Documentation]    Senha sem número gera erro
  Go To Page    ${REG_PAGE}
  Set Password  SenhaSemNum
  Set Password Confirmation  SenhaSemNum
  Fill Field    Nome    Ana Costa
  Fill Field    E‑mail    ana.costa@example.com
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Wait For Field Error  Senha    A senha deve conter pelo menos um número

  # Negative – passwords do not match
  [Documentation]    Senhas divergentes exibem mensagem
  Go To Page    ${REG_PAGE}
  Set Password  Senha123
  Set Password Confirmation  Senha124
  Fill Field    Nome    Ana Costa
  Fill Field    E‑mail    ana.costa@example.com
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Wait For Field Error  Confirmação de senha    As senhas não coincidem

  # Negative – e‑mail already registered
  [Documentation]    E‑mail já cadastrado gera erro
  # Pre‑condition – create user via API (placeholder)
  Create User Via API    exemplo@exemplo.com    Senha123
  Go To Page    ${REG_PAGE}
  Fill Field    E‑mail    exemplo@exemplo.com
  Fill Field    Nome    Ana Costa
  Fill Field    Telefone    (11) 98765‑4321
  Fill Field    CEP    12345678
  Set Password  Senha123
  Set Password Confirmation  Senha123
  Wait For Field Error  E‑mail    E‑mail já está cadastrado

US03 - Login Bem‑Sucedido
  # Positive – successful login
  [Documentation]    Usuário autenticado com sucesso
  # Pre‑condition – ensure user exists
  Create User Via API    joao@exemplo.com    Senha123
  Go To Page    ${LOGIN_PAGE}
  Fill Field    E‑mail    joao@exemplo.com
  Fill Field    Senha    Senha123
  Click Button  Login
  Wait Until Page Contains Element    ${DASHBOARD}    ${DEFAULT_TIMEOUT}
  Page Should Contain    Bem‑vindo, João!
  Page Should Contain    Saldo atual

  # Negative – button disabled until both fields are filled
  [Documentation]    Botão Login desabilitado até ambos os campos preenchidos
  Go To Page    ${LOGIN_PAGE}
  Clear Field   E‑mail
  Fill Field    Senha    Senha123
  Element Should Be Disabled   ${BUTTON}    Login

US04 - Login com Credenciais Inválidas
  # Negative – e‑mail not found
  [Documentation]    E‑mail não cadastrado
  Go To Page    ${LOGIN_PAGE}
  Fill Field    E‑mail    naoexiste@exemplo.com
  Fill Field    Senha    Senha123
  Click Button  Login
  Wait For Message    E‑mail não encontrado

  # Negative – wrong password
  [Documentation]    Senha errada
  Create User Via API    joao@exemplo.com    Senha123
  Go To Page    ${LOGIN_PAGE}
  Fill Field    E‑mail    joao@exemplo.com
  Fill Field    Senha    Errada123
  Click Button  Login
  Wait For Message    Senha inválida

  # Negative – lockout after five failed attempts
  [Documentation]    Bloqueio após cinco tentativas
  Go To Page    ${LOGIN_PAGE}
  # Simulate five previous failures
  Simulate Failed Logins    joao@exemplo.com    5
  Fill Field    E‑mail    joao@exemplo.com
  Fill Field    Senha    Errada123
  Click Button  Login
  Wait For Message    Login bloqueado – tente novamente em 5 min

US05 - Visualização de Saldo
  # Positive – balance displayed as currency
  [Documentation]    Saldo exibido em formato monetário
  Go To Page    ${DASHBOARD}
  # Set balance via API (placeholder)
  Set Account Balance Via API    1234.56
  Page Should Contain    R$ 1.234,56

  # Positive – zero balance shows specific message
  [Documentation]    Saldo zero exibe mensagem específica
  Set Account Balance Via API    0.00
  Page Should Contain    Saldo zero

US06 - Visualização de Extrato
  # Positive – last ten transactions
  [Documentation]    Exibir últimas dez transações
  # Create 12 dummy transactions via API
  Create Transactions Via API    12
  Go To Page    ${EXTRATO_PAGE}
  Page Should Contain    Últimos 10 registros
  # Verify each row contains required fields – simplified loop
  ${rows}=    Get WebElements    css:#extrato-table tbody tr
  Should Be True    ${len(rows)} >= 10
  :FOR    ${row}    IN    @{rows}
  \    ${row_text}=    Get Text    ${row}
  \    Should Match Regexp    ${row_text}    \\d{2}/\\d{2}/\\d{4}.*.*.*.*$  # date, description, value, saldo

  # Positive – no transactions
  [Documentation]    Mensagem quando não há transações
  Delete All Transactions Via API
  Go To Page    ${EXTRATO_PAGE}
  Page Should Contain    Não há movimentação recente

US07 - Transferência de Fundos – Seleção de Contas
  # Positive – dropdown shows only user accounts
  [Documentation]    Dropdown de origem exibe apenas contas do usuário
  Create Account Via API    Conta A
  Create Account Via API    Conta B
  Go To Page    ${TRANSFERIR_PAGE}
  ${options}=    Get Texts    css:#origin-account option
  Should Contain    ${options}    Conta A
  Should Contain    ${options}    Conta B

  # Negative – confirm button disabled with empty amount
  [Documentation]    Confirmar habilitado apenas com campos válidos
  Go To Page    ${TRANSFERIR_PAGE}
  Select From List By Label    id:origin-account    Conta A
  Clear Field   Valor
  Element Should Be Disabled   ${BUTTON}    Confirmar

  # Positive – amount accepts two decimals
  [Documentation]    Valor aceita até duas casas decimais
  Go To Page    ${TRANSFERIR_PAGE}
  Select From List By Label    id:origin-account    Conta A
  Select From List By Label    id:destination-account    Conta C
  Fill Field    Valor    250,50
  Page Should Not Contain    valor inválido

US08 - Validação de Valor de Transferência
  # Negative – amount greater than balance
  [Documentation]    Valor maior que saldo exibe erro
  Set Account Balance Via API    500.00
  Go To Page    ${TRANSFERIR_PAGE}
  Select From List By Label    id:origin-account    Conta A
  Select From List By Label    id:destination-account    Conta C
  Fill Field    Valor    600,00
  Wait For Message    Saldo insuficiente – verifique o saldo
  Element Should Be Disabled   ${BUTTON}    Confirmar

  # Positive – amount equal to balance enables confirm
  [Documentation]    Valor igual ao saldo habilita confirmação
  Set Account Balance Via API    500.00
  Go To Page    ${TRANSFERIR_PAGE}
  Select From List By Label    id:origin-account    Conta A
  Select From List By Label    id:destination-account    Conta C
  Fill Field    Valor    500,00
  Element Should Be Enabled   ${BUTTON}    Confirmar

US09 - Transferência Bem‑Sucedida
  [Documentation]    Saldo atualizado e histórico criado
  Set Account Balance Via API    1000.00    Conta A
  Set Account Balance Via API    300.00     Conta C
  Go To Page    ${TRANSFERIR_PAGE}
  Select From List By Label    id:origin-account    Conta A
  Select From List By Label    id:destination-account    Conta C
  Fill Field    Valor    200,00
  Click Button  Confirmar
  Wait For Message    Transferência concluída com sucesso
  # Verify balances
  Page Should Contain    R$ 800,00   # origem
  Page Should Contain    R$ 500,00   # destino
  # Verify transaction record in origin's extrato
  Go To Page    ${EXTRATO_PAGE}
  Page Should Contain    Transferência    -200,00
  Page Should Contain    Saldo pós‑transação    800,00
  # Verify record in destination's extrato
  # (In real test you would switch account context or use API)

US10 - Solicitação de Empréstimo – Entrada de Dados
  # Positive – value within 5× income
  [Documentation]    Valor dentro do limite 5× renda é aceito
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Renda Anual    10000
  Fill Field    Valor do Empréstimo    40000
  Element Should Be Enabled   ${BUTTON}    Enviar Solicitação

  # Negative – value exceeds limit
  [Documentation]    Valor maior que 5× renda gera erro
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Renda Anual    10000
  Fill Field    Valor do Empréstimo    60000
  Wait For Message    O valor do empréstimo não pode exceder 5 vezes sua renda anual
  Element Should Be Disabled   ${BUTTON}    Enviar Solicitação

  # Negative – non‑numeric field
  [Documentation]    Campos obrigatórios não numéricos bloqueiam envio
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Valor do Empréstimo    cinquenta
  Wait For Message    Valor deve ser um número
  Element Should Be Disabled   ${BUTTON}    Enviar Solicitação

US11 - Resultado da Solicitação de Empréstimo
  # Positive – approval
  [Documentation]    Empréstimo aprovado mostra valor e prazo
  Submit Loan Request
  # Simulate approval via API
  Simulate Loan Approval
  Wait For Message    Empréstimo Aprovado
  Page Should Contain    Valor Disponível: R$ 50.000,00
  Page Should Contain    Prazo: 60 meses

  # Negative – denial
  [Documentation]    Empréstimo negado exibe sugestão
  Submit Loan Request
  Simulate Loan Denial
  Wait For Message    Empréstimo Negado
  Page Should Contain    Considere reduzir o valor ou aumentar a renda

US12 - Registro de Pagamento de Contas – Dados
  # Positive – valid scheduling
  [Documentation]    Pagamento registrado com dados válidos
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Beneficiário    Minha Conta
  Fill Field    Valor    150,00
  ${date}=    Get Current Date    result_format=%d/%m/%Y    increment=5
  Fill Field    Data    ${date}
  Click Button  Agendar Pagamento
  Wait For Message    Pagamento agendado com sucesso

  # Negative – invalid date
  [Documentation]    Data inválida gera mensagem
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Data    2020-01-01
  Click Button  Agendar Pagamento
  Wait For Message    Data inválida

  # Negative – zero value
  [Documentation]    Valor zero bloqueia agendamento
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Fill Field    Valor    0,00
  Click Button  Agendar Pagamento
  Wait For Message    Valor deve ser maior que zero

US13 - Pagamento de Contas Registrado no Histórico
  [Documentation]    Pagamento aparece no extrato após execução
  Schedule Payment Via API    2023-12-15
  # Fast‑forward time or trigger processing via API
  Execute Scheduled Payment
  Go To Page    ${EXTRATO_PAGE}
  Page Should Contain    Pagamento de Conta – [Beneficiário]
  Page Should Contain    15/12/2023
  Page Should Contain    150,00

US14 - Pagamento Futuro Respeita Data Agendada
  # Negative – not present before date
  [Documentation]    Pagamento não aparece antes da data agendada
  Schedule Payment Via API    tomorrow
  Go To Page    ${EXTRATO_PAGE}
  Page Should Not Contain    Pagamento de Conta – [Beneficiário]

  # Negative – cancel before date
  [Documentation]    Cancelar pagamento antes da data
  Schedule Payment Via API    tomorrow
  Go To Page    ${EMPRÉSTIMO_PAGE}
  Click Button  Cancelar
  Wait For Message    Pagamento cancelado

US15 - Navegação Consistente
  # Positive – menu present on all pages
  [Documentation]    Menu está presente em todas as páginas
  Go To Page    ${TRANSFERIR_PAGE}
  Page Should Contain Element    css:#header-logo
  Page Should Contain Element    css:#user-name
  Page Should Contain Element    css:#nav-menu

  # Positive – menu links redirect correctly
  [Documentation]    Links do menu redirecionam corretamente
  Click Link    css:#nav-menu a[href="/emprestimos"]
  Wait Until Page Contains Element    ${EMPRÉSTIMO_PAGE}    ${DEFAULT_TIMEOUT}

  # Positive – logout redirects to login
  [Documentation]    Sair redireciona para login
  Click Link    css:#nav-menu a[href="/logout"]
  Wait Until Page Contains Element    ${LOGIN_PAGE}    ${DEFAULT_TIMEOUT}

US16 - Mensagens de Erro Claras e Objetivas
  # Positive – error in red below field
  [Documentation]    Mensagem de erro exibida em vermelho abaixo do campo
  Go To Page    ${REG_PAGE}
  Clear Field   E‑mail
  Click Button  Registrar
  Wait For Field Error    E‑mail    Preencha o campo E‑mail

  # Negative – generic error for unhandled exception
  [Documentation]    Mensagem de erro genérica para exceções não tratadas
  # Simulate unexpected exception via API or mock
  Trigger Unexpected Exception
  Wait For Message    Ocorreu um erro inesperado. Tente novamente mais tarde.

*** Keywords ***

# ----------------------- General Navigation -----------------------
Go To Page
    [Arguments]    ${locator}
    [Documentation]    Navega até a página indicada pelo locator
    Wait Until Page Contains Element    ${locator}    ${DEFAULT_TIMEOUT}

# ----------------------- Field Interaction -----------------------
Fill Field
    [Arguments]    ${label}    ${value}
    [Documentation]    Preenche o campo identificado pelo label com o valor fornecido
    ${field_id}=    Get Element Attribute    xpath://label[normalize-space()="${label}"]/following-sibling::input    id
    ${locator}=    Set Variable    css:input[id="${field_id}"]
    Wait Until Element Is Visible    ${locator}    ${DEFAULT_TIMEOUT}
    Input Text    ${locator}    ${value}    clear=True
    Sleep    ${WAIT_TIME}

Clear Field
    [Arguments]    ${label}
    [Documentation]    Limpa o campo identificado pelo label
    ${field_id}=    Get Element Attribute    xpath://label[normalize-space()="${label}"]/following-sibling::input    id
    ${locator}=    Set Variable    css:input[id="${field_id}"]
    Wait Until Element Is Visible    ${locator}    ${DEFAULT_TIMEOUT}
    Clear Element Text    ${locator}
    Sleep    ${WAIT_TIME}

Set Password
    [Arguments]    ${value}
    [Documentation]    Preenche o campo de senha
    Fill Field    Senha    ${value}

Set Password Confirmation
    [Arguments]    ${value}
    [Documentation]    Preenche o campo de confirmação de senha
    Fill Field    Confirmação de senha    ${value}

Click Button
    [Arguments]    ${text}
    [Documentation]    Clica no botão com o texto visível
    Wait Until Element Is Visible    ${BUTTON}    ${DEFAULT_TIMEOUT}
    Click Element    ${BUTTON}
    Sleep    ${WAIT_TIME}

Click Link
    [Arguments]    ${locator}
    [Documentation]    Clica no link definido por locator
    Wait Until Element Is Visible    ${locator}    ${DEFAULT_TIMEOUT}
    Click Element    ${locator}
    Sleep    ${WAIT_TIME}

# ----------------------- Validation -----------------------
Wait For Message
    [Arguments]    ${message}
    [Documentation]    Espera até que a mensagem apareça na tela
    Wait Until Page Contains    ${message}    ${DEFAULT_TIMEOUT}

Wait For Field Error
    [Arguments]    ${label}    ${expected_error}
    [Documentation]    Verifica mensagem de erro exibida abaixo do campo
    ${error_locator}=    Set Variable    ${FIELD_ERROR}    ${label}    ${expected_error}
    Wait Until Page Contains Element    ${error_locator}    ${DEFAULT_TIMEOUT}
    Element Text Should Be    ${error_locator}    ${expected_error}

Element Should Be Disabled
    [Arguments]    ${locator}    ${button_text}
    [Documentation]    Verifica se o botão está desabilitado
    ${attr}=    Get Element Attribute    ${locator}    disabled
    Should Not Be Empty    ${attr}

Element Should Be Enabled
    [Arguments]    ${locator}    ${button_text}
    [Documentation]    Verifica se o botão está habilitado
    ${attr}=    Get Element Attribute    ${locator}    disabled
    Should Be Empty    ${attr}

# ----------------------- API / DB Helpers (Placeholders) -----------------------
Create User Via API
    [Arguments]    ${email}    ${password}
    # Implement via REST, database insert, or mock
    No Operation

Set Account Balance Via API
    [Arguments]    ${amount}    ${account_name}=Conta A
    No Operation

Create Account Via API
    [Arguments]    ${name}
    No Operation

Create Transactions Via API
    [Arguments]    ${count}
    No Operation

Delete All Transactions Via API
    No Operation

Simulate Failed Logins
    [Arguments]    ${email}    ${attempts}
    No Operation

Submit Loan Request
    # Fill loan form and click submit
    No Operation

Simulate Loan Approval
    No Operation

Simulate Loan Denial
    No Operation

Schedule Payment Via API
    [Arguments]    ${date}
    No Operation

Execute Scheduled Payment
    No Operation

Trigger Unexpected Exception
    No Operation

# ----------------------- Utility Keywords -----------------------
Get Current Date
    [Arguments]    ${result_format}=${None}    ${increment}=${None}
    ${now}=    Get Current Date    result_format=%Y-%m-%d
    Run Keyword If    '${increment}' != '${None}'    Add Time To Date    ${now}    ${increment} days    result_format=%Y-%m-%d    return=True
    ${formatted}=    Convert Time    ${now}    result_format=%d/%m/%Y
    [Return]    ${formatted}
```


**Key Points**

1. **Modular Design** – All common actions are extracted to keywords so that adding new tests only needs a few lines.
2. **Stable Locators** – Prefer IDs or data‑attributes; dynamic locators (by label) are built at runtime.
3. **Explicit Waits** – Each action waits for the element to be visible, preventing flakiness.
4. **Clear Documentation** – Every keyword and test has a description to aid maintenance.
5. **Error Handling** – Negative scenarios use explicit checks (`Element Should Be Disabled/Enabled`) and error message assertions.
6. **API Placeholders** – Real tests will replace `No Operation` stubs with API or DB calls to create users, set balances, etc.

Feel free to split the file into separate suites or resource files as your test repository grows.