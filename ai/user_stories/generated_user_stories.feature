**User Stories – ParaBank (Versão 1.0)**  
*(Rastreabilidade: US01 … US15)*  

---

### US01 – Cadastro de Usuário  
**Como** cliente do ParaBank, **eu quero** criar uma nova conta de usuário preenchendo todos os campos obrigatórios, **para** poder acessar o sistema e realizar transações bancárias.  

**Descrição**  
O formulário de cadastro deve solicitar: nome completo, CPF, data de nascimento, endereço, CEP, telefone, e‑mail e senha. Todos os campos obrigatórios precisam ser preenchidos antes de submeter o formulário.  

**Critérios de Aceite**  
1. O sistema bloqueia a submissão se algum campo obrigatório estiver em branco.  
2. Campos de telefone, CEP e e‑mail são validados em tempo real; erros exibem mensagem específica (ex.: “Telefone inválido – insira 10 dígitos”).  
3. Ao submeter dados corretos, a conta é criada, o usuário recebe e‑mail de confirmação (ou mensagem na tela) e passa a poder fazer login.  
4. Tentativas de cadastro com e‑mail já registrado resultam em mensagem “E‑mail já cadastrado”.  

---

### US02 – Login bem-sucedido  
**Como** cliente autenticado, **eu quero** entrar no sistema com credenciais válidas, **para** ser redirecionado à minha página inicial e visualizar o saldo.  

**Descrição**  
A tela de login deve aceitar e‑mail e senha. Após a autenticação, o usuário é encaminhado para a dashboard principal.  

**Critérios de Aceite**  
1. Credenciais corretas levam ao redirecionamento automático à página inicial.  
2. O saldo exibido corresponde ao valor atual da conta.  
3. O histórico de transações é carregado na mesma página.  

---

### US03 – Login inválido  
**Como** cliente que tenta acessar o sistema, **eu quero** receber uma mensagem de erro quando inserir credenciais inválidas, **para** entender por que não consegui entrar.  

**Descrição**  
O sistema deve impedir o login quando e‑mail ou senha estiverem incorretos e exibir mensagem clara.  

**Critérios de Aceite**  
1. Entrada de e‑mail ou senha inválida exibe mensagem “E‑mail ou senha inválidos.”  
2. O usuário permanece na página de login sem expiração de sessão.  
3. O botão “Esqueci minha senha” permanece visível para recuperação.  

---

### US04 – Exibição de Saldo Atualizado  
**Como** cliente, **eu quero** ver o saldo da minha conta sempre que acessar a dashboard, **para** saber quantos recursos estão disponíveis antes de fazer transações.  

**Descrição**  
A página inicial deve mostrar o saldo atual logo na parte superior.  

**Critérios de Aceite**  
1. O saldo aparece em moeda local (R$).  
2. O saldo se atualiza automaticamente após cada operação financeira (transferência, pagamento, etc.).  
3. Se não houver transações recentes, o saldo reflete o último valor confirmado.  

---

### US05 – Exibição de Extrato em Ordem Cronológica  
**Como** cliente, **eu quero** visualizar um extrato contendo as transações recentes em ordem cronológica, **para** acompanhar minhas movimentações.  

**Descrição**  
O extrato deve listar data, descrição, valor debitado/creditado e saldo pós‑transação.  

**Critérios de Aceite**  
1. As transações aparecem em ordem decrescente (mais recente primeiro).  
2. Cada linha mostra data (DD/MM/AAAA), tipo (débito / crédito), descrição curta e saldo final.  
3. O extrato permite filtro por intervalo de datas (opcional).  

---

### US06 – Transferência de Fundos (Sucesso)  
**Como** cliente, **eu quero** transferir um valor entre contas, **para** movimentar recursos de forma rápida e segura.  

**Descrição**  
A tela de transferência solicita: conta origem (auto‑seleção), conta destino, valor e data de transferência (agendada ou imediata).  

**Critérios de Aceite**  
1. O valor informado não pode exceder o saldo disponível da conta origem.  
2. Ao confirmar, o valor é debitado da origem, creditado na destino e registrado no extrato de ambas.  
3. A confirmação exibe mensagem “Transferência concluída com sucesso – R$X,XX”.  

---

### US07 – Transferência de Fundos (Valor Excede Saldo)  
**Como** cliente, **eu quero** receber aviso quando tentar transferir mais que o saldo disponível, **para** evitar falhas na operação.  

**Descrição**  
A interface deve impedir a confirmação de transferência que exceda o saldo.  

**Critérios de Aceite**  
1. Se o valor > saldo, exibe mensagem “Saldo insuficiente – saldo atual R$Y,YY”.  
2. O botão “Confirmar” fica desabilitado até que o valor seja corrigido.  

---

### US08 – Solicitação de Empréstimo  
**Como** cliente, **eu quero** solicitar um empréstimo informando valor e renda anual, **para** obter aprovação automática ou rejeição.  

**Descrição**  
A tela de solicitação aceita valor do empréstimo e renda anual, enviando ao backend para avaliação.  

