```robot
*** Settings ***
Library           SeleniumLibrary
Library           Collections
Suite Setup       Open Application
Suite Teardown    Close Browser
Test Setup        Reset Test Data
Test Teardown     Capture Page Screenshot

*** Variables ***
${BROWSER}                 Chrome
${URL}                     http://app.example.com
${WAIT}                    5s

# Test‑data used by the scenarios
${B001_CODE}               B001
${B002_CODE}               B002
${B003_CODE}               B003
${B001_DESC}               Banco Nacional S/A
${B001_ALIAS}              BNASA
${B001_SBP}                12345678
${B001_CNPJ}               12.345.678/0001-90
${INVALID_CNPJ}            11.222.333/4444-55
${NEW_CNPJ}                98.765.432/0001-10
${INVALID_DESC_MSG}        O campo Descrição do Banco é obrigatório
${INVALID_CODE_MSG}        O campo Código é obrigatório
${CODE_DUP_MSG}            Código já existe, escolha outro
${CNPJ_ERR_MSG}            CNPJ inválido ou não encontrado
${SUCCESS_MSG}             Banco cadastrado com sucesso
${UPDATE_SUCCESS_MSG}      Banco atualizado com sucesso
${READONLY_MSG}            Campo “Código” está em read‑only

# XPath helpers – locate elements relative to their label
#   Useful for stable selectors that do not change even if the UI layout does
#   The `following-sibling::input[1]` pattern assumes the form layout is
#   label → input/select. Adjust the XPath if the actual markup differs.
${FIELD_LABEL_XPATH}        //label[normalize-space()='${label}']/following-sibling::input[1]
${DROPDOWN_LABEL_XPATH}    //label[normalize-space()='${label}']/following-sibling::select[1]
${BANK_TABLE_ROW_XPATH}    //table//tr[td[contains(text(),'${code}')]]

*** Keywords ***
Open Application
    [Documentation]    Start a browser and open the application URL
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${BANKS_SCREEN}    timeout=${WAIT}

Reset Test Data
    [Documentation]    Make sure the test starts with a known state
    # This is a placeholder – implement any required test‑data cleanup here
    # e.g., delete banks created in previous runs or reset the DB.

# Generic helper to locate an input field by its label text
Fill Field By Label
    [Arguments]    ${label}    ${value}
    ${locator}=    Set Variable    ${FIELD_LABEL_XPATH}
    ${locator}=    Replace String    ${locator}    ${label}    ${label}
    Wait Until Element Is Visible    ${locator}    timeout=${WAIT}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${value}

# Generic helper to select an option in a dropdown by its visible text
Select Dropdown By Label
    [Arguments]    ${label}    ${option}
    ${locator}=    Set Variable    ${DROPDOWN_LABEL_XPATH}
    ${locator}=    Replace String    ${locator}    ${label}    ${label}
    Wait Until Element Is Visible    ${locator}    timeout=${WAIT}
    Select From List By Label    ${locator}    ${option}

# Click a button whose visible text matches the argument
Click Button By Text
    [Arguments]    ${button_text}
    ${locator}=    xpath=//button[normalize-space()='${button_text}']
    Wait Until Element Is Visible    ${locator}    timeout=${WAIT}
    Click Button    ${locator}
    Sleep    1s    # Wait for UI to react

# Verify a toast / message appears on the screen
Verify Message
    [Arguments]    ${expected_msg}
    Wait Until Page Contains    ${expected_msg}    timeout=${WAIT}

# Verify that a bank with a given code appears in the list
Verify Bank In List
    [Arguments]    ${bank_code}
    ${row_locator}=    Set Variable    ${BANK_TABLE_ROW_XPATH}
    ${row_locator}=    Replace String    ${row_locator}    ${bank_code}    ${bank_code}
    Wait Until Page Contains Element    ${row_locator}    timeout=${WAIT}

# Verify that a bank with a given code does NOT appear in the list
Verify Bank Not In List
    [Arguments]    ${bank_code}
    ${row_locator}=    Set Variable    ${BANK_TABLE_ROW_XPATH}
    ${row_locator}=    Replace String    ${row_locator}    ${bank_code}    ${bank_code}
    Page Should Not Contain Element    ${row_locator}

# Verify a field is read‑only
Verify Field Readonly
    [Arguments]    ${label}
    ${locator}=    Set Variable    ${FIELD_LABEL_XPATH}
    ${locator}=    Replace String    ${locator}    ${label}    ${label}
    Element Should Have Attribute    ${locator}    readonly

*** Test Cases ***
US01 – Cadastro de Novo Banco – Cadastro completo e válido
    [Tags]    US01    Positivo
    # 1️⃣  Navigate to Bancos Nacionais screen
    Go To Bancos Nacionais Screen

    # 2️⃣  Click the “Novo” button
    Click Button By Text    Novo

    # 3️⃣  Fill in all required fields
    Fill Field By Label    Código                ${B001_CODE}
    Fill Field By Label    Descrição do Banco    ${B001_DESC}
    Fill Field By Label    Apelido               ${B001_ALIAS}
    Fill Field By Label    Número de Inscrição no SBP    ${B001_SBP}
    Select Dropdown By Label    Banco Controlador    Banco Central
    Fill Field By Label    CNPJ                  ${B001_CNPJ}

    # 4️⃣  Submit the form
    Click Button By Text    Salvar

    # 5️⃣  Verify success message
    Verify Message    ${SUCCESS_MSG}

    # 6️⃣  Verify the new bank appears in the list
    Verify Bank In List    ${B001_CODE}

US01 – Cadastro de Novo Banco – Código em branco
    [Tags]    US01    Negativo
    Go To Bancos Nacionais Screen
    Click Button By Text    Novo
    # Leave "Código" empty
    Fill Field By Label    Código                ${EMPTY}
    Fill Field By Label    Descrição do Banco    ${B001_DESC}
    Fill Field By Label    Apelido               ${B001_ALIAS}
    Fill Field By Label    Número de Inscrição no SBP    ${B001_SBP}
    Select Dropdown By Label    Banco Controlador    Banco Central
    Fill Field By Label    CNPJ                  ${B001_CNPJ}
    Click Button By Text    Salvar
    Verify Message    ${INVALID_CODE_MSG}
    Verify Bank Not In List    ${B001_CODE}

US01 – Cadastro de Novo Banco – Código duplicado
    [Tags]    US01    Negativo
    # Pre‑condition: bank with code B001 already exists
    Precreate Bank    ${B001_CODE}    ${B001_DESC}    ${B001_ALIAS}    ${B001_SBP}    Banco Central    ${B001_CNPJ}
    Go To Bancos Nacionais Screen
    Click Button By Text    Novo
    Fill Field By Label    Código                ${B001_CODE}
    Fill Field By Label    Descrição do Banco    ${B001_DESC}
    Fill Field By Label    Apelido               ${B001_ALIAS}
    Fill Field By Label    Número de Inscrição no SBP    ${B001_SBP}
    Select Dropdown By Label    Banco Controlador    Banco Central
    Fill Field By Label    CNPJ                  ${B001_CNPJ}
    Click Button By Text    Salvar
    Verify Message    ${CODE_DUP_MSG}
    Verify Bank Not In List    ${B001_CODE}

US01 – Cadastro de Novo Banco – CNPJ inválido
    [Tags]    US01    Negativo
    Go To Bancos Nacionais Screen
    Click Button By Text    Novo
    Fill Field By Label    Código                ${B002_CODE}
    Fill Field By Label    Descrição do Banco    ${B001_DESC}
    Fill Field By Label    Apelido               ${B001_ALIAS}
    Fill Field By Label    Número de Inscrição no SBP    ${B001_SBP}
    Select Dropdown By Label    Banco Controlador    Banco Central
    Fill Field By Label    CNPJ                  ${INVALID_CNPJ}
    Click Button By Text    Salvar
    Verify Message    ${CNPJ_ERR_MSG}
    Verify Bank Not In List    ${B002_CODE}

US01 – Cadastro de Novo Banco – Descrição em branco
    [Tags]    US01    Negativo
    Go To Bancos Nacionais Screen
    Click Button By Text    Novo
    Fill Field By Label    Código                ${B003_CODE}
    # Leave "Descrição do Banco" empty
    Fill Field By Label    Descrição do Banco    ${EMPTY}
    Fill Field By Label    Apelido               ${B001_ALIAS}
    Fill Field By Label    Número de Inscrição no SBP    ${B001_SBP}
    Select Dropdown By Label    Banco Controlador    Banco Central
    Fill Field By Label    CNPJ                  ${B001_CNPJ}
    Click Button By Text    Salvar
    Verify Message    ${INVALID_DESC_MSG}
    Verify Bank Not In List    ${B003_CODE}

US02 – Edição de Banco Existente – Alteração de campos permitidos
    [Tags]    US02    Positivo
    # Pre‑condition
    Precreate Bank    ${B001_CODE}    ${B001_DESC}    ${B001_ALIAS}    ${B001_SBP}    Banco Central    ${B001_CNPJ}
    Go To Bancos Nacionais Screen
    # 1️⃣  Select the existing bank from the list
    Click Element    xpath=//table//tr[td[contains(text(),'${B001_CODE}')]]/td/button[text()='Editar']
    # 2️⃣  Verify pre‑filled form
    Page Should Contain Element    ${FIELD_LABEL_XPATH.replace('${label}', 'Código')}
    # 3️⃣  Alter allowed fields
    Fill Field By Label    Apelido               BNASA1
    Fill Field By Label    CNPJ                  ${NEW_CNPJ}
    # 4️⃣  Save
    Click Button By Text    Salvar
    Verify Message    ${UPDATE_SUCCESS_MSG}
    Verify Bank In List    ${B001_CODE}

US02 – Edição de Banco Existente – Tentativa de alterar Código
    [Tags]    US02    Negativo
    Precreate Bank    ${B001_CODE}    ${B001_DESC}    ${B001_ALIAS}    ${B001_SBP}    Banco Central    ${B001_CNPJ}
    Go To Bancos Nacionais Screen
    Click Element    xpath=//table//tr[td[contains(text(),'${B001_CODE}')]]/td/button[text()='Editar']
    Verify Field Readonly    Código
    # Attempt to change the code – should have no effect
    Fill Field By Label    Código                ${B002_CODE}
    Element Attribute Should Be    ${FIELD_LABEL_XPATH.replace('${label}', 'Código')}    readonly    true

US02 – Edição de Banco Existente – CNPJ inválido na edição
    [Tags]    US02    Negativo
    Precreate Bank    ${B001_CODE}    ${B001_DESC}    ${B001_ALIAS}    ${B001_SBP}    Banco Central    ${B001_CNPJ}
    Go To Bancos Nacionais Screen
    Click Element    xpath=//table//tr[td[contains(text(),'${B001_CODE}')]]/td/button[text()='Editar']
    Fill Field By Label    CNPJ                  ${INVALID_CNPJ}
    Click Button By Text    Salvar
    Verify Message    ${CNPJ_ERR_MSG}
    Verify Bank In List    ${B001_CODE}

US02 – Edição de Banco Existente – Campo obrigatório deixado em branco
    [Tags]    US02    Negativo
    Precreate Bank    ${B001_CODE}    ${B001_DESC}    ${B001_ALIAS}    ${B001_SBP}    Banco Central    ${B001_CNPJ}
    Go To Bancos Nacionais Screen
    Click Element    xpath=//table//tr[td[contains(text(),'${B001_CODE}')]]/td/button[text()='Editar']
    # Clear required field "Apelido"
    Fill Field By Label    Apelido               ${EMPTY}
    Click Button By Text    Salvar
    Verify Message    O campo Apelido é obrigatório
    Verify Bank In List    ${B001_CODE}

*** Keywords ***
Go To Bancos Nacionais Screen
    [Documentation]    Navigate to the “Bancos Nacionais” page
    Click Link    xpath=//nav//a[normalize-space()='Bancos Nacionais']
    Wait Until Page Contains Element    ${BANKS_SCREEN}    timeout=${WAIT}

# Helper for creating a bank directly (e.g., via API or DB seeding)
Precreate Bank
    [Arguments]    ${code}    ${desc}    ${alias}    ${sbp}    ${controller}    ${cnpj}
    # Implement the real pre‑creation logic here – this is a stub
    # For example, call a REST endpoint or run a DB script.
    # The keyword should leave the UI in a clean state before each test.
    Log    Pre‑creating bank: ${code}
    # ... implementation goes here ...

# Dummy locator for the page header – replace with actual selector
${BANKS_SCREEN}    xpath=//h1[normalize-space()='Bancos Nacionais']
```

