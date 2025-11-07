**titulo: US01 – Cadastro de cliente bancário**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Cadastro bem‑sucedido com todos os campos válidos  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Cadastro de cliente
Scenario: Cadastro bem-sucedido com dados válidos
  Given o usuário acessa a tela de cadastro
  When preenche todos os campos obrigatórios com dados válidos
  And clica no botão "Registrar"
  Then a mensagem "Cadastro concluído!" é exibida
  And o usuário é redirecionado para a tela de login
  And um e‑mail de confirmação é enviado com link de ativação
  ```

&nbsp;&nbsp;- **nome:** Erro de e‑mail inválido no cadastro  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Cadastro de cliente
Scenario: Cadastro com e‑mail inválido
  Given o usuário acessa a tela de cadastro
  When preenche todos os campos obrigatórios com e‑mail "usuario[sem]@exemplo.com"
  And clica no botão "Registrar"
  Then a mensagem de erro "E‑mail inválido" aparece ao lado do campo e‑mail
  And o cadastro não é concluído
  ```

&nbsp;&nbsp;- **nome:** Tentativa de login antes de ativação da conta  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Cadastro de cliente
Scenario: Login antes de ativar a conta
  Given o usuário já concluiu o cadastro mas ainda não clicou em "Ativar conta" no e‑mail
  When tenta fazer login com e‑mail cadastrado e senha correta
  Then a mensagem "Conta não ativada. Verifique seu e‑mail" é exibida
  ```

---

**titulo: US02 – Recuperação de senha**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Recuperação de senha com e‑mail existente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Recuperação de senha
Scenario: Envio de link de redefinição para e‑mail existente
  Given o usuário acessa a tela de login
  When clica em "Esqueci minha senha"
  And insere e‑mail "cliente@exemplo.com"
  And confirma envio
  Then o sistema envia e‑mail com link de redefinição
  ```

&nbsp;&nbsp;- **nome:** Recuperação com e‑mail não cadastrado  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Recuperação de senha
Scenario: E‑mail não cadastrado
  Given o usuário acessa a tela de recuperação
  When insere e‑mail "inexistente@exemplo.com"
  And confirma envio
  Then a mensagem "E‑mail não cadastrado" é exibida
  ```

&nbsp;&nbsp;- **nome:** Link de redefinição expirado (15 min)  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Recuperação de senha
Scenario: Link de redefinição expirado
  Given o usuário recebeu link de redefinição
  When espera 16 minutos e tenta usar o link
  Then a mensagem "Link expirado. Solicite um novo" é exibida
  ```

&nbsp;&nbsp;- **nome:** Redefinição de senha válida  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Recuperação de senha
Scenario: Redefinição de senha dentro do prazo
  Given o usuário tem link de redefinição válido
  When abre o link e define nova senha "Senha123!"
  And confirma
  Then a mensagem "Senha redefinida com sucesso" é exibida
  And o usuário pode logar com a nova senha
  ```

---

**titulo: US03 – Login com credenciais válidas**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Login com credenciais corretas  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Login
Scenario: Login bem‑sucedido
  Given o usuário está na tela de login
  When entra e‑mail "cliente@exemplo.com"
  And senha "SenhaSegura123"
  And clica em "Entrar"
  Then o usuário é redirecionado para o Dashboard
  And o saldo e extrato são exibidos
  ```

&nbsp;&nbsp;- **nome:** Login com senha incorreta  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Login
Scenario: Senha inválida
  Given o usuário está na tela de login
  When entra e‑mail "cliente@exemplo.com"
  And senha "SenhaErrada"
  And clica em "Entrar"
  Then a mensagem "Credenciais inválidas. Tente novamente." é exibida
  ```

&nbsp;&nbsp;- **nome:** Conta bloqueada após cinco tentativas falhas  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Login
Scenario: Conta bloqueada após 5 falhas
  Given o usuário tenta logar 5 vezes com senha incorreta
  When a sexta tentativa é feita
  Then a mensagem "Conta bloqueada. Entre em contato com o suporte." é exibida
  ```

---

**titulo: US04 – Visualização do saldo atualizado**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Saldo exibido corretamente na inicialização  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Saldo da conta
Scenario: Exibição de saldo inicial
  Given o usuário está no Dashboard
  Then o saldo exibido corresponde ao valor presente na base de dados
  ```

&nbsp;&nbsp;- **nome:** Saldo atualizado após transferência  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Saldo da conta
Scenario: Saldo após transferência interna
  Given o usuário realizou transferência de R$ 200,00 para outra conta própria
  When retorna ao Dashboard
  Then o saldo diminui em R$ 200,00
  And o saldo não fica negativo
  ```

