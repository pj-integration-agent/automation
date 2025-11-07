**User Stories – ParaBank (versão de testes)**  

*(Todas as histórias seguem o padrão: “Como <tipo de usuário>, eu quero <objetivo> para <benefício>”.)*
  
---

### US01 – Cadastro de Usuário  
**Como** novo cliente do ParaBank,  
**eu quero** preencher e submeter o formulário de cadastro,  
**para** obter uma conta e poder acessar o sistema.  

**Descrição**  
O processo de cadastro deve coletar todos os campos obrigatórios (nome completo, data de nascimento, CPF, endereço, CEP, telefone, e‑mail e senha). O sistema valida cada campo em tempo real e exibe mensagens de erro amigáveis quando o formato está incorreto (ex.: número de telefone não numérico, CEP com menos/mais dígitos, e‑mail sem “@”).  

**Critérios de Aceite**  
- Todos os campos obrigatórios são obrigados; o botão “Cadastrar” fica inativo até que o formulário esteja completo.  
- Campos inválidos exibem mensagem de erro específica (ex.: “CEP inválido – use 8 dígitos”).  
- Após submissão bem‑sucedida, o usuário recebe uma tela de confirmação e é automaticamente logado (ou recebe link de e‑mail de confirmação).  
- O usuário pode tentar logar imediatamente com as credenciais recém‑criadas.  

---

### US02 – Login  
**Como** cliente já registrado,  
**eu quero** autenticar-me usando e‑mail e senha,  
**para** acessar a minha conta bancária.  

**Descrição**  
A tela de login solicita e‑mail e senha. O sistema verifica credenciais, bloqueia a tentativa caso estejam erradas e, ao validar, redireciona para a página inicial da conta (dashboard).  

**Critérios de Aceite**  
- Sistema permite login apenas com credenciais existentes e válidas.  
- Erro “Usuário ou senha inválidos” aparece quando a combinação está incorreta.  
- Ao login bem‑sucedido, o usuário é redirecionado para a página “Minha Conta” e a sessão permanece ativa até logout ou timeout.  

---

### US03 – Visualizar Saldo e Extrato  
**Como** cliente autenticado,  
**eu quero** ver meu saldo atual e o extrato de transações recentes,  
**para** acompanhar minhas finanças.  

**Descrição**  
A dashboard exibe o saldo corrente em moeda local. O extrato lista as 10 transações mais recentes em ordem cronológica, com data, descrição, valor e saldo pós‑transação.  

**Critérios de Aceite**  
- Saldo exibido é atualizado imediatamente após qualquer operação (transferência, pagamento, empréstimo).  
- Extrato mostra pelo menos 10 registros; se houver menos, exibe todos.  
- Cada linha do extrato possui data, descrição (ex.: “Transferência para conta X”) e valor (+ ou –).  
- A página carrega sem erros e não há redirecionamento inesperado.  

---

### US04 – Transferência de Fundos  
**Como** cliente autenticado,  
**eu quero** transferir dinheiro de uma conta minha para outra conta,  
**para** movimentar recursos entre minhas contas ou para terceiros.  

**Descrição**  
O usuário escolhe a conta de origem, a conta de destino (pode ser interna ou externa) e o valor. O sistema verifica saldo disponível e impede transferências acima desse limite. Após confirmação, débito na origem e crédito na destinação são registrados, e a transação aparece no extrato de ambas as contas.  

**Critérios de Aceite**  
- O campo “Valor” aceita somente números positivos e mostra erro se exceder saldo.  
- O sistema bloqueia a transferência se o valor > saldo disponível.  
- Ao confirmar, a origem é debitada e a destinação creditada imediatamente.  
- Transação aparece no extrato de origem (–) e destinação (+) com a mesma data/hora.  
- Mensagem de sucesso “Transferência concluída” aparece após a operação.  

---

### US05 – Solicitação de Empréstimo  
**Como** cliente autenticado,  
**eu quero** solicitar um empréstimo indicando valor e renda anual,  
**para** obter crédito que será disponibilizado na minha conta se aprovado.  

**Descrição**  
A tela de solicitação coleta valor do empréstimo e renda anual. O sistema simula a análise de crédito e devolve “Aprovado” ou “Negado”. O resultado é exibido de forma clara, e, se aprovado, o montante aparece como crédito na conta do usuário.  

**Critérios de Aceite**  
- Campos obrigatórios: valor do empréstimo (positivo) e renda anual (positivo).  
- O sistema retorna status em 2 segundos (simulação).  
- Se aprovado, o valor é creditado na conta imediatamente e aparece no extrato com descrição “Empréstimo aprovado”.  
- Se negado, o usuário recebe mensagem “Empréstimo negado – renda insuficiente”.  

---

### US06 – Pagamento de Contas  
**Como** cliente autenticado,  
**eu quero** registrar um pagamento a um beneficiário,  
**para** garantir que a conta do beneficiário receba o valor na data agendada.  

**Descrição**  
O usuário fornece beneficiário, endereço completo, cidade, estado, CEP, telefone, conta de destino e valor. A data de pagamento pode ser hoje ou futura; se futura, o sistema agenda a transação. Após confirmação, o pagamento aparece no histórico de transações da conta do cliente.  

**Critérios de Aceite**  
- Todos os campos obrigatórios são preenchidos; dados inválidos geram mensagem de erro (ex.: CEP inválido).  
- Data de pagamento futura é aceita e a transação aparece no extrato com a data marcada.  
- O valor não pode exceder o saldo disponível no dia da transação (para pagamentos programados, verifica saldo no dia programado).  
- Mensagem de sucesso “Pagamento registrado” e inclusão no extrato de forma clara (“Pagamento para <beneficiário>”).  

---

### US07 – Navegação e Usabilidade  
**Como** qualquer usuário (novo ou existente),  
**eu quero** que todas as páginas carreguem sem erros, com menus consistentes e mensagens claras,  
**para** navegar de forma intuitiva e entender rapidamente o que acontece quando ocorrem erros.  

**Descrição**  
Todas as rotas do aplicativo devem responder a 200 (OK) e não exibir erros 404/500. O cabeçalho e rodapé contêm os mesmos links (Ex.: “Minha Conta”, “Transferências”, “Empréstimos”, “Pagamentos”, “Sair”). Mensagens de erro são exibidas em blocos visíveis e com linguagem simples.  

**Critérios de Aceite**  
- Navegação entre páginas (login, cadastro, dashboard, extrato, transferência, empréstimo, pagamento) não gera erros de roteamento.  
- Todos os links e botões têm texto e ícone claro; o menu é responsivo em telas menores.  
- Erro de validação aparece logo abaixo do campo correspondente, em vermelho, com texto explicativo.  
- A página de erro 404 mostra link de retorno ao dashboard (se logado) ou ao login (se não logado).  

---  

> **Rastreabilidade**  
> - US01 → Cadastro de Usuário  
> - US02 → Login  
> - US03 → Visualizar Saldo e Extrato  
> - US04 → Transferência de Fundos  
> - US05 → Solicitação de Empréstimo  
> - US06 → Pagamento de Contas  
> - US07 → Navegação e Usabilidade  

Essas histórias são independentes, testáveis e cobrem todas as funcionalidades principais descritas nos critérios de aceite do ParaBank.