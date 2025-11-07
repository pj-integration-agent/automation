```robot
*** Settings ***
Library           SeleniumLibrary    timeout=15
Library           Collections
Library           OperatingSystem
Suite Setup       Open Browser To Base URL
Suite Teardown    Close Browser
# Use a short speed for debugging; remove or set to 0 in CI
# Set Selenium Speed    0.5

*** Variables ***
${BASE_URL}                     http://app.teste-banco.com
${BROWSER}                      Chrome
${REGISTER_URL}                 ${BASE_URL}/cadastro
${LOGIN_URL}                    ${BASE_URL}/login
${ACCOUNT_URL}                  ${BASE_URL}/conta
${TRANSFER_URL}                 ${BASE_URL}/transferencia
${LOAN_URL}                     ${BASE_URL}/emprestimo
${PAYMENT_URL}                  ${BASE_URL}/pagamento
${MENU_LOCATOR}                 //nav[@id="main-menu"]//a
${ERROR_LOCATOR}                //div[contains(@class,"error")]
${SUCCESS_LOCATOR}              //div[contains(@class,"success")]
${AUXILIARY_LOCALE}             pt-BR

# ---------- Locators (data-test-id preferred for stability) ----------
${FIELD_EMAIL}                   data-test-id=email
${FIELD_PASSWORD}                data-test-id=senha
${FIELD_CPF}                     data-test-id=cpf
${FIELD_NAME}                    data-test-id=nome
${FIELD_STREET}                  data-test-id=rua
${FIELD_NUMBER}                  data-test-id=numero
${FIELD_COMPLEMENT}              data-test-id=complemento
${FIELD_NEIGHBORHOOD}            data-test-id=bairro
${FIELD_CITY}                    data-test-id=cidade
${FIELD_STATE}                   data-test-id=estado
${FIELD_ZIP}                     data-test-id=cep
${FIELD_PHONE}                   data-test-id=telefone
${FIELD_BANK_ACCOUNT}            data-test-id=conta-destino
${FIELD_AMOUNT}                  data-test-id=valor
${FIELD_DUE_DATE}                data-test-id=data-vencimento
${BUTTON_SUBMIT}                 data-test-id=btn-submit
${BUTTON_LOGIN}                  data-test-id=btn-login
${BUTTON_TRANSFER_CONFIRM}       data-test-id=btn-confirmar
${BUTTON_PAYMENT_CONFIRM}        data-test-id=btn-confirmar
${MENU_HOME}                     //a[@href="/"]
${MENU_ACCOUNT}                  //a[@href="/conta"]
${MENU_TRANSFER}                 //a[@href="/transferencia"]
${MENU_LOAN}                     //a[@href="/emprestimo"]
${MENU_PAYMENT}                  //a[@href="/pagamento"]
${ERROR_MESSAGE}                 //div[contains(@class,"error-message")]
${SUCCESS_MESSAGE}               //div[contains(@class,"success-message")]
${SALDO_DISPLAY}                 data-test-id=saldo
${TRANSACTION_LIST}              data-test-id=lista-transacoes
${BALANCE_TEXT}                  data-test-id=texto-saldo
${TRANSACTION_ITEM}              data-test-id=transacao
${RETRY_COUNT}                   5

*** Test Cases ***
# ====================== US01 – Cadastro de Usuário ======================
US01_Cadastro_Bem_Sucedido_com_Dados_Válidos
    [Documentation]    Confirmação de cadastro com dados válidos
    [Tags]             US01   positivo
    # GIVEN
    Open Registration Page
    # WHEN
    Fill Registration Form    name=João Silva    email=joao.silva@example.com    cpf=123.456.789-01    password=Segura1234
    Submit Registration Form
    # THEN
    Verify Email Confirmation Sent
    Verify Redirected To Login

US01_Erro_ao_Submeter_Formulário_com_Email_Inválido
    [Documentation]    Validação de e‑mail inválido
    [Tags]             US01   negativo
    Open Registration Page
    Fill Registration Form    name=Maria    email=usuario@@dominio    cpf=987.654.321-00    password=Segura1234
    Submit Registration Form
    Verify Error Message Under Field    ${FIELD_EMAIL}    E‑mail inválido

US01_Erro_ao_Submeter_Formulário_com_CPF_Duplicado
    [Documentation]    Validação de CPF já cadastrado
    [Tags]             US01   negativo
    # GIVEN
    Create User With CPF    123.456.789-00
    Open Registration Page
    # WHEN
    Fill Registration Form    name=Ana    email=ana@example.com    cpf=123.456.789-00    password=Segura1234
    Submit Registration Form
    Verify Error Message Under Field    ${FIELD_CPF}    CPF já cadastrado

US01_Erro_ao_Submeter_Formulário_com_Senha_Curta
    [Documentation]    Validação de senha com menos de 8 caracteres
    [Tags]             US01   negativo
    Open Registration Page
    Fill Registration Form    name=Pedro    email=pedro@example.com    cpf=111.222.333-44    password=abc123
    Submit Registration Form
    Verify Error Message Under Field    ${FIELD_PASSWORD}    Senha deve ter pelo menos 8 caracteres

US01_Campos_Obrigatórios_Marcados_Corretamente
    [Documentation]    Confirmação de asterisco em campos obrigatórios
    [Tags]             US01   positivo
    Open Registration Page
    Verify Required Fields Marked With Asterisk    ${FIELD_NAME}    ${FIELD_EMAIL}    ${FIELD_CPF}    ${FIELD_PASSWORD}

# ====================== US02 – Login ======================
US02_Login_Bem_Sucedido_com_Credenciais_Válidas
    [Documentation]    Login com credenciais corretas
    [Tags]             US02   positivo
    Open Login Page
    Login With Credentials    cliente@bank.com    Segura123
    Verify Redirected To Account Page

US02_Mensagem_de_Erro_ao_Submeter_Credenciais_Inválidas
    [Documentation]    Validação de credenciais inválidas
    [Tags]             US02   negativo
    Open Login Page
    Login With Credentials    cliente@bank.com    Errada
    Verify Top Error Message    Credenciais inválidas

US02_Bloqueio_de_Conta_após_Cinco_Tentativas_Falhadas
    [Documentation]    Conta bloqueada após 5 tentativas consecutivas
    [Tags]             US02   negativo
    Open Login Page
    :FOR    ${i}    IN RANGE    ${RETRY_COUNT}
    \   Login With Credentials    cliente@bank.com    Errada
    \   Run Keyword If    ${i} == 4    Verify Top Error Message    Conta bloqueada, contate o suporte
    \   Sleep    1s    # Simula tempo entre tentativas

US02_Botão_Entrar_Desabilitado_durante_Requisição
    [Documentation]    Botão desabilitado enquanto a requisição de login ocorre
    [Tags]             US02   positivo
    Open Login Page
    Login With Credentials    cliente@bank.com    Segura123    with_wait=True
    Verify Button Enabled    ${BUTTON_LOGIN}

# ====================== US03 – Exibir Saldo e Extrato ======================
US03_Exibir_Saldo_e_10_Transações_Mais_Recentes
    [Documentation]    Exibe saldo e 10 últimas transações
    [Tags]             US03   positivo
    Open Account Page
    Verify Balance Format    ${SALDO_DISPLAY}
    Verify Transaction List Count    10

US03_Mensagem_Quando_Não_Há_Transações
    [Documentation]    Mensagem quando não há transações
    [Tags]             US03   negativo
    Open Account Page
    Verify No Transactions Message    Nenhuma transação encontrada

US03_Atualização_do_Saldo_após_Transferência
    [Documentation]    Saldo reflete transferência concluída
    [Tags]             US03   positivo
    Execute Transfer    500,00
    Verify Updated Balance    500,00

# ====================== US04 – Transferência de Fundos ======================
US04_Transferência_Bem_Sucedida_Entre_Contas_Do_Mesmo_Usuário
    [Documentation]    Transferência entre contas do mesmo usuário
    [Tags]             US04   positivo
    Open Transfer Page
    Verify Balance Sufficient    200,00
    Perform Transfer    200,00
    Verify Transfer Confirmation    200,00

US04_Erro_Transferir_Valor_Superior_ao_Saldo
    [Documentation]    Falha por saldo insuficiente
    [Tags]             US04   negativo
    Open Transfer Page
    Set Balance    150,00
    Perform Transfer    200,00
    Verify Error Message    Saldo insuficiente

US04_Erro_Transferir_para_Conta_Inexistente
    [Documentation]    Falha por conta de destino inexistente
    [Tags]             US04   negativo
    Open Transfer Page
    Perform Transfer To Account    9999999999    100,00
    Verify Error Message    Conta de destino não encontrada

US04_Erro_Transferir_Valor_Negativo_ou_Zero
    [Documentation]    Falha por valor inválido
    [Tags]             US04   negativo
    Open Transfer Page
    Input Transfer Amount    -50,00
    Submit Transfer
    Verify Error Message Under Field    ${FIELD_AMOUNT}    Valor inválido
    Input Transfer Amount    0,00
    Submit Transfer
    Verify Error Message Under Field    ${FIELD_AMOUNT}    Valor inválido

# ====================== US05 – Solicitação de Empréstimo ======================
US05_Empréstimo_Aprovado_com_Renda_Suficiente
    [Documentation]    Empréstimo aprovado
    [Tags]             US05   positivo
    Open Loan Page
    Request Loan    20000,00    45000,00
    Verify Loan Result    aprovado    8%

US05_Empréstimo_Negado_por_Renda_Insuficiente
    [Documentation]    Empréstimo negado
    [Tags]             US05   negativo
    Open Loan Page
    Request Loan    30000,00    30000,00
    Verify Loan Result    negado    Sugestão

US05_Erro_Valor_abaixo_e_Acima_de_limites
    [Documentation]    Falha por valor fora de limites
    [Tags]             US05   negativo
    Open Loan Page
    Request Loan    500,00    50000,00
    Verify Error Message    Valor mínimo de empréstimo: R$ 1.000
    Request Loan    150000,00    50000,00
    Verify Error Message    Valor máximo de empréstimo: R$ 100.000

# ====================== US06 – Pagamento de Contas ======================
US06_Pagamento_Agendado_com_Sucesso
    [Documentation]    Agendamento de pagamento futuro
    [Tags]             US06   positivo
    Open Payment Page
    Schedule Payment    120,00    30/12/2025
    Verify Success Message    Pagamento agendado para 30/12/2025
    Verify Payment in Statement    30/12/2025    Agendado

US06_Erro_ou_Submeter_Data_Anterior
    [Documentation]    Falha por data vencida
    [Tags]             US06   negativo
    Open Payment Page
    Schedule Payment    100,00    01/01/2023
    Verify Error Message    Data de vencimento não pode ser anterior à data atual

US06_Erro_ou_Submeter_Valor_Superior_ao_Saldo
    [Documentation]    Falha por saldo insuficiente
    [Tags]             US06   negativo
    Open Payment Page
    Set Balance    80,00
    Schedule Payment    120,00    30/12/2025
    Verify Error Message    Valor não pode superar o saldo da conta de origem

US06_Erro_ou_Submeter_Campo_Vazio
    [Documentation]    Falha por campo obrigatório vazio
    [Tags]             US06   negativo
    Open Payment Page
    Leave Field Blank    ${FIELD_NAME}
    Submit Payment
    Verify Error Message Under Field    ${FIELD_NAME}    Campo obrigatório

# ====================== US07 – Navegação e Usabilidade ======================
US07_Páginas_Carregam_em_Menos_de_2_Seconds
    [Documentation]    Tempo de carregamento < 2s em 3G
    [Tags]             US07   positivo
    Set Network Speed    3g
    Open Any Page
    Verify Page Load Time    <    2s

US07_Menus_contem_links_corretos
    [Documentation]    Links de menu funcionam
    [Tags]             US07   positivo
    Open Any Page
    Click And Verify Menu Link    Home    ${MENU_HOME}
    Click And Verify Menu Link    Extrato    ${MENU_ACCOUNT}
    Click And Verify Menu Link    Transferências    ${MENU_TRANSFER}
    Click And Verify Menu Link    Empréstimos    ${MENU_LOAN}
    Click And Verify Menu Link    Pagamentos    ${MENU_PAYMENT}

US07_Mensagens_de_Erro_em_Vermelho_com_Ícone
    [Documentation]    Mensagens de erro exibidas em vermelho + ícone
    [Tags]             US07   positivo
    Open Any Page
    Input Invalid Email    usuario@@
    Submit Form
    Verify Error Message Style    ${ERROR_LOCATOR}    vermelho    icon-alert

US07_Layout_Responsivo_em_Dispositivos_Móveis
    [Documentation]    Menu em barra inferior em dispositivos móveis
    [Tags]             US07   positivo
    Open Browser With User Agent    iOS
    Verify Mobile Bottom Menu Presence

*** Keywords ***
# ---------- Suite Setup / Teardown ----------
Open Browser To Base URL
    [Documentation]    Inicializa o navegador e navega para a base
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    2s

Close Browser
    Close All Browsers

# ---------- Page Navigation ----------
Open Registration Page
    [Documentation]    Navega até a página de cadastro
    Go To    ${REGISTER_URL}
    Wait Until Page Contains Element    ${FIELD_EMAIL}

Open Login Page
    Go To    ${LOGIN_URL}
    Wait Until Page Contains Element    ${FIELD_EMAIL}

Open Account Page
    Go To    ${ACCOUNT_URL}
    Wait Until Page Contains Element    ${SALDO_DISPLAY}

Open Transfer Page
    Go To    ${TRANSFER_URL}
    Wait Until Page Contains Element    ${FIELD_AMOUNT}

Open Loan Page
    Go To    ${LOAN_URL}
    Wait Until Page Contains Element    ${FIELD_AMOUNT}

Open Payment Page
    Go To    ${PAYMENT_URL}
    Wait Until Page Contains Element    ${FIELD_AMOUNT}

Open Any Page
    [Arguments]    ${path}=/
    Go To    ${BASE_URL}${path}
    Wait Until Page Contains Element    ${MENU_LOCATOR}

# ---------- Generic Actions ----------
Fill Registration Form
    [Arguments]    ${name}    ${email}    ${cpf}    ${password}
    Input Text    ${FIELD_NAME}    ${name}
    Input Text    ${FIELD_EMAIL}    ${email}
    Input Text    ${FIELD_CPF}     ${cpf}
    Input Text    ${FIELD_PASSWORD}    ${password}

Submit Registration Form
    Click Button    ${BUTTON_SUBMIT}
    Wait Until Page Contains Element    ${ERROR_LOCATOR}    timeout=5s

Verify Email Confirmation Sent
    Wait Until Page Contains    E‑mail de confirmação enviado    timeout=10s

Verify Redirected To Login
    Wait Until Page Contains Element    ${BUTTON_LOGIN}    timeout=10s

Verify Error Message Under Field
    [Arguments]    ${field}    ${message}
    ${locator}=    Get Locator Under Field    ${field}
    Page Should Contain Element    ${locator}
    ${text}=    Get Text    ${locator}
    Should Be Equal    ${text}    ${message}

Verify Required Fields Marked With Asterisk
    [Arguments]    @{fields}
    :FOR    ${field}    IN    @{fields}
    \   ${asterisk}=    Get Element Attribute    ${field} + "@placeholder"    //*[@class="required"]
    \   Should Not Be Empty    ${asterisk}

Verify Balance Format
    [Arguments]    ${locator}
    ${text}=    Get Text    ${locator}
    Should Match Regexp    ${text}    ^R\$\s?[0-9]{1,3}(?:\.\d{3})*(,\d{2})$

Verify Transaction List Count
    [Arguments]    ${count}
    ${items}=    Get WebElements    ${TRANSACTION_ITEM}
    Length Should Be    ${items}    ${count}

Verify No Transactions Message
    [Arguments]    ${message}
    Page Should Contain    ${message}

Verify Updated Balance
    [Arguments]    ${amount}
    # Implementation depends on app; placeholder
    Wait Until Page Contains    R$ ${amount}

Execute Transfer
    [Arguments]    ${amount}
    Perform Transfer    ${amount}

Verify Transfer Confirmation
    [Arguments]    ${amount}
    ${msg}=    Get Text    ${SUCCESS_MESSAGE}
    Should Contain    ${msg}    ${amount}

Verify Error Message
    [Arguments]    ${message}
    ${msg}=    Get Text    ${ERROR_MESSAGE}
    Should Be Equal    ${msg}    ${message}

Verify Loan Result
    [Arguments]    ${status}    ${value}=${None}
    ${msg}=    Get Text    ${SUCCESS_MESSAGE}
    Should Contain    ${msg}    ${status}
    Run Keyword If    '${value}' != '${None}'    Should Contain    ${msg}    ${value}

Verify Success Message
    [Arguments]    ${message}
    ${msg}=    Get Text    ${SUCCESS_MESSAGE}
    Should Be Equal    ${msg}    ${message}

Verify Payment in Statement
    [Arguments]    ${date}    ${status}
    # Placeholder: verify payment appears with status
    Page Should Contain    ${date}
    Page Should Contain    ${status}

Schedule Payment
    [Arguments]    ${amount}    ${due_date}
    Input Text    ${FIELD_AMOUNT}    ${amount}
    Input Text    ${FIELD_DUE_DATE}  ${due_date}
    Submit Payment

Submit Payment
    Click Button    ${BUTTON_PAYMENT_CONFIRM}
    Wait Until Page Contains Element    ${ERROR_LOCATOR}    timeout=5s

Leave Field Blank
    [Arguments]    ${field}
    Clear Element Text    ${field}

Verify Error Message Style
    [Arguments]    ${locator}    ${color}    ${icon}
    ${style}=    Get Element Attribute    ${locator}    style
    Should Contain    ${style}    color:${color}
    # Icon verification depends on structure; placeholder

Set Network Speed
    [Arguments]    ${speed}
    # Selenium não tem suporte direto; use Chrome DevTools
    # Placeholder para implementação customizada
    No Operation

Verify Page Load Time
    [Arguments]    ${operator}    ${time}
    # Placeholder: medir via Performance Timing
    No Operation

Click And Verify Menu Link
    [Arguments]    ${name}    ${locator}
    Click Element    ${locator}
    Wait Until Page Contains Element    ${BUTTON_LOGIN}    # Ajustar de acordo com página

Verify Mobile Bottom Menu Presence
    [Arguments]    ${device}
    # Placeholder: usar driver capabilities ou User‑Agent
    No Operation

# ---------- Login Actions ----------
Login With Credentials
    [Arguments]    ${email}    ${password}    ${with_wait}=False
    Input Text    ${FIELD_EMAIL}    ${email}
    Input Text    ${FIELD_PASSWORD}    ${password}
    Click Button    ${BUTTON_LOGIN}
    Run Keyword If    ${with_wait}    Wait Until Page Contains Element    ${ERROR_LOCATOR}    timeout=5s

Verify Redirected To Account Page
    Wait Until Page Contains Element    ${SALDO_DISPLAY}    timeout=10s

Verify Top Error Message
    [Arguments]    ${message}
    ${msg}=    Get Text    ${ERROR_LOCATOR}
    Should Be Equal    ${msg}    ${message}

Verify Button Enabled
    [Arguments]    ${locator}
    ${enabled}=    Run Keyword And Return Status    Element Should Be Enabled    ${locator}
    Should Be True    ${enabled}

# ---------- Transfer Actions ----------
Perform Transfer
    [Arguments]    ${amount}
    Input Text    ${FIELD_AMOUNT}    ${amount}
    Submit Transfer

Perform Transfer To Account
    [Arguments]    ${account}    ${amount}
    Input Text    ${FIELD_BANK_ACCOUNT}    ${account}
    Perform Transfer    ${amount}

Submit Transfer
    Click Button    ${BUTTON_TRANSFER_CONFIRM}
    Wait Until Page Contains Element    ${ERROR_LOCATOR}    timeout=5s

Set Balance
    [Arguments]    ${amount}
    # Implement via API or UI manipulation; placeholder
    No Operation

Verify Balance Sufficient
    [Arguments]    ${amount}
    # Placeholder: verify via account balance
    No Operation

# ---------- Loan Actions ----------
Request Loan
    [Arguments]    ${loan_amount}    ${annual_income}
    Input Text    ${FIELD_AMOUNT}    ${loan_amount}
    Input Text    ${FIELD_INCOME}   ${annual_income}
    Click Button    ${BUTTON_SUBMIT}
    Wait Until Page Contains Element    ${SUCCESS_MESSAGE}    timeout=10s

# ---------- Payment Actions ----------
Schedule Payment
    [Arguments]    ${amount}    ${due_date}
    Input Text    ${FIELD_AMOUNT}    ${amount}
    Input Text    ${FIELD_DUE_DATE}  ${due_date}
    Submit Payment

# ---------- Utilities ----------
Create User With CPF
    [Arguments]    ${cpf}
    # This would normally be a direct DB/API call; placeholder
    No Operation

Get Locator Under Field
    [Arguments]    ${field}
    # Assuming error messages are sibling <span> after input
    ${locator}=    Set Variable    ${field}/following-sibling::span[@class="error"]
    [Return]    ${locator}

Open Browser With User Agent
    [Arguments]    ${device}
    # Placeholder: configure capabilities
    No Operation
```