### Explicação rápida

1. **Estrutura**  
   * **Settings**: importa as bibliotecas, define setup/teardown.  
   * **Variables**: contém os valores usados em todos os testes, facilitando alterações futuras.  
   * **Keywords**: encapsulam ações repetitivas (preencher campo, selecionar dropdown, clicar botão, etc.).  
   * **Test Cases**: cada cenário Gherkin vira um caso legível, com comentários claros antes de cada bloco de ações.

2. **Seletores estáveis**  
   * Os *locators* são baseados em rótulos (`label`) e não em posições relativas ao DOM, reduzindo a fragilidade do teste.  
   * Se o HTML mudar, basta ajustar um único XPath em vez de vários testes.

3. **Sincronização**  
   * `Wait Until Element Is Visible` e `Wait Until Page Contains` garantem que o teste só prossegue quando os elementos estão prontos.  
   * Um pequeno `Sleep` após ações que provocam mudança de estado (ex.: `Click Button By Text`) evita flutuações.

4. **Manutenção**  
   * Cada passo tem um comentário que explica a intenção.  
   * Palavras‑chave reutilizáveis permitem que mudanças de UI sejam refletidas em poucos pontos.

5. **Pre‑e‑condições**  
   * O keyword `Precreate Bank` é um placeholder para criar um banco antes de testar a edição ou duplicidade.  
   * Implementar essa lógica com chamadas de API ou scripts de banco garante que os testes são independentes e repetíveis.

Com essa estrutura, os testes permanecem claros, fáceis de manter e extensíveis para novas funcionalidades.