**Critérios de Aceite**  
1. O sistema valida que o valor > 0 e renda anual > 0.  
2. O resultado é exibido imediatamente: “Aprovado” ou “Negado”, com mensagem de justificativa (ex.: “Renda insuficiente”).  
3. O histórico de empréstimos mostra data, valor solicitado e status.  

---

### US09 – Pagamento de Contas (Registro)  
**Como** cliente, **eu quero** registrar um pagamento informando beneficiário, endereço, cidade, estado, CEP, telefone, conta destino, valor e data, **para** manter controle das contas a pagar.  

**Descrição**  
A tela de pagamento coleta todos os campos obrigatórios e grava o registro.  

**Critérios de Aceite**  
1. Campos obrigatórios não podem ficar em branco.  
2. O valor deve ser > 0.  
3. Após confirmação, o pagamento aparece no histórico com status “Agendado” ou “Concluído” conforme data.  

---

### US10 – Pagamento de Contas (Agendamento Futuro)  
**Como** cliente, **eu quero** agendar pagamentos para datas futuras, **para** garantir que sejam debitados automaticamente no momento certo.  

**Descrição**  
A opção de data futura deve aceitar somente datas ≥ 1 dia após a data atual.  

**Critérios de Aceite**  
1. Data futura menor que hoje gera mensagem “Data inválida – selecione uma data futura”.  
2. Pagamento agendado exibe no histórico “Agendado para DD/MM/AAAA”.  
3. O sistema processa o débito automático na data marcada e atualiza o saldo e extrato.  

---

### US11 – Navegação Consistente  
**Como** cliente, **eu quero** que os menus e links sejam consistentes em todas as páginas, **para** navegar de forma intuitiva sem confusões.  

**Descrição**  
Todos os links de navegação (header, sidebar, footer) devem apontar para as páginas corretas e manter a mesma ordem.  

**Critérios de Aceite**  
1. Cada página contém um link “Minha Conta”, “Transferências”, “Pagamentos”, “Empréstimos”, “Extrato” e “Sair”.  
2. Clicar em cada link leva à página correta sem erros 404.  
3. O menu ativo destaca a página atual.  

---

### US12 – Mensagens de Erro Claras  
**Como** cliente, **eu quero** receber mensagens de erro claras e objetivas, **para** compreender o que deu errado e como corrigir.  

**Descrição**  
Todas as mensagens de erro devem ter linguagem simples, indicar o campo afetado e a correção sugerida.  

**Critérios de Aceite**  
1. Erros de validação aparecem ao lado do campo em vermelho.  
2. Mensagem geral (ex.: “Erro inesperado – tente novamente mais tarde”) não aparece sem causa.  
3. Mensagens de sucesso aparecem em verde e desaparecem após 5 s ou quando o usuário clica em “Ok”.  

---

### US13 – Carregamento sem Erros de Navegação  
**Como** cliente, **eu quero** que todas as páginas carreguem sem erros de navegação, **para** ter uma experiência fluída.  

**Descrição**  
O sistema deve evitar páginas quebradas e garantir que todas as rotas existam.  

**Critérios de Aceite**  
1. Navegar por qualquer link não gera erro 404 nem mensagens de falha.  
2. O tempo de carregamento não excede 2 s em conexão padrão.  
3. Se ocorrer erro de servidor, exibe mensagem “Falha no servidor – recarregue a página”.  

---

### US14 – Validação de Campos no Cadastro  
**Como** cliente, **eu quero** que campos como telefone, CEP e e‑mail sejam validados no cadastro, **para** evitar dados inválidos que prejudiquem minha conta.  

**Descrição**  
O formulário deve validar a formatação em tempo real e bloquear a submissão caso haja erros.  

**Critérios de Aceite**  
1. Telefone aceita apenas 10 ou 11 dígitos (sem caracteres).  
2. CEP aceita apenas 8 dígitos numéricos.  
3. E‑mail segue padrão RFC e exibe “Formato inválido” se não atender.  

---

### US15 – Mensagens de Confirmação de Operações  
**Como** cliente, **eu quero** receber mensagens de confirmação para cada operação concluída (transferência, pagamento, empréstimo), **para** ter garantia de que o processo foi efetivado.  

**Descrição**  
Após a conclusão de qualquer ação, o sistema exibe popup ou banner confirmando a transação.  

**Critérios de Aceite**  
1. Mensagem inclui tipo de transação, valor e saldo atualizado.  
2. Mensagem aparece em verde, desaparece após 5 s, salvo se o usuário clicar em “Detalhes”.  
3. O botão “Detalhes” abre tela com informações completas da transação (data, beneficiário, etc.).  

---

> **Observação**: Cada User Story foi desenhada para cobrir um escopo distinto, evitando sobreposição, e é testável por critérios objetivos definidos em cada seção de “Critérios de Aceite”. As histórias garantem clareza e valor ao usuário final, alinhando‑se aos requisitos de aceite do documento ParaBank 1.  
> 
> **Próximos passos**: Definir prioridades (ex.: US01, US02, US04, US05) e criar histórias de teste automatizado com base nos critérios acima.