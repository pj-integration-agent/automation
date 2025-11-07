## 1.  Estrutura de Pastas recomendada

```
tests/
├── keywords/
│   ├── navigation.robot
│   ├── registration.robot
│   ├── login.robot
│   ├── transfer.robot
│   ├── loan.robot
│   ├── payment.robot
│   ├── account.robot
│   └── utils.robot
├── variables/
│   └── test_data.robot
└── tests.robot
```

- **keywords** – contém os *User‑Level* e *Library‑Level* *keywords* reutilizáveis.  
- **variables** – armazena dados que não variam entre execuções.  
- **tests.robot** – arquivo principal com todos os *Test Cases* organizados por Feature.

> **Obs.** Para simplificar o exemplo, os *keywords* abaixo são **pseudo‑código** – você deve substituí‑los pelos seletores reais da sua aplicação.

---

## 2.  Arquivo de Variáveis – `variables/test_data.robot`

```robot
*** Variables ***
${BASE_URL}          https://parabank.parasoft.com/parabank
${BROWSER}           Chrome
${TIMEOUT}           10s
${DELAY}             1s

# Dados de teste
${VALID_EMAIL}          usuario@exemplo.com
${VALID_PASSWORD}       senha123
${VALID_NAME}           João Silva
${VALID_CEP}            12345-678
${INVALID_EMAIL}        usuario.com
${INVALID_PHONE}        123456789
${INVALID_CEP}          00000-000
${INVALID_BALANCE}      200,00
${TRANSFER_AMOUNT}      200,00
${DEPOSIT_AMOUNT}       500,00
${LOAN_AMOUNT}          50000,00
${LOW_INCOME_LOAN}      30000,00
${HIGH_INCOME_LOAN}     150000,00
```

---

## 3.  Arquivo de *Keywords* – `keywords/navigation.robot`

```robot
*** Settings ***
Library    SeleniumLibrary    timeout=${TIMEOUT}
Resource   ../variables/test_data.robot

*** Keywords ***
Abrir Navegador
    [Arguments]    ${url}
    # Comentário: Inicia o browser e navega até a página desejada
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Fechar Navegador
    # Comentário: Fecha a sessão do navegador
    Close Browser

Navegar para Página
    [Arguments]    ${path}
    # Comentário: Navega usando a URL base
    Go To    ${BASE_URL}${path}
    Wait Until Page Contains Element    css:body

Verificar Erros HTTP
    # Comentário: Verifica se a página não retorna 404/500
    Page Should Not Contain    404
    Page Should Not Contain    500
```

---

## 4.  Arquivo de *Keywords* – `keywords/registration.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Acessar Página de Cadastro
    # Comentário: Navega até a página de registro
    Navegar para Página    /register.htm
    Wait Until Page Contains    Cadastre-se

Preencher Formulário de Cadastro
    [Arguments]    ${cep}=    ${name}=    ${email}=    ${password}=    ${confirm}=    ${phone}=
    # Comentário: Preenche cada campo do formulário
    Input Text    id:input-username    ${name}
    Input Text    id:input-email       ${email}
    Input Text    id:input-password    ${password}
    Input Text    id:input-confirm     ${confirm}
    Input Text    id:input-cep         ${cep}
    Input Text    id:input-phone       ${phone}
    Input Text    id:input-address     "Rua Teste, 123"
    Input Text    id:input-city        "São Paulo"
    Input Text    id:input-state       "SP"
    Input Text    id:input-zip         "12345-678"
    Input Text    id:input-country     "Brasil"

Clique em Cadastrar
    # Comentário: Clica no botão de submit
    Click Button    id:register-button
    Wait Until Page Contains    Cadastro concluído

Verificar Mensagem de Erro
    [Arguments]    ${campo}    ${mensagem}
    # Comentário: Verifica mensagem de erro ao lado do campo
    ${error_locator}=    Set Variable    css:#${campo}-error
    Wait Until Page Contains Element    ${error_locator}
    Element Text Should Be    ${error_locator}    ${mensagem}
