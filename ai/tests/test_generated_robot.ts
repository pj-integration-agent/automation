**BankAutomation.robot**

```robot
*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           OperatingSystem
Suite Setup       Open Browser To Base URL
Suite Teardown    Close Browser
Test Setup        Maximize Browser Window
Test Teardown     Capture Page Screenshot

# ------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------
*** Variables ***
${BASE_URL}               https://app.example.com/banks
${BROWSER}                Chrome
${DEFAULT_TIMEOUT}        10s
${WAIT}                   1s          # generic short wait for UI to settle

# Page‑level locators – keep them stable and readable
# ------------------------------------------------------------------
# List page
${BANKS_LINK}             xpath=//a[normalize-space()='Bancos']
${NEW_BUTTON}             xpath=//button[normalize-space()='Novo']
${EDIT_BUTTON}            xpath=//tr[td[normalize-space()='${BANK_CODE}']]//button[normalize-space()='Editar']

# Edit / New screen
${FIELD_CODE}             xpath=//input[@id='bankCode']
${FIELD_DESCRIPTION}     xpath=//input[@id='bankDescription']
${FIELD_NICKNAME}         xpath=//input[@id='bankNickname']
${FIELD_SBP}              xpath=//input[@id='bankSBP']
${FIELD_CONTROLLER}       xpath=//select[@id='bankController']
${FIELD_CNPJ}             xpath=//input[@id='bankCNPJ']
${SAVE_BUTTON}            xpath=//button[normalize-space()='Salvar']
${CANCEL_BUTTON}          xpath=//button[normalize-space()='Cancelar']

# Messages
${SUCCESS_MSG}            xpath=//div[contains(@class,'alert-success')]
${ERROR_MSG}              xpath=//div[contains(@class,'alert-danger')]
${FIELD_ERROR}            xpath=//span[@class='error']

# ------------------------------------------------------------------
# Test Cases
# ------------------------------------------------------------------

*** Test Cases ***

Open New Bank Screen
    [Documentation]    Open the bank list page and click “Novo” to display the
    ...                 new bank registration form.
    # Step 1 – Go to banks list
    Go To Bank List
    # Step 2 – Click “Novo”
    Click Element    ${NEW_BUTTON}
    Sleep            ${WAIT}
    # Step 3 – Verify form displayed
    Wait Until Page Contains Element    ${FIELD_CODE}    timeout=${DEFAULT_TIMEOUT}
    # Step 4 – Verify mandatory fields marked with '*'
    Element Should Contain    ${FIELD_DESCRIPTION}    *
    Element Should Contain    ${FIELD_CNPJ}          *

Register New Bank With All Valid Fields
    [Documentation]    Create a brand‑new bank providing valid data in every
    ...                 required field and verify success.
    Go To Bank List
    Click Element    ${NEW_BUTTON}
    Sleep            ${WAIT}
    # Fill all fields
    Fill Field       ${FIELD_CODE}          BAN001
    Fill Field       ${FIELD_DESCRIPTION}  Banco do Norte
    Fill Field       ${FIELD_NICKNAME}      Norte
    Fill Field       ${FIELD_SBP}           12345678
    Select From List By Label    ${FIELD_CONTROLLER}    Banco Central
    Fill Field       ${FIELD_CNPJ}          12.345.678/0001-95
    # Submit
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    # Verify success message
    Page Should Contain Element    ${SUCCESS_MSG}
    Page Should Contain             Banco cadastrado com sucesso.
    # Verify bank appears in list
    Verify Bank In List    BAN001

Attempt To Create Bank With Duplicate Code
    [Documentation]    Try to register a bank using an already existing code
    ...                 and confirm that the application blocks it.
    Go To Bank List
    Click Element    ${NEW_BUTTON}
    Sleep            ${WAIT}
    Fill Field       ${FIELD_CODE}          BAN001   # already exists
    Fill Field       ${FIELD_DESCRIPTION}  Banco de Teste
    Fill Field       ${FIELD_NICKNAME}      Teste
    Fill Field       ${FIELD_SBP}           87654321
    Select From List By Label    ${FIELD_CONTROLLER}    Banco Central
    Fill Field       ${FIELD_CNPJ}          12.345.678/0001-95
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${ERROR_MSG}
    Page Should Contain             O código informado já está em uso. Por favor, informe outro.

Attempt To Create Bank With Invalid CNPJ
    [Documentation]    Try to register a bank supplying an invalid CNPJ.
    Go To Bank List
    Click Element    ${NEW_BUTTON}
    Sleep            ${WAIT}
    Fill Field       ${FIELD_CNPJ}          12.345.678/0001-00   # invalid
    Fill Field       ${FIELD_CODE}          BAN002
    Fill Field       ${FIELD_DESCRIPTION}  Banco do Teste
    Fill Field       ${FIELD_NICKNAME}      Teste
    Fill Field       ${FIELD_SBP}           87654321
    Select From List By Label    ${FIELD_CONTROLLER}    Banco Central
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${ERROR_MSG}
    Page Should Contain             CNPJ inválido. Por favor, informe um CNPJ válido.

Attempt To Create Bank Without Mandatory Field
    [Documentation]    Leave the mandatory “Descrição do Banco” field empty and
    ...                 ensure an error is shown.
    Go To Bank List
    Click Element    ${NEW_BUTTON}
    Sleep            ${WAIT}
    # Leave Description blank
    Clear Element Text    ${FIELD_DESCRIPTION}
    Fill Field       ${FIELD_CODE}          BAN003
    Fill Field       ${FIELD_NICKNAME}      Teste
    Fill Field       ${FIELD_SBP}           87654321
    Select From List By Label    ${FIELD_CONTROLLER}    Banco Central
    Fill Field       ${FIELD_CNPJ}          12.345.678/0001-95
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${ERROR_MSG}
    Page Should Contain             Descrição do Banco é obrigatória.

Open Edit Screen And Verify Code Read‑Only
    [Documentation]    Open the edit screen for BAN001 and verify that the
    ...                 code field is read‑only.
    Go To Bank List
    ${BANK_CODE}=    Set Variable    BAN001
    Click Edit Of Bank    ${BANK_CODE}
    Sleep            ${WAIT}
    # Verify that the field is disabled
    Element Should Be Disabled    ${FIELD_CODE}
    # Verify other fields are pre‑filled (simple check on the code)
    Element Attribute Value Should Be    ${FIELD_CODE}    value    BAN001

Edit Bank Maintaining Code
    [Documentation]    Update BAN001’s description, nickname, SBP number,
    ...                 controller and CNPJ while keeping the same code.
    Go To Bank List
    ${BANK_CODE}=    Set Variable    BAN001
    Click Edit Of Bank    ${BANK_CODE}
    Sleep            ${WAIT}
    # Change values
    Input Text       ${FIELD_DESCRIPTION}   Banco do Sul
    Input Text       ${FIELD_NICKNAME}      Sul
    Input Text       ${FIELD_SBP}           87654321
    Select From List By Label    ${FIELD_CONTROLLER}    Banco Regional
    Input Text       ${FIELD_CNPJ}          98.765.432/0001-10
    # Submit
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${SUCCESS_MSG}
    Page Should Contain             Banco atualizado com sucesso.
    # Verify the bank still appears with same code
    Verify Bank In List    BAN001

Attempt To Change Bank Code
    [Documentation]    Try to change BAN001’s code and confirm it is ignored.
    Go To Bank List
    ${BANK_CODE}=    Set Variable    BAN001
    Click Edit Of Bank    ${BANK_CODE}
    Sleep            ${WAIT}
    # Attempt to change the code
    Input Text       ${FIELD_CODE}    NOVOCOD
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    # Verify code remains unchanged
    Element Attribute Value Should Be    ${FIELD_CODE}    value    BAN001
    # No error message should appear
    Page Should Not Contain Element    ${ERROR_MSG}

Attempt To Save Bank With Invalid CNPJ After Edit
    [Documentation]    Update BAN001’s CNPJ to an invalid value and ensure
    ...                 validation error appears.
    Go To Bank List
    ${BANK_CODE}=    Set Variable    BAN001
    Click Edit Of Bank    ${BANK_CODE}
    Sleep            ${WAIT}
    Input Text       ${FIELD_CNPJ}    11.111.111/1111-11   # invalid
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${ERROR_MSG}
    Page Should Contain             CNPJ inválido. Por favor, informe um CNPJ válido.

Attempt To Save Bank With Mandatory Field Empty After Edit
    [Documentation]    Leave the mandatory “Apelido” field blank and confirm
    ...                 an error is shown.
    Go To Bank List
    ${BANK_CODE}=    Set Variable    BAN001
    Click Edit Of Bank    ${BANK_CODE}
    Sleep            ${WAIT}
    Clear Element Text    ${FIELD_NICKNAME}
    Click Element    ${SAVE_BUTTON}
    Sleep            ${WAIT}
    Page Should Contain Element    ${ERROR_MSG}
    Page Should Contain             Apelido é obrigatório.

# ------------------------------------------------------------------
# Keywords
# ------------------------------------------------------------------

*** Keywords ***

Open Browser To Base URL
    [Documentation]    Open a fresh browser instance and navigate to the
    ...                 base bank page.
    Open Browser    ${BASE_URL}    ${BROWSER}    options=--start-maximized
    Maximize Browser Window
    Set Selenium Speed    0s
    Set Selenium Implicit Wait    ${DEFAULT_TIMEOUT}

Go To Bank List
    [Documentation]    Navigate to the banks list page.
    Wait Until Page Contains Element    ${BANKS_LINK}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${BANKS_LINK}
    Wait Until Page Contains Element    ${NEW_BUTTON}    timeout=${DEFAULT_TIMEOUT}

Click Edit Of Bank
    [Arguments]    ${bank_code}
    [Documentation]    Click the Edit button of the specified bank.
    # Replace the placeholder in the locator with the actual code
    ${locator}=    Set Variable    xpath=//tr[td[normalize-space()='${bank_code}']]//button[normalize-space()='Editar']
    Wait Until Page Contains Element    ${locator}    timeout=${DEFAULT_TIMEOUT}
    Click Element    ${locator}
    Wait Until Page Contains Element    ${FIELD_CODE}    timeout=${DEFAULT_TIMEOUT}

Fill Field
    [Arguments]    ${locator}    ${value}
    [Documentation]    Clear the field and type a new value.
    Wait Until Page Contains Element    ${locator}    timeout=${DEFAULT_TIMEOUT}
    Clear Element Text    ${locator}
    Input Text            ${locator}    ${value}

Verify Bank In List
    [Arguments]    ${bank_code}
    [Documentation]    Confirm that a row with the given code appears in the list.
    ${row_locator}=    Set Variable    xpath=//tr[td[normalize-space()='${bank_code}']]
    Page Should Contain Element    ${row_locator}
``` 

### Explicação resumida
1. **Imports & Variables** – Importamos SeleniumLibrary e outras utilidades, definimos URL, navegador, tempos de espera e todos os seletores mais estáveis.
2. **Test Setup / Teardown** – Cada teste abre um navegador limpo, navega para a página base, tira screenshot de falhas e fecha o navegador no fim.
3. **Test Cases** – Cada cenário BDD é convertido em um caso de teste Robot, com passos comentados que refletem a intenção de cada Gherkin step.
4. **Keywords** – Implementamos uma série de *keywords* reutilizáveis (abrir página, ir à lista, clicar “Novo”, preencher campos, etc.) que encapsulam a lógica e garantem modularidade.
5. **Esperas & Tratamento de Erros** – Utilizamos `Wait Until Page Contains Element`, `Sleep` moderado e verificações de mensagens para garantir que a UI tenha tempo de reagir antes de prosseguir.
6. **Seletores Estáveis** – Locadores XPath usam textos explícitos, IDs e atributos, facilitando a manutenção quando a UI mudar.
7. **Comentários** – Cada passo de teste possui um comentário claro explicando sua finalidade.

O arquivo acima pode ser executado com `robot BankAutomation.robot` e cobre todos os cenários positivos e negativos descritos no arquivo BDD original.