&nbsp;&nbsp;- **nome:** Bloqueio de transação quando saldo insuficiente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Saldo da conta
Scenario: Tentativa de transferência com saldo insuficiente
  Given o saldo atual é R$ 100,00
  When tenta transferir R$ 150,00
  Then a mensagem "Saldo insuficiente – saldo atual: R$ 100,00" é exibida
  And a transferência não ocorre
  ```

---

**titulo: US05 – Visualização do extrato em ordem cronológica**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Exibição das 20 transações mais recentes  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Extrato
Scenario: Lista das 20 transações mais recentes
  Given o usuário abre a página de extrato
  Then as primeiras 20 linhas exibem transações em ordem decrescente de data/hora
  And cada linha contém data, descrição, valor e saldo pós‑transação
  ```

&nbsp;&nbsp;- **nome:** Paginação de extrato após 20 transações  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Extrato
Scenario: Paginação de extrato
  Given existem mais de 20 transações
  When o usuário clica em "Ver mais"
  Then as próximas 20 transações são carregadas
  ```

---

**titulo: US06 – Transferência entre contas**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Transferência interna bem‑sucedida  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Transferência
Scenario: Transferência interna
  Given o usuário possui Conta A com saldo R$ 1.000,00
  When seleciona Conta A como origem e Conta B como destino
  And insere valor R$ 300,00
  And confirma a transferência
  Then o saldo de Conta A passa a ser R$ 700,00
  And o saldo de Conta B passa a ser R$ 300,00
  And a transação aparece no extrato de ambas as contas
  ```

&nbsp;&nbsp;- **nome:** Transferência bloqueada por saldo insuficiente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Transferência
Scenario: Transferência com saldo insuficiente
  Given o usuário possui saldo de R$ 100,00 na Conta A
  When tenta transferir R$ 200,00 para Conta B
  Then a mensagem "Saldo insuficiente" é exibida
  And a transferência não é realizada
  ```

&nbsp;&nbsp;- **nome:** Transferência para conta externa  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Transferência
Scenario: Transferência externa
  Given o usuário possui Conta A com saldo suficiente
  When seleciona Conta A como origem e conta externa cadastrada como destino
  And confirma a transferência
  Then a transferência é registrada no extrato da conta externa
  ```

&nbsp;&nbsp;- **nome:** Valor inválido (número negativo) na transferência  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Transferência
Scenario: Valor negativo na transferência
  Given o usuário tenta transferir -R$ 50,00
  When confirma a operação
  Then a mensagem "Valor inválido" é exibida
  And a transferência não é processada
  ```

---

**titulo: US07 – Aprovação de pedido de empréstimo**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Empréstimo aprovado com renda suficiente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Empréstimo
Scenario: Empréstimo aprovado
  Given o usuário preenche valor R$ 10.000,00 e renda anual R$ 80.000,00
  When envia o formulário
  Then a mensagem "Aprovado" aparece em destaque
  And a solicitação fica registrada no histórico de empréstimos
  ```

&nbsp;&nbsp;- **nome:** Empréstimo negado por renda insuficiente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Empréstimo
Scenario: Negação por renda insuficiente
  Given o usuário preenche renda anual R$ 20.000,00
  When envia o formulário
  Then a mensagem "Negado – Renda insuficiente" é exibida
  And a solicitação permanece no histórico com status negado
  ```

&nbsp;&nbsp;- **nome:** Empréstimo negado por baixo score de crédito  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Empréstimo
Scenario: Negação por score de crédito baixo
  Given o usuário possui score de crédito 300
  When envia pedido de R$ 5.000,00
  Then a mensagem "Negado – Score de crédito baixo" é exibida
  ```

---

**titulo: US08 – Pagamento de contas agendado**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Agendamento de pagamento futuro  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Pagamento agendado
Scenario: Agendamento com data futura
  Given o usuário acessa a tela de pagamentos
  When preenche todos os campos obrigatórios
  And define data de pagamento 5 dias depois da data atual
  And salva
  Then a mensagem "Pagamento agendado para DD/MM/AAAA" é exibida
  And o pagamento aparece no extrato na data programada
  ```

&nbsp;&nbsp;- **nome:** Erro ao selecionar data no passado  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Pagamento agendado
Scenario: Data de pagamento no passado
  Given o usuário define data de pagamento 2 dias antes da data atual
  When salva
  Then a mensagem "Data de pagamento não pode ser anterior à data atual" é exibida
  ```