```

---

## 5.  Arquivo de *Keywords* – `keywords/login.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Acessar Página de Login
    # Comentário: Navega até a página de login
    Navegar para Página    /login.htm
    Wait Until Page Contains    Entrar

Inserir Credenciais
    [Arguments]    ${email}    ${password}
    Input Text    id:input-username    ${email}
    Input Text    id:input-password    ${password}

Clique em Entrar
    Click Button    id:login-button
    Wait Until Page Contains    Dashboard

Verificar Mensagem de Erro Login
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}
```

---

## 6.  Arquivo de *Keywords* – `keywords/transfer.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Acessar Tela de Transferência
    # Comentário: Navega até a página de transferência
    Navegar para Página    /transfer.htm
    Wait Until Page Contains    Transferir

Preencher Dados de Transferência
    [Arguments]    ${destino}    ${valor}
    Input Text    id:input-amount    ${valor}
    Input Text    id:input-destination-account    ${destino}

Confirmar Transferência
    Click Button    id:transfer-submit
    Wait Until Page Contains    Transferência concluída

Verificar Saldo
    [Arguments]    ${saldo_esperado}
    Wait Until Page Contains    ${saldo_esperado}

Verificar Mensagem de Erro
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}
```

---

## 7.  Arquivo de *Keywords* – `keywords/loan.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Acessar Tela de Empréstimo
    Navegar para Página    /loan.htm
    Wait Until Page Contains    Solicitar Empréstimo

Preencher Dados de Empréstimo
    [Arguments]    ${valor}    ${renda}
    Input Text    id:input-loan-amount    ${valor}
    Input Text    id:input-annual-income  ${renda}

Enviar Solicitação
    Click Button    id:loan-submit
    Wait Until Page Contains    Empréstimo

Verificar Mensagem
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}
```

---

## 8.  Arquivo de *Keywords* – `keywords/payment.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Acessar Tela de Pagamento
    Navegar para Página    /payment.htm
    Wait Until Page Contains    Pagamento de Conta

Preencher Dados de Pagamento
    [Arguments]    ${beneficiario}    ${endereco}    ${telefone}    ${conta}    ${valor}
    Input Text    id:input-beneficiary   ${beneficiario}
    Input Text    id:input-address       ${endereco}
    Input Text    id:input-phone         ${telefone}
    Input Text    id:input-account       ${conta}
    Input Text    id:input-amount        ${valor}

Agenda Data de Pagamento
    [Arguments]    ${data}
    Input Text    id:input-payment-date   ${data}

Confirmar Pagamento
    Click Button    id:payment-submit
    Wait Until Page Contains    Pagamento confirmado

Verificar Mensagem
    [Arguments]    ${mensagem}
    Wait Until Page Contains    ${mensagem}
```

---

## 9.  Arquivo de *Keywords* – `keywords/account.robot`

```robot
*** Settings ***
Resource   ../variables/test_data.robot

*** Keywords ***
Verificar Saldo na Dashboard
    [Arguments]    ${saldo}
    # Comentário: Espera até que o saldo seja exibido
    Wait Until Page Contains    ${saldo}
```

---

## 10.  Arquivo de *Keywords* – `keywords/utils.robot`

```robot
*** Settings ***
Library   Collections

*** Keywords ***
Gerar Email Aleatório
    # Comentário: Gera um e‑mail único para cada execução
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_email}=    Set Variable    teste${timestamp}@exemplo.com
    [Return]    ${random_email}
```

---

## 11.  Test Suite Principal – `tests.robot`

```robot
*** Settings ***
Library    SeleniumLibrary    timeout=${TIMEOUT}
Resource   keywords/navigation.robot
Resource   keywords/registration.robot
Resource   keywords/login.robot
Resource   keywords/transfer.robot
Resource   keywords/loan.robot
Resource   keywords/payment.robot
Resource   keywords/account.robot
Resource   keywords/utils.robot
Variables  variables/test_data.robot

