**User Stories – ParaBank (Visão de Usuário e Critérios de Aceite)**  

*(Todas as histórias seguem o padrão: “Como [tipo de usuário], eu quero [objetivo] para [benefício]”. A descrição detalha a funcionalidade, os critérios de aceite são objetivos, mensuráveis e vinculam‑se diretamente aos requisitos do documento de aceitação.)*  

---

### US01 – Cadastro de Usuário  
**Como** potencial cliente do ParaBank, **eu quero** preencher um formulário de cadastro para criar minha conta no sistema, **para** ter acesso aos serviços bancários online.  

**Descrição**  
O usuário deve conseguir criar uma nova conta fornecendo seus dados pessoais. O formulário exige os campos obrigatórios (nome completo, data de nascimento, endereço, CEP, telefone, e‑mail e senha). O sistema valida formato e conteúdo de cada campo e, ao concluir, envia uma mensagem de confirmação e permite o login imediato.  

**Critérios de Aceite**  
1. Todos os campos obrigatórios são obrigatórios – a tentativa de submeter o formulário vazio resulta em mensagem de erro específica para cada campo.  
2. Validação de campos:  
   - **Telefone**: aceita apenas números, 10–11 dígitos, exibindo erro em caso de formato inválido.  
   - **CEP**: 8 dígitos numéricos; exibe erro se não for numérico ou inválido.  
   - **E‑mail**: segue padrão RFC 5322; exibe erro em caso de formato incorreto.  
3. Ao submeter dados válidos, o sistema cria a conta, grava os dados no banco e exibe mensagem “Cadastro concluído com sucesso”.  
4. Após cadastro, o usuário pode imediatamente fazer login com as credenciais geradas.  

**Rastreabilidade**: (US01)  

---

### US02 – Login do Usuário  
**Como** cliente já cadastrado, **eu quero** autenticar-me no ParaBank com meu e‑mail e senha, **para** acessar minha conta e realizar operações.  

**Descrição**  
A tela de login aceita credenciais e verifica sua validade. Em caso de sucesso, redireciona para a página inicial da conta. Em caso de falha, exibe mensagem de erro adequada e mantém a página de login.  

**Critérios de Aceite**  
1. Login com credenciais válidas → redirecionamento imediato para a “Dashboard” da conta.  
2. Login com credenciais inválidas (e‑mail inexistente ou senha errada) → exibição de mensagem “Credenciais inválidas. Por favor, tente novamente.”  
3. O botão de login fica habilitado apenas quando ambos os campos (e‑mail e senha) não estão vazios.  
4. O histórico de tentativas de login inválidas não é armazenado (segurança).  

**Rastreabilidade**: (US02)  

---

### US03 – Visualização do Saldo e Extrato  
**Como** cliente autenticado, **eu quero** ver o saldo atual da minha conta e o extrato das transações recentes, **para** acompanhar minhas finanças em tempo real.  

**Descrição**  
Ao acessar a página da conta, o sistema mostra:  
- Saldo atual, atualizado após cada operação financeira.  
- Lista de transações nas últimas 30 dias, ordenada cronologicamente (mais recente primeiro). Cada linha exibe data, descrição, tipo (crédito/débito) e valor.  

**Critérios de Aceite**  
1. Saldo exibido em moeda real (R$) com duas casas decimais.  
2. Ao executar qualquer operação (transferência, pagamento, empréstimo), o saldo na página reflete imediatamente o novo valor (debito/credito).  
3. Extrato mostra no mínimo 5 transações recentes; se houver menos, exibe todas disponíveis.  
4. As transações são ordenadas pelo campo “data” em ordem decrescente.  

**Rastreabilidade**: (US03)  

---

### US04 – Transferência de Fundos  
**Como** cliente autenticado, **eu quero** transferir dinheiro de minha conta para outra conta bancária, **para** movimentar recursos entre contas de forma segura e automática.  

**Descrição**  
O usuário seleciona a conta de origem (sempre a sua conta), escolhe a conta de destino (número fornecido) e digita o valor da transferência. O sistema verifica saldo suficiente, executa a transferência, atualiza os saldos e registra a transação no histórico de ambas as contas.  

