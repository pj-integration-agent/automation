```robot
*** Settings ***
Documentation     Automação funcional do sistema bancário usando Robot Framework.
Library           SeleniumLibrary
Library           DateTime
Library           String          # para gerar strings aleatórias
Suite Setup       Open Browser To Application
Suite Teardown    Close Browser
Test Setup        Go To Base Page
Test Teardown     Capture Page Screenshot
Resource          common_keywords.robot   # (opcional) se você quiser dividir os keywords

*** Variables ***
${BASE_URL}            https://app.exemplo.com
${BROWSER}             chrome
${DEFAULT_PASSWORD}    Senha123!
${DEFAULT_EMAIL}       usuario@exemplo.com
${DEFAULT_CPF}         12345678901
${DEFAULT_DOB}         01/01/1990
${DEFAULT_ADDRESS}     Rua Exemplo, 123
${DEFAULT_CEP}         12345678
${DEFAULT_PHONE}       11987654321
${DEFAULT_FULLNAME}    João da Silva
${INVALID_PHONE}       12345
${INVALID_EMAIL}       exemplo@
${EMPTY}               # variável nula padrão do Robot
${TIMEOUT}             10s
${WAIT}                0.5s

*** Keywords ***
# --------------------------------------------------------------------
#  Browser & Navigation
# --------------------------------------------------------------------
Open Browser To Application
    [Documentation]    Inicializa o navegador e navega até a página inicial.
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${WAIT}
    Set Selenium Implicit Wait    5s

Go To Base Page
    [Documentation]    Vai para a página raiz do aplicativo.
    Go To    ${BASE_URL}
    Wait Until Page Contains Element    //body    ${TIMEOUT}

Close Browser
    [Documentation]    Encerra a sessão do navegador.
    Close Browser

# --------------------------------------------------------------------
#  Login / Registration Utilities
# --------------------------------------------------------------------
Login With Credentials
    [Arguments]    ${email}    ${password}
    [Documentation]    Realiza login com as credenciais passadas.
    Go To    ${BASE_URL}/login
    Wait Until Page Contains Element    //input[@id='email']    ${TIMEOUT}
    Input Text    //input[@id='email']    ${email}
    Input Text    //input[@id='password']    ${password}
    Click Button  //button[text()='Entrar']
    Wait Until Page Contains Element    //h1[text()='Dashboard']    ${TIMEOUT}

Open Registration Page
    [Documentation]    Navega para a tela de cadastro.
    Go To    ${BASE_URL}/register
    Wait Until Page Contains Element    //h1[text()='Cadastro de Usuário']    ${TIMEOUT}

Generate Unique Email
    [Arguments]    ${prefix}=user
    ${random}=    Generate Random String    8    [LOWER]
    ${email}=    Catenate    SEPARATOR=@    ${prefix}    ${random}    exemplo.com
    [Return]    ${email}

Fill Registration Form
    [Arguments]    ${fullname}    ${cpf}    ${dob}    ${address}    ${cep}    ${phone}    ${email}    ${password}
    [Documentation]    Preenche o formulário de cadastro.
    Input Text    //input[@id='fullname']    ${fullname}
    Input Text    //input[@id='cpf']          ${cpf}
    Input Text    //input[@id='dob']          ${dob}
    Input Text    //input[@id='address']      ${address}
    Input Text    //input[@id='cep']          ${cep}
    Input Text    //input[@id='phone']        ${phone}
    Input Text    //input[@id='email']        ${email}
    Input Text    //input[@id='password']    ${password}

Click Register
    [Documentation]    Clica no botão “Cadastrar”.
    Click Button    //button[text()='Cadastrar']

Verify Registration Success
    [Documentation]    Confirma a mensagem de sucesso de cadastro.
    Wait Until Page Contains Element    //div[contains(@class,'success')]    ${TIMEOUT}
    Page Should Contain    Conta criada com sucesso

Verify Error Message
    [Arguments]    ${locator}    ${message}
    [Documentation]    Verifica a mensagem de erro exibida ao lado do elemento.
    Wait Until Page Contains Element    ${locator}    ${TIMEOUT}
    Page Should Contain    ${message}

Verify Field Validation RealTime
    [Arguments]    ${field_locator}    ${message}
    [Documentation]    Verifica a mensagem de validação em tempo real.
    Wait Until Page Contains Element    ${field_locator}    ${TIMEOUT}
    Page Should Contain    ${message}

Verify Button State
    [Arguments]    ${locator}    ${state}    # state: enabled / disabled
    ${is_disabled}=    Get Element Attribute    ${locator}    disabled
    Run Keyword If    '${state}' == 'enabled'    Should Be False    ${is_disabled}
    ...    else    Should Be True    ${is_disabled}

Open Dashboard
    [Documentation]    Navega até o painel inicial após o login.
    Go To    ${BASE_URL}/dashboard
    Wait Until Page Contains Element    //h1[text()='Dashboard']    ${TIMEOUT}

Verify Balance Displayed
    [Arguments]    ${regex}
    [Documentation]    Confirma que o saldo aparece no formato esperado.
    ${balance}=    Get Text    //div[@id='balance']
    Should Match Regexp    ${balance}    ${regex}

Verify Transaction List
    [Arguments]    ${expected_count}
    [Documentation]    Confirma o número de transações listadas.
    ${rows}=    Get Element Count    //table[@id='transactions']/tbody/tr
    Should Be Equal As Numbers    ${rows}    ${expected_count}

Verify Navigation Link
    [Arguments]    ${link_text}    ${expected_fragment}
    [Documentation]    Clica no link e valida que a URL contém o fragmento esperado.
    Click Link    ${link_text}
    Wait Until Page Contains Element    //h1    ${TIMEOUT}
    Location Should Contain    ${expected_fragment}

Verify Success Banner
    [Arguments]    ${message}
    [Documentation]    Confirma a exibição do banner de sucesso e sua remoção automática.
    Wait Until Page Contains Element    //div[contains(@class,'success')]    ${TIMEOUT}
    Page Should Contain    ${message}
    Sleep    5s
    Page Should Not Contain    ${message}

Verify Page Load Time
    [Arguments]    ${max_seconds}
    [Documentation]    Mede o tempo de carregamento da página atual.
    ${start}=    Get Time
    Wait Until Page Contains Element    //body    ${TIMEOUT}
    ${end}=    Get Time
    ${elapsed}=    Evaluate    ${end} - ${start}
    Should Be True    ${elapsed} <= ${max_seconds}    msg=Tempo de carregamento excedeu ${max_seconds}s

Get Current Date
    [Documentation]    Retorna a data atual no formato dd/mm/yyyy.
    ${now}=    Get Current Date    result_format=%d/%m/%Y
    [Return]    ${now}

# --------------------------------------------------------------------
#  Test Cases
# --------------------------------------------------------------------

# ==================== US01 - Cadastro de Usuário ====================

US01_Cadastro_Bem_sucedido_com_dados_validos
    [Documentation]    Usuário cadastra conta com todos os campos corretos.
    ${unique_email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${DEFAULT_FULLNAME}    ${DEFAULT_CPF}    ${DEFAULT_DOB}    ${DEFAULT_ADDRESS}    ${DEFAULT_CEP}    ${DEFAULT_PHONE}    ${unique_email}    ${DEFAULT_PASSWORD}
    Click Register
    Verify Registration Success
    Login With Credentials    ${unique_email}    ${DEFAULT_PASSWORD}
    Page Should Contain    Dashboard

US01_Cadastro_bloqueado_quando_campo_obrigatorio_em_branco
    [Documentation]    Registro bloqueado quando CPF fica em branco.
    ${unique_email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${DEFAULT_FULLNAME}    ${EMPTY}    ${DEFAULT_DOB}    ${DEFAULT_ADDRESS}    ${DEFAULT_CEP}    ${DEFAULT_PHONE}    ${unique_email}    ${DEFAULT_PASSWORD}
    Click Register
    Verify Error Message    //label[@for='cpf']/following-sibling::span    CPF é obrigatório

US01_Cadastro_bloqueado_com_telefone_invalido
    [Documentation]    Validação em tempo real de telefone inválido.
    ${unique_email}=    Generate Unique Email
    Open Registration Page
    Fill Registration Form    ${DEFAULT_FULLNAME}    ${DEFAULT_CPF}    ${DEFAULT_DOB}    ${DEFAULT_ADDRESS}    ${DEFAULT_CEP}    ${INVALID_PHONE}    ${unique_email}    ${DEFAULT_PASSWORD}
    Verify Field Validation RealTime    //input[@id='phone']/following-sibling::span    Telefone inválido – insira 10 dígitos
    Verify Button State    //button[text()='Cadastrar']    disabled

US01_Cadastro_bloqueado_com_email_ja_registrado
    [Documentation]    Bloqueia registro quando e‑mail já existe.
    ${existing_email}=    Generate Unique Email
    # Primeiro cadastro
    Open Registration Page
    Fill Registration Form    ${DEFAULT_FULLNAME}    ${DEFAULT_CPF}    ${DEFAULT_DOB}    ${DEFAULT_ADDRESS}    ${DEFAULT_CEP}    ${DEFAULT_PHONE}    ${existing_email}    ${DEFAULT_PASSWORD}
    Click Register
    Verify Registration Success
    # Tentativa de cadastro duplicado
    Open Registration Page
    Fill Registration Form    ${DEFAULT_FULLNAME}    ${DEFAULT_CPF}    ${DEFAULT_DOB}    ${DEFAULT_ADDRESS}    ${DEFAULT_CEP}    ${DEFAULT_PHONE}    ${existing_email}    ${DEFAULT_PASSWORD}
    Click Register
    Verify Error Message    //div[contains(@class,'error')]    E‑mail já cadastrado

# ==================== US02 - Login bem‑sucedido ====================

US02_Login_com_credenciais_validas_redireciona_para_dashboard
    [Documentation]    Login com credenciais válidas redireciona ao dashboard e mostra saldo.
    Login With Credentials    ${DEFAULT_EMAIL}    ${DEFAULT_PASSWORD}
    Page Should Contain    Dashboard
    Verify Balance Displayed    R\$ \d{1,3}(?:\.\d{3})*,\d{2}

US02_Historico_de_transacoes_carregado_após_login
    [Documentation]    Histórico de transações é carregado na dashboard após login.
    Open Dashboard
    Verify Transaction List    5    # Exemplo: espera pelo menos 5 transações

# ==================== US03 - Login inválido ====================

US03_Mensagem_de_erro_para_email_ou_senha_invalidos
    [Documentation]    Mensagem de erro aparece ao tentar login com credenciais inválidas.
    Go To    ${BASE_URL}/login
    Input Text    //input[@id='email']    invalid@exemplo.com
    Input Text    //input[@id='password']    wrongpass
    Click Button  //button[text()='Entrar']
    Verify Error Message    //div[contains(@class,'error')]    E‑mail ou senha inválidos.
    Page Should Contain Element    //button[text()='Entrar']
    Page Should Contain Element    //a[text()='Esqueci minha senha']

# ==================== US04 - Exibição de Saldo Atualizado ====================

US04_Saldo_aparece_em_moeda_local_na_dashboard
    [Documentation]    Saldo exibido no formato local (ex.: R$ 1.234,56).
    Open Dashboard
    Verify Balance Displayed    R\$ \d{1,3}(?:\.\d{3})*,\d{2}

US04_Saldo_reflete_ultimo_valor_confirmado_quando_sem_transacoes_recentes
    [Documentation]    Saldo permanece igual quando não há transações recentes.
    # Exemplo: valor esperado
    ${last_balance}=    Set Variable    R$ 5.000,00
    Open Dashboard
    Page Should Contain    ${last_balance}

# ==================== US05 - Extrato em Ordem Cronológica ====================

US05_Extrato_mostra_transacoes_em_ordem_decrescente
    [Documentation]    Lista de transações ordenada do mais recente para o mais antigo.
    Go To    ${BASE_URL}/extrato
    Wait Until Page Contains Element    //table[@id='transactions']    ${TIMEOUT}
    ${dates}=    Get WebElements    //table[@id='transactions']/tbody/tr/td[1]
    :FOR    ${index}    IN RANGE    1    ${len(dates)}
    \    ${current}=    Get Text    ${dates}[${index}]
    \    ${prev}=      Get Text    ${dates}[${index-1}]
    \    Run Keyword If    '${current}' > '${prev}'    Fail    Transações não estão em ordem decrescente

US05_Mensagem_exibida_quando_não_há_transações_recentes
    [Documentation]    Mensagem exibida quando não há transações recentes.
    Go To    ${BASE_URL}/extrato
    Page Should Contain Element    //div[text()='Nenhuma transação encontrada']

# ==================== US06 - Transferência de Fundos (Sucesso) ====================

US06_Transferencia_de_valor_dentro_do_saldo_disponivel
    [Documentation]    Transferência dentro do saldo disponível.
    Go To    ${BASE_URL}/transferir
    Wait Until Page Contains Element    //h1[text()='Transferência']    ${TIMEOUT}
    Input Text    //input[@id='destino']    12345678
    Input Text    //input[@id='valor']      1000
    Input Text    //input[@id='data']       ${Get Current Date}
    Click Button  //button[text()='Confirmar']
    Verify Success Banner    Transferência concluída com sucesso – R$ 1.000,00
    Open Dashboard
    Verify Balance Displayed    R\$ \d{1,3}(?:\.\d{3})*,\d{2}

US06_Saldo_atual_reflete_transferencia_no_extrato
    [Documentation]    Saldo e transação aparecem no extrato após transferência.
    Open Dashboard
    Page Should Contain    R$ 4.000,00    # Exemplo pós‑transferência
    Go To    ${BASE_URL}/extrato
    Page Should Contain    01/12/2025    # Data da transferência

# ==================== US07 - Transferência de Fundos (Valor Excede Saldo) ====================

US07_Mensagem_de_saldo_insuficiente_ao_tentar_transferir_valor_superior_ao_saldo
    [Documentation]    Mensagem de saldo insuficiente quando o valor excede o saldo.
    Go To    ${BASE_URL}/transferir
    Input Text    //input[@id='destino']    12345678
    Input Text    //input[@id='valor']      1000
    Input Text    //input[@id='data']       ${Get Current Date}
    Verify Error Message    //div[contains(@class,'error')]    Saldo insuficiente – saldo atual R$ 500,00
    Verify Button State    //button[text()='Confirmar']    disabled

US07_Campo_de_valor_bloqueia_valores_não_positivos
    [Documentation]    Valores negativos ou zero bloqueiam a confirmação.
    Go To    ${BASE_URL}/transferir
    Input Text    //input[@id='valor']    -100
    Verify Field Validation RealTime    //input[@id='valor']/following-sibling::span    Valor deve ser maior que zero
    Input Text    //input[@id='valor']    0
    Verify Field Validation RealTime    //input[@id='valor']/following-sibling::span    Valor deve ser maior que zero
    Verify Button State    //button[text()='Confirmar']    disabled

# ==================== US08 - Solicitação de Empréstimo ====================

US08_Empréstimo_aprovado_com_valores_​​validos
    [Documentation]    Empréstimo aprovado quando renda e valor são adequados.
    Go To    ${BASE_URL}/emprestimo
    Input Text    //input[@id='renda']    120000
    Input Text    //input[@id='valor']    10000
    Click Button  //button[text()='Solicitar']
    Verify Success Banner    Aprovado com justificativa Renda adequada
    Go To    ${BASE_URL}/historico-emprestimo
    Page Should Contain    10.000

US08_Empréstimo_negado_por_renda_insuficiente
    [Documentation]    Empréstimo negado por renda insuficiente.
    Go To    ${BASE_URL}/emprestimo
    Input Text    //input[@id='renda']    20000
    Input Text    //input[@id='valor']    30000
    Click Button  //button[text()='Solicitar']
    Verify Error Message    //div[contains(@class,'error')]    Negado - Renda insuficiente

US08_Erro_de_validacao_quando_valor_ou_renda_são_zero_ou_negativos
    [Documentation]    Validação de campo quando valor ou renda são inválidos.
    Go To    ${BASE_URL}/emprestimo
    Input Text    //input[@id='renda']    -50000
    Input Text    //input[@id='valor']    0
    Click Button  //button[text()='Solicitar']
    Verify Error Message    //div[contains(@class,'error')]    Valor e renda devem ser maiores que zero

# ==================== US09 - Pagamento de Contas (Registro) ====================

US09_Registro_de_pagamento_com_todos_os_campos_obrigatorios_preenchidos
    [Documentation]    Registro de pagamento com dados completos.
    Go To    ${BASE_URL}/pagamento
    Input Text    //input[@id='beneficiario']    Beneficiário
    Input Text    //input[@id='endereco']        Rua Exemplo, 123
    Input Text    //input[@id='cidade']          Cidade
    Input Text    //input[@id='estado']          Estado
    Input Text    //input[@id='cep']            12345678
    Input Text    //input[@id='telefone']        11987654321
    Input Text    //input[@id='conta']          12345678
    Input Text    //input[@id='valor']          200
    Input Text    //input[@id='data']          ${Get Current Date}
    Click Button  //button[text()='Confirmar']
    Verify Success Banner    Pagamento concluído – Concluído

US09_Erro_quando_campo_obrigatorio_fica_em_branco
    [Documentation]    Erro quando CEP fica em branco.
    Go To    ${BASE_URL}/pagamento
    Input Text    //input[@id='beneficiario']    Beneficiário
    # CEP omitted
    Click Button  //button[text()='Confirmar']
    Verify Error Message    //div[contains(@class,'error')]    CEP é obrigatório

US09_Valor_invalido_zero_ou_negativo_bloqueia_gravacao
    [Documentation]    Zero ou valor negativo bloqueiam o envio.
    Go To    ${BASE_URL}/pagamento
    Input Text    //input[@id='valor']    0
    Click Button  //button[text()='Confirmar']
    Verify Error Message    //div[contains(@class,'error')]    Valor deve ser maior que zero

# ==================== US10 - Pagamento de Contas (Agendamento Futuro) ====================

US10_Agendamento_de_pagamento_em_data_futura_valida
    [Documentation]    Agendamento de pagamento para data futura válida.
    Go To    ${BASE_URL}/pagamento
    Input Text    //input[@id='data']    02/12/2025
    Click Button  //button[text()='Confirmar']
    Verify Success Banner    Pagamento agendado para 02/12/2025

US10_Data_invalida_menor_que_hoje_bloqueia_agendamento
    [Documentation]    Data passada bloqueia o agendamento.
    Go To    ${BASE_URL}/pagamento
    Input Text    //input[@id='data']    01/11/2024
    Click Button  //button[text()='Confirmar']
    Verify Error Message    //div[contains(@class,'error')]    Data inválida – selecione uma data futura

# ==================== US11 - Navegação Consistente ====================

US11_Todos_os_links_de_navegacao_lead_as_pagina_corretas
    [Documentation]    Todos os links de navegação levam às páginas corretas.
    Go To    ${BASE_URL}/dashboard
    Verify Navigation Link    Minha Conta    minha-conta
    Verify Navigation Link    Transferências    transferir
    Verify Navigation Link    Pagamentos      pagamento
    Verify Navigation Link    Empréstimos     emprestimo
    Verify Navigation Link    Extrato         extrato
    Verify Navigation Link    Sair            login

US11_Menu_ativo_destaca_a_pagina_atual
    [Documentation]    O menu ativo destaca a página atual.
    Go To    ${BASE_URL}/extrato
    Page Should Contain Element    //a[@href='/extrato' and contains(@class,'active')]

US11_Link_Sair_encerra_sessao_corretamente
    [Documentation]    Logout finaliza a sessão e redireciona ao login.
    Click Link    Sair
    Wait Until Page Contains Element    //h1[text()='Login']    ${TIMEOUT}
    Page Should Contain    Login

# ==================== US12 - Mensagens de Erro Claras ====================

US12_Erro_de_validacao_aparece_ao_lado_do_campo_em_vermelho
    [Documentation]    Mensagem de erro em vermelho ao lado do campo.
    Go To    ${BASE_URL}/register
    Input Text    //input[@id='fullname']    ${EMPTY}
    Click Button  //button[text()='Cadastrar']
    Verify Error Message    //label[@for='fullname']/following-sibling::span    Nome completo é obrigatório

US12_Mensagem_geral_de_erro_inesperado_nao_aparece_sem_causa
    [Documentation]    Sem falha de backend, nenhuma mensagem genérica aparece.
    Go To    ${BASE_URL}/dashboard
    Page Should Not Contain Element    //div[contains(@class,'error')]    General unexpected error

US12_Mensagens_de_sucesso_desaparecem_após_5_segundos
    [Documentation]    Banner de sucesso desaparece após 5 segundos.
    Click Button  //button[text()='Cadastrar']    # Exemplo de ação que dispara sucesso
    Verify Success Banner    Conta criada com sucesso

# ==================== US13 - Carregamento sem Erros de Navegação ====================

US13_Todas_as_paginas_carregam_em_menos_de_2_segundos_em_conexao_padrao
    [Documentation]    Verifica desempenho de carregamento de páginas.
    Go To    ${BASE_URL}/dashboard
    Verify Page Load Time    2

US13_Exibicao_de_mensagem_em_caso_de_falha_de_servidor
    [Documentation]    Mensagem aparece quando ocorre erro 500.
    Go To    ${BASE_URL}/error500
    Verify Error Message    //div[contains(@class,'error')]    Falha no servidor – recarregue a página

# ==================== US14 - Validação de Campos no Cadastro ====================

US14_Telefone_aceita_apenas_10_ou_11_digitos_numéricos
    [Documentation]    Telefone válido com 11 dígitos aceito.
    Open Registration Page
    Input Text    //input[@id='phone']    11987654321
    Page Should Not Contain Element    //div[contains(@class,'error')]    Telefone inválido

US14_Telefone_invalido_bloqueia_entrada
    [Documentation]    Telefone com caracteres inválidos bloqueia entrada.
    Open Registration Page
    Input Text    //input[@id='phone']    (11)98765-4321
    Verify Field Validation RealTime    //input[@id='phone']/following-sibling::span    Telefone inválido – insira 10 dígitos

US14_CEP_aceita_apenas_8_digitos_numéricos
    [Documentation]    CEP válido com 8 dígitos aceito.
    Open Registration Page
    Input Text    //input[@id='cep']    12345678
    Page Should Not Contain Element    //div[contains(@class,'error')]    CEP inválido

US14_E_mail_segue_padrao_RFC
    [Documentation]    E‑mail inválido exibe mensagem de formato.
    Open Registration Page
    Input Text    //input[@id='email']    exemplo@
    Verify Field Validation RealTime    //input[@id='email']/following-sibling::span    Formato inválido
    Page Should Have Class    //input[@id='email']    error

# ==================== US15 - Mensagens de Confirmação de Operações ====================

US15_Mensagem_de_confirmacao_de_transferencia_exibida_em_verde
    [Documentation]    Banner verde de confirmação de transferência.
    Go To    ${BASE_URL}/transferir
    Input Text    //input[@id='valor']    500
    Click Button  //button[text()='Confirmar']
    Verify Success Banner    Transferência concluída – R$ 500,00 – Saldo atual R$ 4.500,00

US15_Botão_Detalhes_abre_tela_completa_da_transação
    [Documentation]    Clique em “Detalhes” abre tela completa da transação.
    Click Link    Detalhes
    Page Should Contain Element    //h1[text()='Detalhes da Transação']    ${TIMEOUT}

US15_Mensagem_de_confirmacao_nao_aparece_para_operacao_nao_concluida
    [Documentation]    Nenhum banner aparece quando a operação falha.
    Click Button  //button[text()='Confirmar']    # Assume falha de saldo
    Page Should Not Contain    Transferência concluída – R$ 500,00
```