Suite Setup    Abrir Navegador    ${BASE_URL}
Suite Teardown  Fechar Navegador

*** Test Cases ***

# === US01 – Cadastro de Usuário ===
Cadastro com dados válidos
    [Documentation]    Verifica fluxo de cadastro com dados válidos
    ${email}=    Gerar Email Aleatório
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    ${VALID_CEP}    ${VALID_NAME}    ${email}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    99999-9999
    Clique em Cadastrar
    Page Should Contain    Cadastro concluído com sucesso
    # Logar com o usuário criado
    Acessar Página de Login
    Inserir Credenciais    ${email}    ${VALID_PASSWORD}
    Clique em Entrar
    Page Should Contain    Dashboard

Cadastro com campo obrigatório em branco
    [Documentation]    Verifica mensagem de erro quando o CEP está em branco
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    ${EMPTY}    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    99999-9999
    Clique em Cadastrar
    Verificar Mensagem de Erro    cep    Este campo é obrigatório.

Cadastro com e-mail inválido
    [Documentation]    Verifica validação de e‑mail
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    ${VALID_CEP}    ${VALID_NAME}    ${INVALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    99999-9999
    Clique em Cadastrar
    Verificar Mensagem de Erro    email    Formato de e‑mail inválido.

Cadastro com telefone no formato incorreto
    [Documentation]    Validação de telefone
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    ${VALID_CEP}    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    ${INVALID_PHONE}
    Clique em Cadastrar
    Verificar Mensagem de Erro    phone    Formato de telefone inválido. Use (99) 99999-9999.

Cadastro com CEP inexistente
    [Documentation]    Validação de CEP inexistente
    Acessar Página de Cadastro
    Preencher Formulário de Cadastro    ${INVALID_CEP}    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    99999-9999
    Clique em Cadastrar
    Verificar Mensagem de Erro    cep    CEP não encontrado.

# === US02 – Login de Usuário ===
Login com credenciais corretas
    [Documentation]    Valida login bem-sucedido
    Acessar Página de Login
    Inserir Credenciais    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Clique em Entrar
    Page Should Contain    Dashboard
    Verificar Saldo na Dashboard    R$ 3.245,67

Login com credenciais inválidas
    [Documentation]    Verifica mensagem de erro de credenciais inválidas
    Acessar Página de Login
    Inserir Credenciais    ${VALID_EMAIL}    senhaErrada
    Clique em Entrar
    Verificar Mensagem de Erro Login    Credenciais inválidas.

Botão 'Entrar' só habilitado quando ambos os campos preenchidos
    [Documentation]    Garante que o botão só fica habilitado quando todos os campos são preenchidos
    Acessar Página de Login
    # Senha em branco
    Input Text    id:input-username    ${VALID_EMAIL}
    Input Text    id:input-password    ${EMPTY}
    Element Should Be Disabled    id:login-button
    # Preenche senha
    Input Text    id:input-password    ${VALID_PASSWORD}
    Element Should Be Enabled      id:login-button

# === US03 – Visualização do Saldo ===
Exibição inicial do saldo na Dashboard
    [Documentation]    Confirma formato e valor do saldo na dashboard
    Acessar Página de Login
    Inserir Credenciais    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Clique em Entrar
    Page Should Contain    R$ 3.245,67

Atualização do saldo após transferência
    [Documentation]    Confirma saldo de origem e destino após transferência
    Acessar Tela de Transferência
    Preencher Dados de Transferência    9876-0    500,00
    Confirmar Transferência
    Verificar Saldo    R$ 4.500,00
    # Verifica saldo na conta destino via extrato (código fictício)
    Navegar para Página    /account/9876-0
    Page Should Contain    R$ 500,00

# === US04 – Acesso ao Extrato ===
Exibição das 10 transações mais recentes
    [Documentation]    Garante que a lista de transações contém no mínimo 10 itens
    Navegar para Página    /statement.htm
    ${qtde}=    Get Element Count    css:.transaction-row
    Should Be True    ${qtde} >= 10

Detalhes de transação ao clicar em 'Mais detalhes'
    [Documentation]    Verifica dados completos de uma transação
    Navegar para Página    /statement.htm
    Click Link    css:.transaction-row[data-desc="Transferência para João Silva"] .more-details
    Page Should Contain    Data:
    Page Should Contain    Descrição: Transferência para João Silva
    Page Should Contain    Valor: R$ 200,00
    Page Should Contain    Saldo Final: R$ 4.500,00

# === US05 – Transferência de Fundos ===
Transferência dentro do saldo disponível
    [Documentation]    Testa transferência bem-sucedida
    Acessar Tela de Transferência
    Preencher Dados de Transferência    9876-0    200,00
    Confirmar Transferência
    Verificar Saldo    R$ 800,00
    # Verifica extrato (código fictício)
    Navegar para Página    /statement.htm
    Page Should Contain    Transferência para 9876-0

Transferência com valor superior ao saldo
    [Documentation]    Garante mensagem de saldo insuficiente
    Acessar Tela de Transferência
    Preencher Dados de Transferência    9876-0    200,00
    Confirmar Transferência
    Verificar Mensagem de Erro    Saldo insuficiente

Transferência para conta inexistente
    [Documentation]    Verifica erro de conta inválida
    Acessar Tela de Transferência
    Preencher Dados de Transferência    0000-0    50,00
    Confirmar Transferência
    Verificar Mensagem de Erro    Conta destino não encontrada

# === US06 – Solicitação de Empréstimo ===
Empréstimo aprovado e creditado imediatamente
    [Documentation]    Testa aprovação de empréstimo
    Acessar Tela de Empréstimo
    Preencher Dados de Empréstimo    ${LOAN_AMOUNT}    120000,00
    Enviar Solicitação
    Verificar Mensagem    Empréstimo aprovado
    # Saldo atualizado (código fictício)
    Navegar para Página    /account/1234-5
    Page Should Contain    R$ 50.000,00

Empréstimo negado por renda insuficiente
    [Documentation]    Garante mensagem de negação por renda
    Acessar Tela de Empréstimo
    Preencher Dados de Empréstimo    ${LOW_INCOME_LOAN}    20000,00
    Enviar Solicitação
    Verificar Mensagem    Empréstimo negado: Renda insuficiente

Empréstimo negado por valor exceder limite
    [Documentation]    Garante mensagem de negação por valor
    Acessar Tela de Empréstimo
    Preencher Dados de Empréstimo    ${HIGH_INCOME_LOAN}    200000,00
    Enviar Solicitação
    Verificar Mensagem    Empréstimo negado: Valor excede limite máximo

# === US07 – Pagamento de Contas ===
Pagamento imediato de conta
    [Documentation]    Testa pagamento com saldo imediato
    Acessar Tela de Pagamento
    Preencher Dados de Pagamento    João Silva    Rua A    99999-9999    1234-5    300,00
    Agenda Data de Pagamento    hoje
    Confirmar Pagamento
    Verificar Mensagem    Pagamento confirmado
    Navegar para Página    /statement.htm
    Page Should Contain    Pagamento para 1234-5
    # Saldo debitado (código fictício)
    Verificar Saldo    R$ 200,00

Pagamento agendado futuro
    [Documentation]    Testa agendamento de pagamento
    Acessar Tela de Pagamento
    Preencher Dados de Pagamento    João Silva    Rua A    99999-9999    1234-5    300,00
    Agenda Data de Pagamento    31/12/2025
    Confirmar Pagamento
    Verificar Mensagem    Pagamento confirmado
    Navegar para Página    /statement.htm
    Page Should Contain    Pagamento para 1234-5
    Page Should Contain    Status: Agendado

Pagamento com campo obrigatório em branco
    [Documentation]    Valida mensagem de erro para telefone em branco
    Acessar Tela de Pagamento
    Preencher Dados de Pagamento    João Silva    Rua A    ${EMPTY}    1234-5    300,00
    Agenda Data de Pagamento    hoje
    Verificar Mensagem    Este campo é obrigatório.

Pagamento imediato com saldo insuficiente
    [Documentation]    Garante mensagem de saldo insuficiente
    Acessar Tela de Pagamento
    Preencher Dados de Pagamento    João Silva    Rua A    99999-9999    1234-5    300,00
    Agenda Data de Pagamento    hoje
    Confirmar Pagamento
    Verificar Mensagem    Saldo insuficiente para este pagamento

# === US08 – Navegação Consistente ===
Navegação sem erros em desktop
    [Documentation]    Verifica todas as rotas no desktop
    Navegar para Página    /
    ${menus}=    Create List    /account.htm    /transfer.htm    /loan.htm    /payment.htm    /statement.htm
    FOR    ${menu}    IN    @{menus}
        Navegar para Página    ${menu}
        Verificar Erros HTTP
    END

Navegação sem erros em dispositivos móveis
    [Documentation]    Testa a mesma navegação em viewport móvel
    # Configura viewport de 320px
    Set Window Size    320    800
    ${menus}=    Create List    /account.htm    /transfer.htm    /loan.htm    /payment.htm    /statement.htm
    FOR    ${menu}    IN    @{menus}
        Navegar para Página    ${menu}
        Verificar Erros HTTP
    END

Rota inexistente retorna erro 404
    [Documentation]    Confirma retorno 404 em rota inválida
    Navegar para Página    /contas/123456
    Page Should Contain    404

# === US09 – Mensagens de Erro Claras ===
Mensagem de erro para telefone inválido
    [Documentation]    Testa mensagem de erro de telefone
    Preencher Formulário de Cadastro    ${VALID_CEP}    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    ${INVALID_PHONE}
    Clique em Cadastrar
    Verificar Mensagem de Erro    phone    Formato de telefone inválido. Use (99) 99999-9999.

Mensagem de erro para campo obrigatório ausente
    [Documentation]    Testa mensagem de campo obrigatório em branco
    Preencher Formulário de Cadastro    ${EMPTY}    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}    ${VALID_PASSWORD}    99999-9999
    Clique em Cadastrar
    Verificar Mensagem de Erro    cep    Este campo é obrigatório.