**Critérios de Aceite**  
1. O campo de valor aceita apenas números positivos com até duas casas decimais; exibe erro se o valor for zero ou negativo.  
2. A transferência só pode ser concluída se o saldo disponível for ≥ valor da transferência.  
3. Ao confirmar, o saldo da conta de origem diminui e o saldo da conta de destino aumenta imediatamente.  
4. Transação aparece no extrato de ambas as contas, com descrição “Transferência recebida” ou “Transferência enviada”, data e valor.  

**Rastreabilidade**: (US04)  

---

### US05 – Solicitação de Empréstimo  
**Como** cliente autenticado, **eu quero** solicitar um empréstimo informando o valor desejado e minha renda anual, **para** avaliar se o banco aprovará o pedido e ter acesso ao montante solicitado.  

**Descrição**  
O formulário de solicitação pede: valor do empréstimo, renda anual e dados de contato. O sistema processa a solicitação instantaneamente e devolve status “Aprovado” ou “Negado” com explicação resumida.  

**Critérios de Aceite**  
1. Campo “valor do empréstimo” aceita números positivos até 10 000 000 (R$) com até duas casas decimais.  
2. Campo “renda anual” aceita números positivos com até duas casas decimais.  
3. O sistema determina status baseado em regras fictícias (ex.: renda anual ≥ 4 × valor do empréstimo → aprovado; caso contrário → negado).  
4. Mensagem de resultado exibe:  
   - Aprovado: “Seu empréstimo de R$ {valor} foi aprovado.”  
   - Negado: “Seu empréstimo de R$ {valor} foi negado. Motivo: renda insuficiente.”  
5. O histórico de solicitações fica visível na página da conta.  

**Rastreabilidade**: (US05)  

---

### US06 – Pagamento de Contas  
**Como** cliente autenticado, **eu quero** registrar pagamentos de contas (bancos, serviços, etc.) informando beneficiário e dados da fatura, **para** garantir que as contas sejam salvas no histórico e que futuros pagamentos sejam agendados corretamente.  

**Descrição**  
O usuário preenche: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino (número bancário), valor, data de pagamento. Após confirmação, o pagamento é salvo no histórico e, se agendado para uma data futura, o sistema garante que a transação ocorra na data marcada.  

**Critérios de Aceite**  
1. Todos os campos são obrigatórios; mensagem de erro específica para campos vazios.  
2. **Data de pagamento** deve ser uma data no futuro ou no dia corrente; data passada gera erro “Data inválida”.  
3. Valor aceita números positivos, até 1 000 000,00 com duas casas decimais.  
4. Após confirmação, a transação aparece no extrato com data de pagamento e descrição “Pagamento de {beneficiário}”.  
5. O saldo da conta de destino diminui no dia de pagamento.  

**Rastreabilidade**: (US06)  

---

### US07 – Navegação e Usabilidade Consistente  
**Como** usuário do ParaBank, **eu quero** navegar de forma intuitiva, com menus e links consistentes e mensagens de erro claras, **para** ter uma experiência de uso sem confusão e erros técnicos.  

**Descrição**  
Todas as páginas devem carregar sem falhas, menus de navegação (Home, Conta, Transferências, Empréstimos, Pagamentos, Logout) devem estar visíveis em todas as telas, e as mensagens de erro devem seguir o padrão de cores (vermelho) e texto objetivo.  

**Critérios de Aceite**  
1. Navegação entre páginas ocorre em ≤ 3 segundos sem erro 404.  
2. Todos os links de menu estão ativos e levam à página correta.  
3. Mensagens de erro exibidas em modal ou banner, com texto claro e sem ambiguidade (“Campo obrigatório”, “Saldo insuficiente”, “Data inválida”).  
4. Layout responsivo (desktop, tablet, mobile) mantém a mesma estrutura de navegação.  

**Rastreabilidade**: (US07)  

---

> **Observação**: Cada User Story possui escopo bem definido, não sobrepõe outra e pode ser testada de forma independente, garantindo a entrega incremental e a validação conforme os critérios de aceite descritos no documento.