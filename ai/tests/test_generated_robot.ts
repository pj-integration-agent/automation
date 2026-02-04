```robot
*** Settings ***
Documentation     Automação dos cenários de cadastro e edição de bancos
Library           SeleniumLibrary
Library           Collections
Suite Setup       Open Browser To Login Page
Suite Teardown    Close All Browsers
Test Setup        Log Into Application
Test Teardown     Logout And Clear Browser Data

*** Variables ***
${BROWSER}            chrome
${BASE_URL}           https://app.example.com
${USERNAME}           admin_user
${PASSWORD}           P@ssw0rd
${TIMEOUT}            10s
${DEFAULT_WAIT}       2s

# Selectors (assumindo uso de IDs, data-testid ou XPaths)
${BTN_NEW}            css:button[data-testid="btn-new"]
${BTN_SAVE}           css:button[data-testid="btn-save"]
${BTN_EDIT}           css:button[data-testid="btn-edit"]
${INPUT_CODE}         css:input[data-testid="bank-code"]
${INPUT_DESC}         css:input[data-testid="bank-description"]
${INPUT_ALIAS}        css:input[data-testid="bank-alias"]
${INPUT_SBP}          css:input[data-testid="bank-sbp-number"]
${INPUT_CNPJ}         css:input[data-testid="bank-cnpj"]
${SELECT_CTRL}        css:select[data-testid="bank-controller"]
${BANK_LIST}          css:table[data-testid="bank-list"]
${BANK_ROW}           css:tr[data-testid="bank-row-${BANK_CODE}"]    # placeholder
${ALERT_MSG}          css:div[data-testid="alert-message"]
${LOGIN_USERNAME}     css:input[name="username"]
${LOGIN_PASSWORD}     css:input[name="password"]
${LOGIN_SUBMIT}       css:button[type="submit"]
${LOGOUT_BTN}         css:button[data-testid="btn-logout"]

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DEFAULT_WAIT}

Log Into Application
    [Documentation]    Prepara o contexto autenticado
    Wait Until Page Contains Element    ${LOGIN_USERNAME}    timeout=${TIMEOUT}
    Input Text    ${LOGIN_USERNAME}    ${USERNAME}
    Input Text    ${LOGIN_PASSWORD}    ${PASSWORD}
    Click Button  ${LOGIN_SUBMIT}
    Wait Until Page Contains Element    ${BTN_NEW}    timeout=${TIMEOUT}

Logout And Clear Browser Data
    Click Button    ${LOGOUT_BTN}
    Wait Until Page Does Not Contain Element    ${BTN_NEW}    timeout=${TIMEOUT}

# --------------------------------------------------------------------
# Banco CRUD helpers
# --------------------------------------------------------------------
Create Bank
    [Arguments]    ${code}    ${description}    ${alias}    ${sbp}    ${controller}    ${cnpj}
    Click Button    ${BTN_NEW}
    Wait Until Page Contains Element    ${INPUT_CODE}    timeout=${TIMEOUT}
    Input Text    ${INPUT_CODE}    ${code}
    Input Text    ${INPUT_DESC}    ${description}
    Input Text    ${INPUT_ALIAS}    ${alias}
    Input Text    ${INPUT_SBP}     ${sbp}
    Select From List By Label    ${SELECT_CTRL}    ${controller}
    Input Text    ${INPUT_CNPJ}    ${cnpj}
    Click Button    ${BTN_SAVE}
    Wait Until Page Contains Element    ${BANK_LIST}    timeout=${TIMEOUT}

Edit Bank
    [Arguments]    ${code}    ${new_desc}    ${new_alias}    ${new_sbp}    ${new_controller}    ${new_cnpj}
    ${row_selector}=    Set Variable    ${BANK_ROW.replace("${BANK_CODE}", ${code})}
    Wait Until Page Contains Element    ${row_selector}    timeout=${TIMEOUT}
    Click Element    ${row_selector}
    Click Button     ${BTN_EDIT}
    Wait Until Page Contains Element    ${INPUT_DESC}    timeout=${TIMEOUT}
    Clear Element Text    ${INPUT_DESC}
    Input Text    ${INPUT_DESC}    ${new_desc}
    Clear Element Text    ${INPUT_ALIAS}
    Input Text    ${INPUT_ALIAS}    ${new_alias}
    Clear Element Text    ${INPUT_SBP}
    Input Text    ${INPUT_SBP}    ${new_sbp}
    Select From List By Label    ${SELECT_CTRL}    ${new_controller}
    Clear Element Text    ${INPUT_CNPJ}
    Input Text    ${INPUT_CNPJ}    ${new_cnpj}
    Click Button    ${BTN_SAVE}
    Wait Until Page Contains Element    ${BANK_LIST}    timeout=${TIMEOUT}

Verify Bank Exists
    [Arguments]    ${code}
    ${row_selector}=    Set Variable    ${BANK_ROW.replace("${BANK_CODE}", ${code})}
    Page Should Contain Element    ${row_selector}    timeout=${TIMEOUT}

Verify Bank Not Exists
    [Arguments]    ${code}
    ${row_selector}=    Set Variable    ${BANK_ROW.replace("${BANK_CODE}", ${code})}
    Page Should Not Contain Element    ${row_selector}

# --------------------------------------------------------------------
# Helpers de mensagens
# --------------------------------------------------------------------
Verify Alert Message
    [Arguments]    ${expected_msg}
    Wait Until Page Contains Element    ${ALERT_MSG}    timeout=${TIMEOUT}
    ${msg}=    Get Text    ${ALERT_MSG}
    Should Be Equal    ${msg}    ${expected_msg}

# --------------------------------------------------------------------
# Setup para cenário com banco existente
# --------------------------------------------------------------------
Ensure Bank Exists
    [Arguments]    ${code}    ${description}    ${alias}    ${sbp}    ${controller}    ${cnpj}
    Verify Bank Not Exists    ${code}
    Create Bank    ${code}    ${description}    ${alias}    ${sbp}    ${controller}    ${cnpj}

*** Test Cases ***
Cadastro Bem-Sucedido De Um Novo Banco
    [Tags]    positive
    Create Bank    BN001    Banco Nacional de Testes    BNT    12345678    Banco XYZ    12.345.678/0001-90
    Verify Bank Exists    BN001

Tentativa De Cadastro Com Código Duplicado
    [Tags]    negative
    Ensure Bank Exists    BN001    Banco Existente    BE    11111111    Banco XYZ    12.345.678/0001-90
    Create Bank    BN001    Banco Teste Duplicado    BTT    87654321    Banco XYZ    12.345.678/0001-90
    Verify Alert Message    Código já cadastrado. Por favor, informe outro.
    Verify Bank Not Exists    BN001    # o banco já existe, não deve ser recriado

Tentativa De Cadastro Com CNPJ Inválido
    [Tags]    negative
    Create Bank    BN002    Banco Inválido    BIN    87654321    Banco XYZ    12.345.678/0001-99
    Verify Alert Message    CNPJ inválido ou inexistente.
    Verify Bank Not Exists    BN002

Editar Informações De Um Banco Existente
    [Tags]    positive
    Ensure Bank Exists    BN001    Banco Original    BO    12345678    Banco XYZ    12.345.678/0001-90
    Edit Bank    BN001    Banco Nacional de Teste Atualizado    BNTU    11223344    Banco ABC    98.765.432/0001-10
    Verify Bank Exists    BN001
    # Optional: verify updated fields via page inspection
    # (ex.: check text in the row cells)

Tentar Alterar O Código De Um Banco
    [Tags]    negative
    Ensure Bank Exists    BN001    Banco Original    BO    12345678    Banco XYZ    12.345.678/0001-90
    ${row_selector}=    Set Variable    ${BANK_ROW.replace("${BANK_CODE}", "BN001")}
    Wait Until Page Contains Element    ${row_selector}    timeout=${TIMEOUT}
    Click Element    ${row_selector}
    Click Button     ${BTN_EDIT}
    Wait Until Page Contains Element    ${INPUT_CODE}    timeout=${TIMEOUT}
    Clear Element Text    ${INPUT_CODE}
    Input Text    ${INPUT_CODE}    BN002
    Click Button    ${BTN_SAVE}
    Wait Until Page Contains Element    ${BANK_LIST}    timeout=${TIMEOUT}
    Verify Bank Exists    BN001
    Verify Bank Not Exists    BN002

Salvar Edição Com CNPJ Inválido
    [Tags]    negative
    Ensure Bank Exists    BN001    Banco Original    BO    12345678    Banco XYZ    12.345.678/0001-90
    Edit Bank    BN001    Banco Atualizado    BA    11223344    Banco ABC    12.345.678/0001-99
    Verify Alert Message    CNPJ inválido ou inexistente.
    # O registro não deve ter sido alterado
    Verify Bank Exists    BN001

Salvar Banco Com CNPJ Válido
    [Tags]    positive
    Create Bank    BN003    Banco Teste Valido    BTV    11223344    Banco XYZ    12.345.678/0001-90
    Verify Bank Exists    BN003

CNPJ Com Dígitos Insuficientes
    [Tags]    negative
    Create Bank    BN004    Banco Digitos Insuficientes    BDI    11223344    Banco XYZ    12.345.678/0001-9
    Verify Alert Message    CNPJ deve conter 14 dígitos.
    Verify Bank Not Exists    BN004

CNPJ Inexistente No Cadastro Oficial
    [Tags]    negative
    Create Bank    BN005    Banco Inexistente    BIN    11223344    Banco XYZ    12.345.678/0001-99
    Verify Alert Message    CNPJ inválido ou inexistente.
    Verify Bank Not Exists    BN005
```