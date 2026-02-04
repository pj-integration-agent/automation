```robot
*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser To Base URL
Suite Teardown    Close All Browsers
Test Setup        Go To Bank Registration Page
Test Teardown     Go To Bank List Page

# ------------------------------------------------------------------
#  Global variables
# ------------------------------------------------------------------
*** Variables ***
${BASE_URL}              https://example.com          # URL da aplicação
${BROWSER}               Chrome
${TIMEOUT}               10s                          # tempo máximo de espera por elemento
${DELAY}                 1s                           # atraso simples entre passos (evita race‑conditions)

# ------------------------------------------------------------------
#  Test Cases (cada cenário BDD vira um caso de teste)
# ------------------------------------------------------------------
*** Test Cases ***
Cadastro bem‑sucedido
    [Tags]    positive
    # Preenchendo todos os campos obrigatórios
    Fill Field By Label    Código    BN001
    Fill Field By Label    Descrição do Banco    Banco Nacional de Teste
    Fill Field By Label    Apelido    BN Teste
    Fill Field By Label    Número de inscrição no SBP    123456
    Select Dropdown By Label    Banco Controlador X
    Fill Field By Label    CNPJ    12.345.678/0001-95
    Click Button By Text    Salvar
    Verify Page Contains Message    Banco cadastrado com sucesso
    Verify Bank Present In List    BN001

Código duplicado
    [Tags]    negative
    # Pre‑condição: banco já existe
    Create Bank If Not Exists    BN001
    # Tentar criar outro com mesmo código
    Fill Field By Label    Código    BN001
    Fill Field By Label    Descrição do Banco    Outro Banco
    Fill Field By Label    Apelido    OTR
    Fill Field By Label    Número de inscrição no SBP    654321
    Select Dropdown By Label    Banco Controlador X
    Fill Field By Label    CNPJ    12.345.678/0001-95
    Click Button By Text    Salvar
    Verify Page Contains Message    Código já cadastrado
    Verify Bank Not Present In List    BN001

Campo obrigatório vazio – Descrição do Banco
    [Tags]    negative
    Fill Field By Label    Código    BN002
    # Descrição deixada vazia
    Fill Field By Label    Apelido    BN2
    Fill Field By Label    Número de inscrição no SBP    987654
    Select Dropdown By Label    Banco Controlador Y
    Fill Field By Label    CNPJ    23.456.789/0001-10
    Click Button By Text    Salvar
    Verify Page Contains Message    Descrição do Banco é obrigatória
    Page Should Contain Element    //form[@id='bankForm']   # garante que o usuário permaneceu na tela

CNPJ inválido
    [Tags]    negative
    Fill Field By Label    Código    BN003
    Fill Field By Label    Descrição do Banco    Banco com CNPJ Inválido
    Fill Field By Label    Apelido    INV
    Fill Field By Label    Número de inscrição no SBP    123123
    Select Dropdown By Label    Banco Controlador Z
    Fill Field By Label    CNPJ    123
    Click Button By Text    Salvar
    Verify Page Contains Message    CNPJ inválido ou inexistente
    Page Should Contain Element    //form[@id='bankForm']

Edição bem‑sucedida
    [Tags]    positive
    Open Bank For Edit    BN010
    Fill Field By Label    Descrição do Banco    Banco Nacional Atualizado
    # CNPJ permanece o mesmo
    Select Dropdown By Label    Banco Controlador Y
    Click Button By Text    Salvar
    Verify Page Contains Message    Banco atualizado com sucesso
    Verify Bank Present In List    BN010    Banco Nacional Atualizado

Tentativa de alterar Código
    [Tags]    negative
    Open Bank For Edit    BN020
    Fill Field By Label    Código    BN021
    Click Button By Text    Salvar
    Verify Page Contains Message    Código não pode ser alterado
    # Confirma que o código permanece o mesmo
    Element Text Should Be    //label[text()='Código']/following-sibling::input    BN020
    Page Should Contain Element    //form[@id='bankForm']   # nenhuma alteração persistida

Campo obrigatório vazio – Apelido
    [Tags]    negative
    Open Bank For Edit    BN030
    Clear Field By Label    Apelido
    Click Button By Text    Salvar
    Verify Page Contains Message    Apelido é obrigatório
    Page Should Contain Element    //form[@id='bankForm']

CNPJ inválido em edição
    [Tags]    negative
    Open Bank For Edit    BN040
    Fill Field By Label    CNPJ    123
    Click Button By Text    Salvar
    Verify Page Contains Message    CNPJ inválido ou inexistente
    Page Should Contain Element    //form[@id='bankForm']

# ------------------------------------------------------------------
#  Keywords (reutilizáveis e bem comentados)
# ------------------------------------------------------------------
*** Keywords ***
Open Browser To Base URL
    [Documentation]    Inicializa o navegador e abre a página principal
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Wait Until Page Contains Element    //a[text()='Cadastro de Bancos']    timeout=${TIMEOUT}

Go To Bank Registration Page
    [Documentation]    Navega até a tela de cadastro de bancos
    Click Link    Cadastro de Bancos
    Wait Until Page Contains Element    //form[@id='bankForm']    timeout=${TIMEOUT}

Go To Bank List Page
    [Documentation]    Navega até a lista de bancos
    Click Link    Lista de Bancos
    Wait Until Page Contains Element    //table[@id='bankList']    timeout=${TIMEOUT}

Fill Field By Label
    [Arguments]    ${label}    ${value}
    [Documentation]    Encontra um campo de entrada baseado no label e insere o valor
    ${locator}=    Set Variable    //label[normalize-space()="${label}"]/following-sibling::input
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${value}

Clear Field By Label
    [Arguments]    ${label}
    [Documentation]    Limpa um campo de entrada baseado no label
    ${locator}=    Set Variable    //label[normalize-space()="${label}"]/following-sibling::input
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Clear Element Text    ${locator}

Select Dropdown By Label
    [Arguments]    ${label}    ${option}
    [Documentation]    Seleciona um item de um dropdown baseado no label
    ${locator}=    Set Variable    //label[normalize-space()="${label}"]/following-sibling::select
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Select From List By Label    ${locator}    ${option}

Click Button By Text
    [Arguments]    ${text}
    [Documentation]    Clica em um botão cujo texto coincide
    ${button}=    Set Variable    //button[normalize-space()="${text}"]
    Wait Until Element Is Visible    ${button}    timeout=${TIMEOUT}
    Click Element    ${button}

Verify Page Contains Message
    [Arguments]    ${message}
    [Documentation]    Confirma que a mensagem esperada aparece na tela
    Wait Until Page Contains    ${message}    timeout=${TIMEOUT}

Verify Bank Present In List
    [Arguments]    ${code}    ${description}=${None}
    [Documentation]    Verifica se o banco está presente na lista de bancos
    ${row_locator}=    Set Variable    //table[@id='bankList']//tr[td[normalize-space()="${code}"]]
    Wait Until Element Is Visible    ${row_locator}    timeout=${TIMEOUT}
    Run Keyword If    '${description}' != '${None}'    Page Should Contain    ${description}

Verify Bank Not Present In List
    [Arguments]    ${code}
    [Documentation]    Confirma que o banco não está na lista
    ${row_locator}=    Set Variable    //table[@id='bankList']//tr[td[normalize-space()="${code}"]]
    Page Should Not Contain Element    ${row_locator}

Create Bank If Not Exists
    [Arguments]    ${code}
    [Documentation]    Cria um banco apenas se ele ainda não existir
    Go To Bank List Page
    ${exists}=    Run Keyword And Return Status    Page Should Contain Element    //table[@id='bankList']//tr[td[normalize-space()="${code}"]]
    Run Keyword If    not ${exists}    Cadastro bem‑sucedido   # reutiliza o caso de teste de cadastro

Open Bank For Edit
    [Arguments]    ${code}
    [Documentation]    Abre a tela de edição do banco com o código informado
    Go To Bank List Page
    # Localiza a linha que contém o código e clica no link de edição
    ${edit_link}=    Set Variable    //table[@id='bankList']//tr[td[normalize-space()="${code}"]]//a[text()='Editar']
    Wait Until Element Is Visible    ${edit_link}    timeout=${TIMEOUT}
    Click Element    ${edit_link}
    Wait Until Page Contains Element    //form[@id='bankForm']    timeout=${TIMEOUT}
```

**Notas de boas práticas**

1. **Selectors estáveis** – Os campos são localizados pelo rótulo (`<label>`), que normalmente não muda.  
2. **Espera explícita** – Cada interação aguarda que o elemento esteja visível (`Wait Until Element Is Visible`).  
3. **Reutilização de palavras-chave** – Todos os passos que repetem lógica são encapsulados em keywords legíveis, facilitando manutenção.  
4. **Separação de responsabilidade** – Setup/Teardown, navegação e validações ficam em blocos distintos.  
5. **Comentários claros** – Cada passo tem explicação breve, alinhando o teste com o BDD original.  
6. **Testes idempotentes** – O keyword `Create Bank If Not Exists` garante que o cenário de “código duplicado” seja reproduzível sem falhar por banco já existente.  

Assim, a suite está pronta para execução e pode ser integrada a pipelines de CI/CD, mantendo alta legibilidade e baixo acoplamento.