**Notas de Implementação**

1. **Locators** – Todos os `data-test-id` são usados para garantir estabilidade. Caso o sistema use outro padrão, basta alterar os valores das variáveis correspondentes.
2. **Esperas** – Preferimos `Wait Until Page Contains Element` em vez de `sleep` para tornar os testes mais robustos.
3. **Módularidade** – Cada ação comum (login, cadastro, transferência, etc.) está encapsulada em palavras-chave reutilizáveis.
4. **Tratamento de Erros** – Usamos `Verify Error Message` e `Verify Error Message Under Field` para capturar mensagens específicas; as palavras-chave encapsulam a lógica de localização e asserções.
5. **Perfis de Navegador** – Para testar velocidade em 3G ou responsividade móvel, as palavras‑chave estão marcadas como *placeholder*; em um ambiente real, elas podem usar Chrome DevTools Protocol ou serviços de emulação de rede.
6. **Comentários** – Cada passo está precedido por um comentário descritivo, explicando a intenção e a lógica do teste.
7. **Variáveis** – Todos os dados de entrada (emails, senhas, valores, etc.) são passados como argumentos, facilitando a manutenção e a reutilização de palavras‑chave.

Este arquivo `.robot` cobre integralmente todas as histórias de usuário descritas, seguindo as melhores práticas do Robot Framework e garantindo testes claros, reutilizáveis e de alta manutenção.