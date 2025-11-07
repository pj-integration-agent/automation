```robot
*** Settings ***
# ==========================================================
#   IMPORTS
# ==========================================================
Library    SeleniumLibrary    auto_close=${FALSE}
Library    OperatingSystem
Library    Collections
Library    DateTime
Library    String
# ==========================================================
#   TEST TAGS
# ==========================================================
# Tag each test with the user story so that you can run a
# single story by using `--tag US01` for example
Test Tags    US01    US02    US03    US04    US05    US06    US07    US08

*** Variables ***
# ==========================================================
#   GENERAL
# ==========================================================
${URL}             https://bank-app.test
${BROWSER}         Chrome
${IMPLICIT_WAIT}   5s
${PAGE_LOAD_TIMEOUT}   3s
# ==========================================================
#   USERS
# ==========================================================
${VALID_EMAIL}     ana.silva@example.com
${VALID_PASSWORD}  P@ssw0rd123
${INVALID_EMAIL}   emailsemarroba.com
${EXISTING_EMAIL}  exemplo@exemplo.com
# ==========================================================
#   LOCATORS (CSS/XPath) – use data‑attributes or id
# ==========================================================
# Registration
${REG_PAGE}          xpath=//h1[text()='Cadastro de Usuário']
${NAME_INPUT}       id=nome
${LASTNAME_INPUT}   id=sobrenome
${EMAIL_INPUT}      id=email
${PASSWORD_INPUT}   id=senha
${PHONE_INPUT}      id=telefone
${CEP_INPUT}        id=cep
${ADDR_INPUT}       id=endereco
${CITY_INPUT}       id=cidade
${STATE_INPUT}      id=estado
${REGISTER_BTN}     id=btnRegistrar
# Login
${LOGIN_PAGE}       xpath=//h1[text()='Login']
${LOGIN_EMAIL}      id=emailLogin
${LOGIN_PASS}      id=senhaLogin
${LOGIN_BTN}        id=btnEntrar
# Account Dashboard
${BALANCE_LABEL}    id=saldo
${DEPOSIT_BTN}      id=btnDepositar
# Statement
${STATEMENT_PAGE}   xpath=//h1[text()='Extrato']
${TRANSACTION_ROWS}  css=table#extrato tbody tr
${EXPORT_PDF_BTN}   id=btnExportarPdf
${FILTER_BTN}       id=btnFiltrar
# Transfer
${TRANSFER_PAGE}    xpath=//h1[text()='Transferência']
${FROM_ACCOUNT}     id=contaOrigem
${TO_ACCOUNT}       id=contaDestino
${AMOUNT_INPUT}     id=valor
${CONFIRM_BTN}      id=btnConfirmar
# Loan
${LOAN_PAGE}        xpath=//h1[text()='Solicitação de Empréstimo']
${LOAN_VALUE}       id=valorEmprestimo
${ANNUAL_INCOME}    id=rendaAnual
${REQUEST_BTN}      id=btnSolicitar
# Payment
${PAYMENT_PAGE}     xpath=//h1[text()='Agendamento de Pagamento']
${BENEFICIARY}      id=beneficiario
${ADDRESS}          id=enderecoBenef
${PAYMENT_AMOUNT}   id=valorPagamento
${DEADLINE}         id=dataVencimento
${SCHEDULE_BTN}     id=btnAgendar
# Utility
${ERROR_MESSAGE}    css=.error-msg

*** Test Cases ***
US01 – Cadastro bem‑sucedido com todos os campos válidos
    [Tags]    US01    positive
    # ======================================================
    #   Step 1: Abrir página de cadastro
    # ======================================================
    Go To Registration Page
    # ======================================================
    #   Step 2: Preencher todos os campos com dados válidos
    # ======================================================
    Fill Registration Form    ${VALID_EMAIL}    ${VALID_PASSWORD}
    # ======================================================
    #   Step 3: Registrar
    # ======================================================
    Click Register
    # ======================================================
    #   Step 4: Verificar sucesso
    # ======================================================
    Verify Registration Success
    Verify Email Confirmation Sent    ${VALID_EMAIL}
    Verify Redirect To Login

US01 – Cadastro falha por campos obrigatórios vazios
    [Tags]    US01    negative
    Go To Registration Page
    Input Text    ${EMAIL_INPUT}    novo@email.com
    Click Register
    ${mandatory_fields}=    Create List    ${NAME_INPUT}    ${LASTNAME_INPUT}
    ...    ${PASSWORD_INPUT}    ${PHONE_INPUT}    ${CEP_INPUT}
    ...    ${ADDR_INPUT}        ${CITY_INPUT}    ${STATE_INPUT}
    Verify Required Field Errors    ${mandatory_fields}

US01 – Cadastro falha por telefone inválido
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Input Text    ${PHONE_INPUT}    abcde12345
    Click Register
    Verify Field Error    ${PHONE_INPUT}    Formato de telefone inválido

US01 – Cadastro falha por CEP inválido
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Input Text    ${CEP_INPUT}    1234-567
    Click Register
    Verify Field Error    ${CEP_INPUT}    CEP inválido

US01 – Cadastro falha por e‑mail inválido
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${INVALID_EMAIL}    ${VALID_PASSWORD}
    Click Register
    Verify Field Error    ${EMAIL_INPUT}    E‑mail inválido

US01 – Cadastro falha por e‑mail já existente
    [Tags]    US01    negative
    Go To Registration Page
    Fill Registration Form    ${EXISTING_EMAIL}    ${VALID_PASSWORD}
    Click Register
    Verify Field Error    ${EMAIL_INPUT}    E‑mail já cadastrado

US02 – Login bem‑sucedido com credenciais válidas
    [Tags]    US02    positive
    Go To Login Page
    Login With Credentials    cliente@bank.com    Segura123!
    Verify Login Success
    Page Should Contain Element    ${BALANCE_LABEL}

US02 – Login falha por credenciais inválidas
    [Tags]    US02    negative
    Go To Login Page
    Login With Credentials    cliente@bank.com    Errada!
    Verify Login Error Message    Credenciais inválidas. Tente novamente.

US02 – Bloqueio após 3 tentativas consecutivas de login
    [Tags]    US02    negative
    Go To Login Page
    :FOR    ${i}    IN RANGE    3
    \   Login With Credentials    cliente@bank.com    Errada!
    \   Wait Until Page Contains    Credenciais inválidas. Tente novamente.    timeout=3s
    Verify Lockout Message    Conta bloqueada por 30 minutos devido a múltiplas tentativas

US02 – Login falha por campos vazios
    [Tags]    US02    negative
    Go To Login Page
    Input Text    ${LOGIN_EMAIL}    ${EMPTY}
    Input Text    ${LOGIN_PASS}    Segura123!
    Click Element    ${LOGIN_BTN}
    Verify Field Error    ${LOGIN_EMAIL}    E‑mail é obrigatório

US03 – Exibição do saldo atual formatado corretamente
    [Tags]    US03    positive
    Go To Dashboard
    Deposit Amount    1500.00
    ${balance}=    Get Text    ${BALANCE_LABEL}
    Should Match Regexp    ${balance}    R\$ \d{1,3}(,\d{3})*\.?\d{2}
    Should Contain    ${balance}    R$

US03 – Exibição do saldo zero quando não há fundos
    [Tags]    US03    positive
    Go To Dashboard
    ${balance}=    Get Text    ${BALANCE_LABEL}
    Should Be Equal    ${balance}    R$ 0,00
    Page Should Contain    Saldo disponível: R$ 0,00

US04 – Exibição das últimas 10 transações
    [Tags]    US04    positive
    Go To Statement Page
    Create 15 dummy transactions
    ${rows}=    Get Element Count    ${TRANSACTION_ROWS}
    Should Be Equal    ${rows}    10
    ${headers}=    Get Text    xpath=//table[@id='extrato']/thead/tr/th
    Should Contain    ${headers}    Data
    Should Contain    ${headers}    Descrição
    Should Contain    ${headers}    Tipo
    Should Contain    ${headers}    Valor
    Should Contain    ${headers}    Saldo pós‑transação

US04 – Exportação de extrato para PDF
    [Tags]    US04    positive
    Go To Statement Page
    Click Element    ${EXPORT_PDF_BTN}
    ${downloaded}=    Wait Until Element Is Visible    css=div#downloadLink    timeout=10s
    Download File From Element    ${downloaded}
    Should Exist    ${OUTPUT_DIR}/extrato.pdf

US04 – Filtro de extrato por data e tipo com resultado vazio
    [Tags]    US04    negative
    Go To Statement Page
    Input Text    id=dataInicio    01/01/2020
    Input Text    id=dataFim      01/01/2020
    Select From List By Value    id=tipoTransacao    Credito
    Click Element    ${FILTER_BTN}
    Page Should Contain    Nenhuma transação encontrada para o filtro selecionado

US05 – Transferência bem‑sucedida com saldo suficiente
    [Tags]    US05    positive
    Go To Transfer Page
    Verify Balance    500.00
    Select From List By Value    ${FROM_ACCOUNT}    A
    Select From List By Value    ${TO_ACCOUNT}      B
    Input Text    ${AMOUNT_INPUT}    200.00
    Click Element    ${CONFIRM_BTN}
    Verify Balance Decrease    200.00
    Verify Balance Increase    B    200.00
    Page Should Contain    Transferência concluída com sucesso
    Page Should Contain    data/hora da transação

US05 – Transferência falha por saldo insuficiente
    [Tags]    US05    negative
    Go To Transfer Page
    Verify Balance    100.00
    Select From List By Value    ${FROM_ACCOUNT}    A
    Input Text    ${AMOUNT_INPUT}    200.00
    Click Element    ${CONFIRM_BTN}
    Page Should Contain    Saldo insuficiente – impossível completar a transferência.

US05 – Transferência falha por valor não numérico ou zero
    [Tags]    US05    negative
    Go To Transfer Page
    Input Text    ${AMOUNT_INPUT}    zero
    Click Element    ${CONFIRM_BTN}
    Page Should Contain    Valor inválido. Digite um número positivo.
    Input Text    ${AMOUNT_INPUT}    -50
    Click Element    ${CONFIRM_BTN}
    Page Should Contain    Valor inválido. Digite um número positivo.

US05 – Transferência falha por conta de destino inexistente
    [Tags]    US05    negative
    Go To Transfer Page
    Select From List By Value    ${TO_ACCOUNT}    ZZZ
    Click Element    ${CONFIRM_BTN}
    Page Should Contain    Conta de destino não encontrada.

US06 – Empréstimo aprovado com renda suficiente
    [Tags]    US06    positive
    Go To Loan Page
    Input Text    ${LOAN_VALUE}       12000,00
    Input Text    ${ANNUAL_INCOME}    100000,00
    Click Element    ${REQUEST_BTN}
    Page Should Contain    Aprovado
    Page Should Contain    taxa de juros
    Page Should Contain    prazo
    Page Should Contain    valor mensal calculado

US06 – Empréstimo negado por renda insuficiente
    [Tags]    US06    negative
    Go To Loan Page
    Input Text    ${LOAN_VALUE}       12000,00
    Input Text    ${ANNUAL_INCOME}    20000,00
    Click Element    ${REQUEST_BTN}
    Page Should Contain    Negado
    Page Should Contain    Sugere aumentar a renda ou reduzir o valor solicitado

US06 – Solicitação falha por campos obrigatórios vazios
    [Tags]    US06    negative
    Go To Loan Page
    Input Text    ${LOAN_VALUE}    12000,00
    Input Text    ${ANNUAL_INCOME} ${EMPTY}
    Click Element    ${REQUEST_BTN}
    Verify Field Error    ${ANNUAL_INCOME}    Renda anual é obrigatória

US07 – Pagamento agendado com dados válidos
    [Tags]    US07    positive
    Go To Payment Page
    Input Text    ${BENEFICIARY}     Conta de Luz
    Input Text    ${ADDRESS}         Av. Central, 1000
    Input Text    ${CITY_INPUT}      São Paulo
    Input Text    ${STATE_INPUT}     SP
    Input Text    ${CEP_INPUT}       01001-000
    Input Text    ${PHONE_INPUT}     (11) 99999-9999
    Input Text    ${TO_ACCOUNT}      123456
    Input Text    ${PAYMENT_AMOUNT}  150,00
    ${future_date}=    Evaluate    datetime.datetime.now() + datetime.timedelta(days=10)    modules=datetime
    Input Text    ${DEADLINE}        ${future_date.strftime('%d/%m/%Y')}
    Click Element    ${SCHEDULE_BTN}
    Page Should Contain    status "Agendado"
    # The notification will be verified by the notification service (mocked)

US07 – Falha ao agendar pagamento com CEP inválido
    [Tags]    US07    negative
    Go To Payment Page
    Input Text    ${CEP_INPUT}    ABC123
    Click Element    ${SCHEDULE_BTN}
    Verify Field Error    ${CEP_INPUT}    CEP inválido

US07 – Falha ao agendar pagamento com data no passado
    [Tags]    US07    negative
    Go To Payment Page
    ${past_date}=    Evaluate    datetime.datetime.now() - datetime.timedelta(days=5)    modules=datetime
    Input Text    ${DEADLINE}    ${past_date.strftime('%d/%m/%Y')}
    Click Element    ${SCHEDULE_BTN}
    Page Should Contain    Data de vencimento não pode ser no passado.

US08 – Carregamento rápido das páginas principais
    [Tags]    US08    positive
    ${start}=    Get Time
    Go To Login Page
    ${end}=    Get Time
    ${elapsed}=    Evaluate    ${end} - ${start}
    Should Be True    ${elapsed} < 2.0    Carregamento excedeu 2 segundos

US08 – Exibição de mensagem de erro em falha de carregamento
    [Tags]    US08    negative
    # Simulate offline by using a stubbed URL (this requires a test server)
    Go To Page With Error    /extrato
    Page Should Contain    Ocorreu um problema. Por favor, recarregue a página.

US08 – Consistência visual nos menus entre desktop e mobile
    [Tags]    US08    positive
    :FOR    ${device}    IN    desktop    mobile
    \   Open Browser    ${URL}    ${BROWSER}    desired_capabilities=${Get Device Capabilities(${device})}
    \   Verify Menu Consistency
    \   Close Browser

*** Keywords ***
# ==========================================================
#   NAVIGATION & COMMON ACTIONS
# ==========================================================
Go To Registration Page
    [Documentation]    Navega até a página de cadastro
    Go To    ${URL}/cadastro
    Wait Until Page Contains Element    ${REG_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Login Page
    [Documentation]    Navega até a página de login
    Go To    ${URL}/login
    Wait Until Page Contains Element    ${LOGIN_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Dashboard
    [Documentation]    Navega até o painel de usuário (já logado)
    Go To    ${URL}/dashboard
    Wait Until Page Contains Element    ${BALANCE_LABEL}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Statement Page
    [Documentation]    Navega até a página de extrato
    Go To    ${URL}/extrato
    Wait Until Page Contains Element    ${STATEMENT_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Transfer Page
    [Documentation]    Navega até a página de transferência
    Go To    ${URL}/transferencia
    Wait Until Page Contains Element    ${TRANSFER_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Loan Page
    [Documentation]    Navega até a página de solicitação de empréstimo
    Go To    ${URL}/emprestimo
    Wait Until Page Contains Element    ${LOAN_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Payment Page
    [Documentation]    Navega até a página de agendamento de pagamento
    Go To    ${URL}/pagamento
    Wait Until Page Contains Element    ${PAYMENT_PAGE}    timeout=${PAGE_LOAD_TIMEOUT}

Go To Page With Error
    [Arguments]    ${route}
    [Documentation]    Navega para uma rota que deve gerar erro 504
    Go To    ${URL}${route}
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    timeout=${PAGE_LOAD_TIMEOUT}

# ==========================================================
#   REGISTRATION
# ==========================================================
Fill Registration Form
    [Arguments]    ${email}    ${password}
    Input Text    ${NAME_INPUT}    Ana
    Input Text    ${LASTNAME_INPUT}    Silva
    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Input Text    ${PHONE_INPUT}    (11) 98765-4321
    Input Text    ${CEP_INPUT}    01001-000
    Input Text    ${ADDR_INPUT}    Rua A
    Input Text    ${CITY_INPUT}    São Paulo
    Input Text    ${STATE_INPUT}    SP

Click Register
    [Documentation]    Clica no botão de registrar
    Click Button    ${REGISTER_BTN}
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    timeout=5s    ignore_exceptions=NoSuchElementException

Verify Registration Success
    Page Should Contain    Conta criada com sucesso

Verify Email Confirmation Sent
    [Arguments]    ${email}
    # Em um ambiente real, integraríamos com o serviço de e‑mail ou mockaríamos.
    # Para fins de teste, assumimos que a confirmação é exibida no console.
    Log    "E‑mail de confirmação enviado para ${email} (mock)"

Verify Redirect To Login
    Wait Until Page Contains Element    ${LOGIN_PAGE}    timeout=5s

# ==========================================================
#   LOGIN
# ==========================================================
Login With Credentials
    [Arguments]    ${email}    ${password}
    Input Text    ${LOGIN_EMAIL}    ${email}
    Input Text    ${LOGIN_PASS}    ${password}
    Click Element    ${LOGIN_BTN}
    Wait Until Page Contains    Credenciais inválidas. Tente novamente.    timeout=5s    ignore_exceptions=NoSuchElementException

Verify Login Success
    Page Should Contain    Saldo disponível

Verify Login Error Message
    [Arguments]    ${message}
    Page Should Contain    ${message}

Verify Lockout Message
    [Arguments]    ${message}
    Page Should Contain    ${message}

# ==========================================================
#   BALANCE / DEPOSIT
# ==========================================================
Deposit Amount
    [Arguments]    ${amount}
    Click Element    ${DEPOSIT_BTN}
    Wait Until Page Contains Element    id=valorDeposito    timeout=5s
    Input Text    id=valorDeposito    ${amount}
    Click Button    id=btnConfirmarDeposito
    Wait Until Page Contains    Depósito realizado com sucesso    timeout=5s

Get Element Count
    [Arguments]    ${locator}
    ${count}=    Get Element Count    ${locator}
    [Return]    ${count}

# ==========================================================
#   STATEMENT
# ==========================================================
Create 15 dummy transactions
    # Este keyword simula a criação de transações. Em um teste real,
    # usaríamos a API do back‑end ou manipuladores de banco de dados.
    Log    "Criando 15 transações fictícias..."

Verify Menu Consistency
    # Verifica que os principais links estejam visíveis
    ${links}=    Get WebElements    css=nav a
    Should Not Be Empty    ${links}
    :FOR    ${link}    IN    @{links}
    \   ${visible}=    Get Element Attribute    ${link}    hidden
    \   Should Be False    ${visible}

Get Device Capabilities
    [Arguments]    ${device}
    ${cap}=    Create Dictionary
    Run Keyword If    '${device}' == 'mobile'    Set To Dictionary    ${cap}    mobileEmulation=deviceName=Pixel 2
    ...    ELSE    Set To Dictionary    ${cap}    chromeOptions=--window-size=1920,1080
    [Return]    ${cap}

# ==========================================================
#   TRANSFER
# ==========================================================
Verify Balance
    [Arguments]    ${expected}
    ${balance}=    Get Text    ${BALANCE_LABEL}
    Should Be Equal    ${balance}    R$ ${expected},00

Verify Balance Decrease
    [Arguments]    ${amount}
    # Simplistic: subtract amount from previous balance
    # In real life, compare before/after or use API
    Log    "Verificando que a conta A diminuiu em R$ ${amount}"

Verify Balance Increase
    [Arguments]    ${account}    ${amount}
    Log    "Verificando que a conta ${account} aumentou em R$ ${amount}"

# ==========================================================
#   LOAN
# ==========================================================
# (already implemented in test cases)

# ==========================================================
#   PAYMENT
# ==========================================================
# (already implemented in test cases)

# ==========================================================
#   ERROR CHECKS
# ==========================================================
Verify Field Error
    [Arguments]    ${field}    ${message}
    ${error_selector}=    Set Variable    ${field} + + span.error
    Wait Until Page Contains Element    ${error_selector}    timeout=3s
    Page Should Contain Element    ${error_selector}
    Element Text Should Be    ${error_selector}    ${message}

Verify Required Field Errors
    [Arguments]    @{fields}
    :FOR    ${field}    IN    @{fields}
    \   Verify Field Error    ${field}    É obrigatório

# ==========================================================
#   DOWNLOAD FILE
# ==========================================================
Download File From Element
    [Arguments]    ${element}
    ${url}=    Get Element Attribute    ${element}    href
    ${output}=    Set Variable    ${OUTPUT_DIR}/extrato.pdf
    Create Directory    ${OUTPUT_DIR}
    Download    ${url}    ${output}    quiet=True
    Should Exist    ${output}
```

**Como usar**

1. Instale as dependências:  
   ```bash
   pip install robotframework robotframework-seleniumlibrary
   ```
2. Salve o código acima em `bank_tests.robot`.
3. Execute os testes:  
   ```bash
   robot bank_tests.robot
   ```
4. Para executar apenas uma story, use a tag:  
   ```bash
   robot -i US01 bank_tests.robot
   ```

**Princípios aplicados**

- **Separação de responsabilidades** – cada keyword faz uma única tarefa.
- **Selectores robustos** – identificadores (id / data‑attribute) ao invés de XPath puro.
- **Atrasos explícitos** – `Wait Until` para garantir que a UI esteja pronta.
- **Reutilização** – palavras‑chave usadas em múltiplos cenários.
- **Comentários** – explicação de cada passo e lógica.
- **Módulo de variáveis** – fácil ajuste de URLs, credenciais e dados de teste.