&nbsp;&nbsp;- **nome:** Falha por campo obrigatório em falta  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Pagamento agendado
Scenario: Campo obrigatório ausente
  Given o usuário deixa o campo "Valor" em branco
  When tenta salvar
  Then a mensagem de erro "Valor é obrigatório" aparece ao lado do campo
  ```

&nbsp;&nbsp;- **nome:** Execução automática na data agendada  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Pagamento agendado
Scenario: Execução automática
  Given existe pagamento agendado para data DD/MM/AAAA
  When a data atual chega a DD/MM/AAAA
  Then o sistema debita automaticamente R$ X na conta do usuário
  And a transação aparece no extrato
  ```

---

**titulo: US09 – Navegação sem erros 404**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Navegação entre páginas não gera 404  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Navegação
Scenario: Navegação entre páginas
  Given o usuário está em qualquer página
  When clica em cada link do menu principal
  Then nenhuma página retorna erro 404
  And a mesma estrutura de header/footer permanece consistente
  ```

---

**titulo: US10 – Mensagens de erro claras e objetivas**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Mensagem de campo inválido  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Mensagens de erro
Scenario: Campo telefone inválido
  Given o usuário preenche telefone "1234"
  When tenta registrar
  Then a mensagem "Telefone inválido – ex.: (11) 91234-5678" aparece ao lado do campo
  ```

&nbsp;&nbsp;- **nome:** Mensagem de login inválido  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Mensagens de erro
Scenario: Credenciais inválidas no login
  Given o usuário tenta logar com senha errada
  Then a mensagem "Credenciais inválidas. Tente novamente." aparece no topo da tela
  ```

&nbsp;&nbsp;- **nome:** Mensagem de saldo insuficiente  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** negativo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Mensagens de erro
Scenario: Saldo insuficiente na transferência
  Given o saldo atual é R$ 50,00
  When tenta transferir R$ 100,00
  Then a mensagem "Saldo insuficiente – saldo atual: R$ 50,00" aparece
  ```

---

**titulo: US11 – Consistência de menus e links**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Menus idênticos em todas as páginas  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Menus consistentes
Scenario: Verificação de menu em todas as páginas
  Given o usuário navega para cada página (Dashboard, Transferências, Empréstimos, Pagamentos, Extrato)
  Then cada página exibe o mesmo menu principal com opções "Contas", "Transferências", "Empréstimos", "Pagamentos", "Extrato"
  And o link "Início" leva sempre ao Dashboard
  And o rodapé contém links "Termos", "Privacidade", "Ajuda" em todas as páginas
  ```

---

**titulo: US12 – Confirmações visuais de operações**  
**cenario_bdd:**  
&nbsp;&nbsp;- **nome:** Banner de confirmação de cadastro  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Confirmações visuais
Scenario: Banner após cadastro
  Given o usuário conclui o cadastro
  Then um banner "Cadastro concluído com sucesso!" aparece
  And o banner desaparece após 3 s ou quando o usuário clica em "x"
  ```

&nbsp;&nbsp;- **nome:** Banner de confirmação de transferência  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Confirmações visuais
Scenario: Banner após transferência
  Given o usuário conclui uma transferência de R$ 200,00 para conta YYY
  Then o banner "Transferência concluída: R$ 200,00 transferido para conta YYY" aparece
  And desaparece em 3 s ou quando o usuário fecha
  ```

&nbsp;&nbsp;- **nome:** Banner de confirmação de pagamento agendado  
&nbsp;&nbsp;&nbsp;&nbsp;**tipo:** positivo  
&nbsp;&nbsp;&nbsp;&nbsp;**gherkin:**  
&nbsp;&nbsp;&nbsp;&nbsp;```
Feature: Confirmações visuais
Scenario: Banner após agendamento de pagamento
  Given o usuário agenda pagamento de R$ 150,00 para data futura
  Then o banner "Pagamento agendado com sucesso" aparece
  And desaparece em 3 s ou quando o usuário clica em "x"
  ```

---