Mensagem de erro para login inválido
    [Documentation]    Testa mensagem de login inválido
    Acessar Página de Login
    Inserir Credenciais    ${VALID_EMAIL}    senhaErrada
    Clique em Entrar
    Verificar Mensagem de Erro Login    Credenciais inválidas.

Mensagem de erro para saldo insuficiente em transferência
    [Documentation]    Testa mensagem de saldo insuficiente
    Acessar Tela de Transferência
    Preencher Dados de Transferência    9876-0    2000,00
    Confirmar Transferência
    Verificar Mensagem de Erro    Saldo insuficiente para esta transferência.
```

---

## 12.  Como executar

```bash
# Instale o Robot Framework + SeleniumLibrary
pip install robotframework robotframework-seleniumlibrary selenium

# Execute o suite completo
robot tests/tests.robot
```

---

### Observações Finais

1. **Seletores** – O código acima usa `id` e `css`. No seu projeto, prefira `data-*` ou `id`s estáveis.  
2. **Espera Implícita** – `Wait Until Page Contains` e `Wait Until Page Contains Element` são suficientes para a maioria das telas. Se necessário, ajuste `timeout`.  
3. **Dados Dinâmicos** – Use o *keyword* `Gerar Email Aleatório` para evitar colisões.  
4. **Reutilização** – Todos os *keywords* ficam em arquivos separados e são importados em `tests.robot`.  
5. **Mantenha a documentação** – Cada *Test Case* tem um `Documentation` curto explicando o objetivo. Isso facilita o entendimento futuro.  

Pronto! Agora você tem um conjunto funcional, modular e de fácil manutenção de testes automatizados em Robot Framework seguindo as melhores práticas de automação.