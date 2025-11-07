**User Stories – Sistema ParaBank**  

> *Formato*: “Como **[tipo de usuário]**, eu quero **[objetivo]** para **[benefício/valor de negócio]**”.  
> Cada história traz:  
> 1. **Título**  
> 2. **Descrição detalhada**  
> 3. **Critérios de Aceitação** (objetivos, testáveis)  
> 4. **Rastreabilidade** (ex.: US01)  

---  

### US01 – Cadastro de Usuário  
**Como** um usuário recém‑cadastro,  
**eu quero** preencher o formulário de registro com todos os campos obrigatórios,  
**para** criar uma conta válida e receber confirmação de que posso fazer login no ParaBank.  

**Descrição**  
O fluxo de cadastro deve exigir que o usuário insira: nome completo, CPF, data de nascimento, telefone, CEP, endereço, e‑mail e senha (com confirmação). O sistema deve validar cada campo (formato de telefone, CEP, e‑mail e senha mínima) e exibir mensagens de erro específicas se algum dado for inválido.  

**Critérios de Aceitação**  
1. O usuário consegue submeter o formulário apenas quando todos os campos obrigatórios estiverem preenchidos.  
2. Se o telefone não contiver 10 ou 11 dígitos, o sistema mostra “Telefone inválido – insira 10 ou 11 dígitos”.  
3. Se o CEP não tiver 8 dígitos, o sistema mostra “CEP inválido – insira 8 dígitos”.  
4. Se o e‑mail não atender ao padrão `usuario@dominio.com`, a mensagem “E‑mail inválido” aparece.  
5. Se a senha e a confirmação não coincidirem, exibe “Senhas não correspondem”.  
6. Ao submeter um cadastro válido, o usuário vê a mensagem “Cadastro concluído com sucesso. Você pode agora fazer login.”  
7. O usuário recém‑cadastro consegue fazer login imediatamente.  

**Rastreabilidade**: US01  

---  

### US02 – Login  
**Como** um usuário autenticado,  
**eu quero** entrar no sistema usando minha credencial,  
**para** acessar minha página inicial de conta.  

**Descrição**  
O login deve aceitar e‑mail (ou CPF) + senha. A página deve bloquear o acesso e exibir mensagem de erro caso as credenciais não correspondam a nenhum registro.  

**Critérios de Aceitação**  
1. Ao digitar credenciais válidas, o usuário é redirecionado para a **Dashboard**.  
2. Credenciais inválidas geram a mensagem “E‑mail ou senha incorretos. Tente novamente.”  
3. O link “Esqueci minha senha” deve levar a página de recuperação (não incluída neste sprint).  
4. Após login, o usuário vê o nome de exibição (ex.: “Olá, João”) na barra superior.  

**Rastreabilidade**: US02  

---  

### US03 – Acesso à Conta (Saldo e Extrato)  
**Como** um usuário logado,  
**eu quero** ver meu saldo atualizado e o extrato de transações em ordem cronológica,  
**para** ter controle completo das minhas finanças.  

**Descrição**  
A Dashboard deve exibir o saldo em tempo real. Ao clicar em “Extrato”, o sistema lista todas as transações, da mais recente para a mais antiga, com data, descrição, valor (crédito ou débito) e saldo pós‑transação.  

**Critérios de Aceitação**  
1. O saldo mostrado na Dashboard reflete o saldo final após a última operação.  
2. O extrato mostra no mínimo 10 transações recentes.  
3. Cada linha do extrato inclui: Data (DD/MM/AAAA), Descrição (ex.: “Transferência para Conta X”), Valor (positivo para crédito, negativo para débito) e Saldo (após transação).  
4. Se não houver transações, a mensagem “Nenhuma transação encontrada” aparece.  
5. O extrato pode ser filtrado por data (data inicial / data final).  

**Rastreabilidade**: US03  

---  

### US04 – Transferência de Fundos  
**Como** um usuário,  
**eu quero** transferir dinheiro entre contas,  
**para** movimentar recursos sem sair da aplicação.  

**Descrição**  
O usuário seleciona a conta de origem (ex.: Conta Corrente), a conta de destino (ex.: Conta Poupança ou outro cliente) e o valor. O sistema valida saldo, impede valores maiores que o saldo disponível e registra a transação em ambas as contas.  

