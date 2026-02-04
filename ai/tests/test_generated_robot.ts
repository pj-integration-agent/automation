**BancoTests.robot**  
*(Robot Framework – SeleniumLibrary, estrutura modular, comentários explicativos e melhores práticas de automação)*  

```robot
*** Settings ***
Documentation     Automatização dos testes de Cadastro, Edição e Validação de Bancos (US01‑US05)
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador

*** Variables ***
${URL}                        https://example.com/bancos
${BROWSER}                    Chrome
${TIMEOUT}                    10s

# ---------- Locators ----------
${CODE_INPUT}                 id=bankCode
${DESC_INPUT}                 id=bankDescription
${APELIDO_INPUT}              id=bankNickname
${SBP_INPUT}                  id=bankSBP
${CONTROLADOR_DDL}            id=bankController
${CNJP_INPUT}                 id=bankCnpj
${SAVE_BUTTON}                xpath=//button[normalize-space()='Salvar']
${SUCCESS_MSG}                css=.alert-success
${ERROR_MSG}                  css=.alert-danger
${CODE_DUP_MSG}               xpath=//div[contains(@class,'alert') and contains(text(),'Código já cadastrado')]
${CNJP_ERR_MSG}               xpath=//span[@id='cnpjError']
${APELIDO_ERR_MSG}            xpath=//span[@id='apelidoError']
${CONTROLADOR_ERR_MSG}        xpath=//span[@id='controllerError']
${BANK_LIST}                  xpath=//table[@id='bankTable']/tbody
${BANK_ROW}                   xpath=//tr[td[text()="${BANK_CODE}"]]
${BANK_SEARCH_INPUT}          id=bankSearch
${BANK_SEARCH_BTN}            id=searchBtn
${BANK_EDIT_BTN}              xpath=//tr[td[text()="${BANK_CODE}"]]//button[@class='edit']

# ---------- Test Data ----------
&{BANK_VALID}                  code=BNK001  description=Banco Nacional ABC  nickname=ABC  sbp=123456789  controller=Banco Controlador X  cnpj=12.345.678/0001-90
&{BANK_DUPLICATE}              code=BNK001  description=Banco Duplicado  nickname=Dup  sbp=987654321  controller=Banco Controlador X  cnpj=23.456.789/0001-10
&{BANK_CNJP_INVALID}           code=BNK002  description=Banco Inválido CNJP  nickname=Inválido  sbp=123456789  controller=Banco Controlador X  cnpj=00.000.000/0000-00
&{BANK_NO_NICKNAME}            code=BNK003  description=Banco Sem Apelido  nickname=  sbp=123456789  controller=Banco Controlador X  cnpj=12.345.678/0001-90
&{BANK_INVALID_CONTROLLER}     code=BNK004  description=Banco Sem Controlador Válido  nickname=SemCtrl  sbp=123456789  controller=Banco Inexistente  cnpj=12.345.678/0001-90
&{BANK_EDIT}                   code=BNK005  description=Banco X  nickname=BX  sbp=123456789  controller=Banco Controlador Y  cnpj=98.765.432/0001-11
&{BANK_EDIT_NEW_DESC}          description=Banco X Atualizado  nickname=X Upd  sbp=987654321  controller=Banco Controlador Y  cnpj=98.765.432/0001-11
&{BANK_EDIT_CNJP_INVALID}      code=BNK008  cnpj=00.000.000/0000-00
&{BANK_EDIT_NO_CONTROLLER}     code=BNK009  controller=Banco Inexistente

*** Test Cases ***
US01 - Cadastro com Dados Válidos
    [Tags]    US01    Positive
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com ${BANK_VALID}
    Then O botão Salvar deve estar habilitado
    When Clico em Salvar
    Then Devo ver a mensagem "Banco cadastrado com sucesso"
    And A lista de bancos deve incluir um registro com Código ${BANK_VALID['code']}

US01 - Código Duplicado
    [Tags]    US01    Negative
    Given Já existe um banco com Código ${BANK_DUPLICATE['code']}
    When Preencho Os Campos com ${BANK_DUPLICATE}
    Then O botão Salvar deve estar habilitado
    When Clico em Salvar
    Then Devo ver a mensagem "Código já cadastrado"
    And O registro não deve ser salvo

US01 - CNJP Inválido
    [Tags]    US01    Negative
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com ${BANK_CNJP_INVALID}
    Then Devo ver a mensagem "CNJP inválido" ao lado do campo CNJP
    And O botão Salvar permanece desabilitado

US01 - Campo Obrigatório em Branco (Apelido)
    [Tags]    US01    Negative
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com ${BANK_NO_NICKNAME}
    Then Devo ver a mensagem "Apelido é obrigatório" ao lado do campo Apelido
    And O botão Salvar permanece desabilitado

US01 - Banco Controlador Inexistente
    [Tags]    US01    Negative
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com ${BANK_INVALID_CONTROLLER}
    Then Devo ver a mensagem "Banco Controlador inválido" ao lado do campo Banco Controlador
    And O botão Salvar permanece desabilitado

US02 - Edição com Sucesso
    [Tags]    US02    Positive
    Given Existe um banco com Código ${BANK_EDIT['code']} e Descrição "${BANK_EDIT['description']}"
    When Abro a tela de edição de ${BANK_EDIT['code']}
    And Altero "Descrição" para ${BANK_EDIT_NEW_DESC['description']}
    And Altero "Apelido" para ${BANK_EDIT_NEW_DESC['nickname']}
    And Altero "Número de inscrição no SBP" para ${BANK_EDIT_NEW_DESC['sbp']}
    And Seleciono "Banco Controlador" como ${BANK_EDIT_NEW_DESC['controller']}
    And Altero "CNJP" para ${BANK_EDIT_NEW_DESC['cnpj']}
    Then O botão Salvar deve estar habilitado
    When Clico em Salvar
    Then Devo ver a mensagem "Banco atualizado com sucesso"
    And A lista de bancos deve refletir a nova descrição e CNJP

US02 - Tentativa de Alteração do Código (Somente Leitura)
    [Tags]    US02    Negative
    Given Existe um banco com Código ${BANK_EDIT['code']}
    When Abro a tela de edição de ${BANK_EDIT['code']}
    And Tento alterar o campo "Código" para "BNK007"
    Then O campo "Código" permanece não editável

US02 - CNJP Inválido na Edição
    [Tags]    US02    Negative
    Given Existe um banco com Código ${BANK_EDIT_CNJP_INVALID['code']}
    When Abro a tela de edição de ${BANK_EDIT_CNJP_INVALID['code']}
    And Altero "CNJP" para ${BANK_EDIT_CNJP_INVALID['cnpj']}
    And Preencho os demais campos com valores válidos
    Then Devo ver a mensagem "CNJP inválido" ao lado do campo CNJP
    And O botão Salvar permanece desabilitado

US02 - Banco Controlador Inexistente na Edição
    [Tags]    US02    Negative
    Given Existe um banco com Código ${BANK_EDIT_NO_CONTROLLER['code']}
    When Abro a tela de edição de ${BANK_EDIT_NO_CONTROLLER['code']}
    And Seleciono "Banco Controlador" como ${BANK_EDIT_NO_CONTROLLER['controller']}
    And Preencho os demais campos com valores válidos
    Then Devo ver a mensagem "Banco Controlador inválido" ao lado do campo Banco Controlador
    And O botão Salvar permanece desabilitado

US03 - Mensagem Instantânea de Campo Obrigatório
    [Tags]    US03    Positive
    Given Estou na tela de cadastro de bancos
    When Deixo em branco o campo "Apelido"
    Then A mensagem "Apelido é obrigatório" aparece imediatamente
    And O botão Salvar fica desabilitado
    When Escrevo "Banco Teste" no campo "Apelido"
    Then A mensagem desaparece
    And O botão Salvar fica habilitado (se demais campos válidos)

US03 - Mensagem CNJP Inválido em Tempo Real
    [Tags]    US03    Negative
    Given Estou na tela de cadastro de bancos
    When Preencho "CNJP" com "00.000.000/0000-00"
    Then A mensagem "CNJP inválido" aparece imediatamente
    And O botão Salvar permanece desabilitado

US04 - Botão Habilitado Quando Todos os Campos Válidos
    [Tags]    US04    Positive
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com
    ...    code=BNK010
    ...    description=Banco Y
    ...    nickname=Y
    ...    sbp=987654321
    ...    controller=Banco Controlador Z
    ...    cnpj=12.345.678/0001-90
    Then O botão Salvar deve estar habilitado

US04 - Botão permanece desabilitado se houver campo inválido
    [Tags]    US04    Negative
    Given Estou na tela de cadastro de bancos
    When Deixo em branco o campo "Número de inscrição no SBP"
    And Preencho os demais campos com valores válidos
    Then O botão Salvar permanece desabilitado

US04 - Botão desabilitado após remoção de valor de campo previamente válido
    [Tags]    US04    Negative
    Given Estou na tela de cadastro de bancos
    When Preencho Os Campos com
    ...    code=BNK011
    ...    description=Banco Z
    ...    nickname=Z
    ...    sbp=123456789
    ...    controller=Banco Controlador W
    ...    cnpj=12.345.678/0001-90
    Then O botão Salvar deve estar habilitado
    When Deixo em branco o campo "Apelido"
    Then O botão Salvar permanece desabilitado

US05 - Seleção Válida de Banco Controlador
    [Tags]    US05    Positive
    Given Estou na tela de cadastro de bancos
    And A lista "Banco Controlador" contém "Banco Controlador X"
    When Seleciono "Banco Controlador" como "Banco Controlador X"
    Then O campo "Banco Controlador" reflete a seleção
    And O botão Salvar permanece habilitado (se demais campos válidos)

US05 - Lista vazia de Banco Controlador
    [Tags]    US05    Negative
    Given A tabela de Bancos Controladores está vazia
    When Abro a tela de cadastro de bancos
    Then Devo ver a mensagem "Nenhum Banco Controlador disponível"
    And O botão Salvar permanece desabilitado

*** Keywords ***
Abrir Navegador
    [Documentation]    Inicializa o navegador e navega até a página de bancos.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5s
    Set Selenium Implicit Wait    ${TIMEOUT}

Fechar Navegador
    [Documentation]    Fecha o navegador.
    Close Browser

# ---------- Navegação ----------
Estou na tela de cadastro de bancos
    [Documentation]    Navega até a tela de cadastro.
    Click Element    xpath=//a[normalize-space()='Cadastrar Banco']
    Wait Until Page Contains Element    ${CODE_INPUT}    ${TIMEOUT}

# ---------- Preenchimento ----------
Preencho Os Campos com    ${fields}
    [Arguments]    ${fields}
    # Campos obrigatórios
    ${value}=    Get From Dictionary    ${fields}    code
    Preencha Campo    ${CODE_INPUT}    ${value}
    ${value}=    Get From Dictionary    ${fields}    description
    Preencha Campo    ${DESC_INPUT}    ${value}
    ${value}=    Get From Dictionary    ${fields}    nickname
    Preencha Campo    ${APELIDO_INPUT}    ${value}
    ${value}=    Get From Dictionary    ${fields}    sbp
    Preencha Campo    ${SBP_INPUT}    ${value}
    ${value}=    Get From Dictionary    ${fields}    controller
    Seleciona Banco Controlador    ${value}
    ${value}=    Get From Dictionary    ${fields}    cnpj
    Preencha Campo    ${CNJP_INPUT}    ${value}

Preencha Campo
    [Arguments]    ${locator}    ${valor}
    [Documentation]    Preenche um campo de texto e espera pelo input ser processado.
    Input Text    ${locator}    ${valor}
    # Espera explícita de debounce (ex.: 0.3s) para validação em tempo real
    Sleep    0.5s

Seleciona Banco Controlador
    [Arguments]    ${valor}
    [Documentation]    Seleciona um item de um dropdown (combobox) de Banco Controlador.
    Click Element    ${CONTROLADOR_DDL}
    Wait Until Element Is Visible    xpath=//li[normalize-space()='${valor}']    ${TIMEOUT}
    Click Element    xpath=//li[normalize-space()='${valor}']

# ---------- Interações ----------
Clico em Salvar
    [Documentation]    Clica no botão Salvar.
    Click Element    ${SAVE_BUTTON}
    Wait Until Page Does Not Contain Element    ${SAVE_BUTTON}    ${TIMEOUT}

# ---------- Validações ----------
O botão Salvar deve estar habilitado
    [Documentation]    Verifica que o botão Salvar está habilitado.
    Element Should Be Visible    ${SAVE_BUTTON}
    Element Should Be Enabled    ${SAVE_BUTTON}

O botão Salvar permanece desabilitado
    [Documentation]    Verifica que o botão Salvar está desabilitado.
    Element Should Be Visible    ${SAVE_BUTTON}
    Element Should Not Be Enabled    ${SAVE_BUTTON}

Devo ver a mensagem
    [Arguments]    ${locator}    ${texto}
    [Documentation]    Confirma que a mensagem está presente e contém o texto esperado.
    Wait Until Page Contains Element    ${locator}    ${TIMEOUT}
    Page Should Contain    ${texto}

Devo ver a mensagem "Banco cadastrado com sucesso"
    Deve Ver Mensagem    ${SUCCESS_MSG}    Banco cadastrado com sucesso

Devo ver a mensagem "Código já cadastrado"
    Deve Ver Mensagem    ${CODE_DUP_MSG}    Código já cadastrado

Devo ver a mensagem "CNJP inválido" ao lado do campo CNJP
    Deve Ver Mensagem    ${CNJP_ERR_MSG}    CNJP inválido

Devo ver a mensagem "Apelido é obrigatório" ao lado do campo Apelido
    Deve Ver Mensagem    ${APELIDO_ERR_MSG}    Apelido é obrigatório

Devo ver a mensagem "Banco Controlador inválido" ao lado do campo Banco Controlador
    Deve Ver Mensagem    ${CONTROLADOR_ERR_MSG}    Banco Controlador inválido

A lista de bancos deve incluir um registro com Código ${BANK_CODE}
    [Arguments]    ${BANK_CODE}
    [Documentation]    Confirma que a tabela de bancos contém a linha recém‑criada.
    Wait Until Page Contains Element    ${BANK_ROW}    ${TIMEOUT}
    Page Should Contain    ${BANK_CODE}

Registro Não Deve Ser Salvo
    [Arguments]    ${BANK_CODE}
    [Documentation]    Confirma que a linha não está presente na lista.
    Wait Until Page Does Not Contain    ${BANK_CODE}    timeout=5s

# ---------- Operações de Edição ----------
Abro a tela de edição de    ${BANK_CODE}
    [Arguments]    ${BANK_CODE}
    # Busca o banco e clica no botão Editar
    Input Text    ${BANK_SEARCH_INPUT}    ${BANK_CODE}
    Click Button    ${BANK_SEARCH_BTN}
    Wait Until Page Contains Element    ${BANK_EDIT_BTN}    ${TIMEOUT}
    Click Element    ${BANK_EDIT_BTN}
    Wait Until Page Contains Element    ${CODE_INPUT}    ${TIMEOUT}

Altero
    [Arguments]    ${field}    ${new_value}
    [Documentation]    Alteração de campo de texto.
    ${locator}=    Get Locator By Field    ${field}
    Preencha Campo    ${locator}    ${new_value}

Get Locator By Field
    [Arguments]    ${field}
    Switch    ${field}
    CASE    Descrição
        [Return]    ${DESC_INPUT}
    CASE    Apelido
        [Return]    ${APELIDO_INPUT}
    CASE    Número de inscrição no SBP
        [Return]    ${SBP_INPUT}
    CASE    CNJP
        [Return]    ${CNJP_INPUT}
    CASE    Banco Controlador
        [Return]    ${CONTROLADOR_DDL}
    ELSE
        Fail    Campo desconhecido: ${field}

Tento alterar o campo "Código" para ${new_code}
    [Arguments]    ${new_code}
    Preencha Campo    ${CODE_INPUT}    ${new_code}
    # Verifica se o campo permanece editável
    ${editable}=    Run Keyword And Return Status    Element Should Be Enabled    ${CODE_INPUT}
    Should Be False    ${editable}    msg=Campo Código deveria ser somente leitura

# ---------- Dados de Apoio ----------
Já existe um banco com Código ${code}
    [Arguments]    ${code}
    [Documentation]    Garantir que exista um registro para o teste de duplicidade.
    # Se o banco já existir, nada a fazer; caso contrário, cria‑o.
    # Implementação simplificada – assume que a API ou a UI está disponível.
    # Placeholder: Chamar API ou usar UI para criar o banco.

Existe um banco com Código ${code} e Descrição "${desc}"
    [Arguments]    ${code}    ${desc}
    [Documentation]    Garante que o banco exista antes de entrar na tela de edição.
    Já existe um banco com Código ${code}
    # Após a criação, valida a descrição (caso seja necessário).

A lista "Banco Controlador" contém "${value}"
    [Arguments]    ${value}
    [Documentation]    Confirma que o valor aparece na dropdown.
    Wait Until Element Is Visible    ${CONTROLADOR_DDL}    ${TIMEOUT}
    Click Element    ${CONTROLADOR_DDL}
    Wait Until Page Contains Element    xpath=//li[normalize-space()='${value}']    ${TIMEOUT}
    Click Element    ${CONTROLADOR_DDL}    # Re‑fechar dropdown

A tabela de Bancos Controladores está vazia
    [Documentation]    Garante que não exista nenhum Banco Controlador na lista.
    # Placeholder: usar API ou UI para limpar a tabela.

# ---------- Validação em Tempo Real ----------
Escrevo ${text} no campo ${field}
    [Arguments]    ${text}    ${field}
    Altero    ${field}    ${text}

# ---------- Comentários de Intenção ----------
# Cada bloco acima contém explicação detalhada do que faz:
# • "Given" prepara o ambiente (navegação, dados).
# • "When" executa ações do usuário (preencher, clicar).
# • "Then" valida resultados esperados (mensagens, estados de botões, conteúdo de lista).
# • Esperas explícitas (Wait Until ...) evitam flakiness e são preferíveis a sleeps genéricos.
# • Os locators usam atributos estáveis (id, nome, css classes) para garantir robustez.
# • As palavras-chave são altamente reutilizáveis e isolam a lógica de negócio do teste.
```

> **Como usar**  
> 1. Instale as dependências:  
>    ```bash  
>    pip install robotframework selenium  
>    ```  
> 2. Ajuste os *locators* (id, xpath, css) para refletir o seu ambiente real.  
> 3. Se precisar de dados de apoio (ex.: criar banco via API), implemente os *placeholders* em cada keyword.  
> 4. Execute:  
>    ```bash  
>    robot BancoTests.robot  
>    ```  

> **Próximos passos**  
> * Adicionar testes de API para criar/atualizar bancos e validar os dados na camada de back‑end.  
> * Expandir o *resource* `BancoKeywords.robot` para separar ainda mais a lógica de navegação da lógica de teste.  
> * Implementar *data‑driven* (CSV/Excel) para testar múltiplas combinações de dados sem duplicar código.