**User Stories – Sistema ParaBank**

---

### 1. Cadastro de Usuário  
**Como** novo cliente, **eu quero** criar uma conta no ParaBank, **para** poder acessar os serviços bancários online.  

**Descrição detalhada**  
O cliente deve preencher um formulário de cadastro com os campos obrigatórios: nome completo, data de nascimento, CPF, email, telefone, CEP, endereço, cidade, estado e senha. O sistema deve validar cada campo em tempo real, exibindo mensagens de erro específicas (ex.: “Formato de email inválido”, “CEP não encontrado”). Ao enviar o formulário, o sistema verifica duplicidade de CPF/email, envia e‑mail de confirmação e habilita o login.  

**Critérios de Aceite**  
- Todos os campos obrigatórios são obrigatórios; envio sem preencher qualquer um deles impede o cadastro.  
- Campos com formato inválido (email, telefone, CEP) geram mensagem de erro em tempo real.  
- CPF ou e‑mail já existentes bloqueiam o cadastro com mensagem “CPF já cadastrado” ou “E‑mail já em uso”.  
- Após cadastro bem‑sucedido o sistema exibe uma mensagem “Cadastro concluído – verifique seu e‑mail” e o usuário pode fazer login.  

---

### 2. Login  
**Como** cliente registrado, **eu quero** fazer login no ParaBank, **para** acessar minha conta de forma segura.  

**Descrição detalhada**  
O cliente informa e‑mail (ou CPF) e senha. O sistema autentica as credenciais, bloqueia tentativas repetidas em caso de erro e redireciona o usuário para a página inicial da conta. Se a senha estiver incorreta, exibe mensagem clara (“Credenciais inválidas – tente novamente”).  

**Critérios de Aceite**  
- Credenciais válidas redirecionam para a página de “Conta” (dashboard).  
- Credenciais inválidas exibem mensagem de erro e mantêm o usuário na tela de login.  
- 5 tentativas consecutivas falhadas bloqueiam a conta por 5 minutos (mensagem “Conta bloqueada – tente novamente em 5 min”).  

---

### 3. Visualização de Saldo e Extrato  
**Como** cliente autenticado, **eu quero** visualizar meu saldo atualizado e extrato de transações, **para** acompanhar minhas finanças.  

**Descrição detalhada**  
Na página “Conta” o sistema mostra o saldo atual em real e um botão “Extrato”. Ao clicar, o usuário vê uma lista cronológica das 20 transações mais recentes (data, descrição, valor, saldo final). O saldo deve refletir imediatamente qualquer operação recente (transferência, pagamento, empréstimo).  

**Critérios de Aceite**  
- Saldo exibido em reais com duas casas decimais.  
- Lista de extrato ordenada por data (mais recente acima).  
- Cada transação exibe: data, descrição (ex.: “Transferência para 123‑456”), valor debitado/creditado, saldo após a operação.  
- Se não houver transações, mensagem “Nenhuma transação encontrada”.  

---

### 4. Transferência de Fundos  
**Como** cliente, **eu quero** transferir um valor de minha conta para outra conta, **para** pagar serviços ou amigos.  

**Descrição detalhada**  
O cliente seleciona a conta de origem (sua própria), a conta de destino (campo de busca/CPF) e insere o valor. O sistema valida que o valor não ultrapassa o saldo disponível. Ao confirmar, debita a origem, credita a destino, e grava a transação em ambos os extratos.  

**Critérios de Aceite**  
- Campos obrigatórios: conta de origem, conta de destino, valor.  
- Valor deve ser numérico positivo e menor ou igual ao saldo atual.  
- Se valor > saldo, mensagem “Saldo insuficiente”.  
- Transação registrada em ambos os extratos, com data/hora, descrição “Transferência para X”.  
- Usuário recebe notificação “Transferência concluída com sucesso”.  

---

### 5. Solicitação de Empréstimo  
**Como** cliente, **eu quero** solicitar um empréstimo informando o valor desejado e minha renda anual, **para** obter recursos adicionais quando necessário.  

**Descrição detalhada**  
O cliente preenche o formulário com “Valor do Empréstimo” e “Renda Anual”. O sistema avalia o pedido (simulação de regra simples: renda ≥ 3 × valor) e devolve “Aprovado” ou “Negado” com justificativa. O resultado aparece na tela e é armazenado no histórico de solicitações.  

**Critérios de Aceite**  
- Campos obrigatórios: valor do empréstimo, renda anual.  
- Valor e renda devem ser numéricos > 0.  
- Se renda < 3 × valor → “Empréstimo Negado – renda insuficiente”.  
- Se renda ≥ 3 × valor → “Empréstimo Aprovado – crédito de X reais”.  
- Resultado armazenado no histórico de “Solicitações de Empréstimo”.  

---

### 6. Pagamento de Contas  
**Como** cliente, **eu quero** registrar e agendar pagamentos, **para** quitar contas de forma automatizada.  

**Descrição detalhada**  
O cliente fornece: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento. O sistema valida todos os campos, registra o pagamento no histórico e, se agendado para data futura, bloqueia a confirmação até a data de vencimento.  

**Critérios de Aceite**  
- Campos obrigatórios: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor, data.  
- Validação de CEP, telefone e e‑mail (se houver) em tempo real.  
- Pagamentos agendados para datas futuras não reduzem saldo imediatamente.  
- Pagamento confirmado (data atual ou futura) debita/credita as contas e aparece no extrato.  
- Mensagem de confirmação: “Pagamento de X reais ao beneficiário Y agendado para DD/MM/AAAA”.  

---

### 7. Navegação e Usabilidade Geral  
**Como** usuário, **eu quero** que todas as páginas carreguem sem erros e que os menus sejam consistentes, **para** navegar de forma intuitiva no sistema.  

**Descrição detalhada**  
Cada página deve carregar em menos de 3 segundos, não apresentar links quebrados ou redirecionamentos errados. Menus (home, conta, transferências, empréstimos, pagamentos, extrato, ajuda) permanecem visíveis em todas as telas, com destaque na página atual.  

**Critérios de Aceite**  
- Tempo de carregamento ≤ 3 segundos em conexão 3G.  
- Todos os links do menu abrem a página correta sem erros 404.  
- Botão “Sair” sempre disponível e redireciona para login.  
- Mensagens de erro (404, 500) exibem texto amigável (“O que aconteceu? Tente novamente”).  

---

### 8. Mensagens de Erro e Validação de Dados  
**Como** usuário, **eu quero** receber mensagens claras quando digitar dados inválidos, **para** corrigir imediatamente e evitar falhas no fluxo de negócio.  

**Descrição detalhada**  
Para cada campo de entrada (telefone, CEP, email, data, valor monetário) o sistema verifica o formato ao perder foco ou ao submeter o formulário. As mensagens aparecem imediatamente abaixo do campo, com ícone de alerta e texto explicativo.  

**Critérios de Aceite**  
- Telefone: formato (xxx) xxxx-xxxx ou +55 xxxx-xxxx.  
- CEP: 8 dígitos numéricos, sem traço.  
- Email: padrão RFC 5322.  
- Data: DD/MM/AAAA, não no futuro (para pagamento) ou não no passado (para transferências).  
- Valor: número positivo, máximo 999 999,99.  
- Mensagens de erro exibidas em vermelho, com texto “Formato inválido – por favor, insira XX”.  

---

> **Obs.:** Cada User Story possui escopo isolado, garantindo que não haja sobreposição. Todas são testáveis por meio de testes de UI, validação de dados e fluxo funcional. O foco está no valor entregue ao cliente e na experiência de uso.