**Critérios de Aceitação**  
1. A tela de transferência permite escolher a conta de origem e a de destino por lista suspensa.  
2. Ao inserir um valor superior ao saldo da origem, o sistema exibe “Saldo insuficiente”.  
3. Quando a transferência for confirmada, o valor é debitado da origem e creditado na destinação instantaneamente.  
4. A transação aparece no extrato de ambas as contas com data, descrição (“Transferência para …”) e saldo atualizado.  
5. O usuário recebe uma mensagem de sucesso: “Transferência realizada com sucesso”.  

**Rastreabilidade**: US04  

---  

### US05 – Solicitação de Empréstimo  
**Como** um usuário que deseja crédito,  
**eu quero** solicitar um empréstimo informando valor e renda anual,  
**para** saber instantaneamente se o empréstimo é aprovado ou negado.  

**Descrição**  
O formulário de empréstimo aceita: valor do empréstimo, renda anual e opção de taxa de juros. O sistema faz a avaliação (simples, apenas comparação de renda ≥ 3× valor) e retorna status.  

**Critérios de Aceitação**  
1. O usuário preenche “Valor do Empréstimo” (ex.: 5.000) e “Renda Anual” (ex.: 60.000).  
2. Se a renda anual for menor que três vezes o valor solicitado, a mensagem “Empréstimo negado – renda insuficiente” aparece.  
3. Se a renda for suficiente, exibe “Empréstimo aprovado”.  
4. O resultado (aprovado/negado) é salvo no histórico de empréstimos do usuário.  
5. O usuário pode visualizar o histórico de solicitações na seção “Empréstimos”.  

**Rastreabilidade**: US05  

---  

### US06 – Pagamento de Contas  
**Como** um usuário,  
**eu quero** registrar pagamentos de contas com dados do beneficiário,  
**para** ter controle de compromissos financeiros e ver no histórico.  

**Descrição**  
O formulário de pagamento coleta beneficiário, endereço (rua, número, complemento), cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento (agendamento). O sistema valida dados e, ao confirmar, inclui a transação no histórico e agenda pagamento futuro.  

**Critérios de Aceitação**  
1. Todos os campos obrigatórios são preenchidos: Beneficiário, Endereço, Cidade, Estado, CEP, Telefone, Conta de Destino, Valor, Data.  
2. Se a data for no passado, exibe “Data inválida – não pode ser anterior a hoje”.  
3. Após confirmação, o pagamento aparece no extrato com data de vencimento e status “Pendente” (ou “Realizado” se a data for hoje).  
4. O usuário pode marcar pagamentos recorrentes (ex.: mensal) – não incluído neste sprint, mas a interface deve suportar checkbox “Recorrente”.  
5. Mensagem de sucesso: “Pagamento registrado com sucesso”.  

**Rastreabilidade**: US06  

---  

### US07 – Navegação & Usabilidade  
**Como** um usuário,  
**eu quero** navegar facilmente entre as páginas,  
**para** usar o ParaBank sem frustração e receber mensagens claras de erro.  

**Descrição**  
Todos os menus, links e botões devem estar visíveis e funcionalmente corretos em todas as páginas. Mensagens de erro devem ser específicas e amigáveis.  

**Critérios de Aceitação**  
1. O menu principal (Login, Cadastro, Dashboard, Extrato, Transferência, Empréstimo, Pagamentos) aparece em todas as páginas (exceto login).  
2. Cada link leva à página correta sem 404s ou erros de navegação.  
3. Quando ocorre um erro (ex.: campo obrigatório em branco), a mensagem aparece imediatamente abaixo do campo afetado.  
4. A página inicial exibe o título “ParaBank – Banco Digital de Teste”.  
5. O layout responsivo adapta-se a telas de 320 px a 1920 px.  

**Rastreabilidade**: US07  

---  

> **Observação**: As histórias acima são independentes, cobrem todos os módulos mencionados no documento de critérios de aceite e são testáveis com critérios claros e mensuráveis. Prioridade inicial: US01 → US02 → US03 → US04 → US05 → US06 → US07.