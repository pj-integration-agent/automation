**User Story 1 – Cadastro de Usuário**  
*US01*  
- **Como** cliente do ParaBank,  
- **eu quero** criar uma nova conta no sistema preenchendo todos os campos obrigatórios,  
- **para** ter acesso às funcionalidades bancárias online e poder efetuar login.  

**Descrição**  
O fluxo de registro deve coletar informações essenciais (nome, e‑mail, telefone, CEP, senha) e validar cada campo antes de permitir a submissão. Mensagens de erro claras devem orientar o usuário em caso de dados inválidos. Após o cadastro bem‑sucedido, o usuário deve receber uma confirmação por e‑mail e ter sua conta marcada como ativa.  

**Critérios de Aceite**  
1. Todos os campos obrigatórios (nome, e‑mail, telefone, CEP, senha, confirmação de senha) devem ser preenchidos para que o botão “Registrar” fique habilitado.  
2. Os seguintes padrões de validação devem ser aplicados:  
   - **E‑mail**: formato válido e inexistência em BD.  
   - **Telefone**: 10 a 11 dígitos, apenas números.  
   - **CEP**: 8 dígitos, apenas números.  
3. Caso algum campo inválido seja detectado, uma mensagem de erro específica deve aparecer abaixo do campo.  
4. Após submissão válida, o usuário recebe:  
   - Mensagem “Cadastro realizado com sucesso”.  
   - E‑mail de confirmação contendo link de ativação.  
5. A conta criada deve ser marcada como “Ativa” no banco de dados, permitindo que o usuário faça login imediatamente (ou após confirmação, se for requerida).  

---

**User Story 2 – Login**  
*US02*  
- **Como** cliente já registrado,  
- **eu quero** autenticar-me usando e‑mail e senha,  
- **para** acessar o painel pessoal e realizar operações bancárias.  

**Descrição**  
A tela de login deve validar credenciais contra a base de dados. Erros de autenticação são exibidos de maneira segura, sem revelar se o e‑mail ou a senha está errada. Após sucesso, o usuário é redirecionado para a página inicial da conta.  

**Critérios de Aceite**  
1. O campo “E‑mail” aceita apenas valores no formato e‑mail válido.  
2. O campo “Senha” requer no mínimo 8 caracteres, com pelo menos uma letra maiúscula, uma minúscula e um dígito.  
3. Se as credenciais forem inválidas, exibe: “E‑mail ou senha inválidos.”  
4. O botão “Entrar” permanece desabilitado até que ambos campos sejam preenchidos corretamente.  
5. Em login bem‑sucedido, o usuário é redirecionado para `/dashboard`.  

---

**User Story 3 – Visualização de Saldo**  
*US03*  
- **Como** cliente logado,  
- **eu quero** ver o saldo atual da minha conta na página inicial,  
- **para** saber o montante disponível antes de realizar qualquer operação.  

**Descrição**  
O saldo deve ser exibido em moeda local (R$) e atualizado instantaneamente após qualquer transação (transferência, pagamento, etc.).  

**Critérios de Aceite**  
1. O saldo aparece no cabeçalho da página `Dashboard` em formato “Saldo: R$ X.XXX,XX”.  
2. O valor exibido corresponde à soma de: saldo inicial + depósitos - saques/transferências.  
3. O saldo atualiza sem recarregar a página quando uma transação é concluída (Ajax/Fetch).  
4. Se o saldo for zero, a mensagem “Seu saldo está em R$ 0,00” aparece.  

---

**User Story 4 – Consulta de Extrato**  
*US04*  
- **Como** cliente logado,  
- **eu quero** visualizar meu extrato de transações em ordem cronológica,  
- **para** acompanhar movimentações e identificar eventuais erros.  

**Descrição**  
A tela de extrato deve listar transações recentes (últimos 30 dias) com data, tipo (depósito, saque, transferência, pagamento), descrição, valor e saldo resultante.  

**Critérios de Aceite**  
1. O extrato exibe no máximo 30 linhas, ordenadas do mais recente ao mais antigo.  
2. Cada linha contém:  
   - Data (dd/mm/aaaa).  
   - Tipo (ex.: Depósito, Saque, Transferência, Pagamento).  
   - Descrição (conta destino ou beneficiário).  
   - Valor (positivo para créditos, negativo para débitos).  
   - Saldo após a transação.  
3. Ao clicar em “Ver mais”, abre um modal com histórico completo.  
4. Se nenhuma transação existir, exibe “Nenhuma transação encontrada nos últimos 30 dias”.  

---

**User Story 5 – Transferência de Fundos**  
*US05*  
- **Como** cliente logado,  
- **eu quero** transferir dinheiro entre contas do mesmo usuário ou para contas externas,  
- **para** movimentar recursos de forma rápida e segura.  

**Descrição**  
O usuário seleciona conta de origem, conta de destino (número ou CPF), e o valor a ser transferido. O sistema impede transferências que excedam o saldo disponível e registra a operação em ambas as contas.  

**Critérios de Aceite**  
1. O formulário tem campos obrigatórios: **Conta Origem**, **Conta Destino**, **Valor**.  
2. O valor deve ser numérico positivo, com até 2 casas decimais, e menor ou igual ao saldo da conta origem.  
3. Se o valor exceder o saldo, exibe “Saldo insuficiente para essa transferência”.  
4. Ao confirmar, o sistema debitara a conta origem e creditara a conta destino imediatamente.  
5. A transação é registrada no extrato de ambas as contas, aparecendo com tipo “Transferência”.  
6. Uma mensagem de sucesso “Transferência concluída” é exibida, e o saldo atual da origem é atualizado.  

---

**User Story 6 – Solicitação de Empréstimo**  
*US06*  
- **Como** cliente logado,  
- **eu quero** solicitar um empréstimo informando valor e renda anual,  
- **para** obter crédito de acordo com minha capacidade de pagamento.  

**Descrição**  
O formulário aceita o valor do empréstimo (até R$ 200.000) e a renda anual (R$ 20.000 a R$ 1.000.000). O sistema avalia a solicitação e retorna “Aprovado” ou “Negado” com justificativa curta.  

**Critérios de Aceite**  
1. Campos obrigatórios: **Valor do Empréstimo**, **Renda Anual**.  
2. O valor do empréstimo deve estar entre R$ 1.000 e R$ 200.000.  
3. A renda anual deve estar entre R$ 20.000 e R$ 1.000.000.  
4. Após envio, a interface mostra “Processando solicitação...”.  
5. O resultado aparece em modal:  
   - **Aprovado**: “Parabéns! Seu empréstimo de R$ X.XXX,XX foi aprovado.”  
   - **Negado**: “Lamentamos, sua solicitação foi negada. Motivo: Renda insuficiente.”  
6. A decisão não altera o saldo da conta.  

---

**User Story 7 – Pagamento de Contas**  
*US07*  
- **Como** cliente logado,  
- **eu quero** registrar um pagamento de conta (ex.: luz, água, internet) informando beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data,  
- **para** pagar contas de forma prática e ter o registro no histórico.  

**Descrição**  
O pagamento pode ser agendado para data futura. Ao confirmar, o valor é debitado na data escolhida e registrado no extrato.  

**Critérios de Aceite**  
1. Campos obrigatórios: **Beneficiário**, **Endereço**, **Cidade**, **Estado**, **CEP**, **Telefone**, **Conta de Destino**, **Valor**, **Data de Pagamento**.  
2. CEP aceita 8 dígitos; telefone aceita 10 ou 11 dígitos; data deve ser no futuro ou no dia atual.  
3. O sistema reserva o valor na conta de origem na data de pagamento e atualiza o saldo imediatamente na data de agendamento.  
4. Ao confirmar, exibe “Pagamento programado para DD/MM/AAAA”.  
5. A transação aparece no extrato com tipo “Pagamento”.  

---

**User Story 8 – Navegação e Usabilidade Consistentes**  
*US08*  
- **Como** cliente logado,  
- **eu quero** que todas as páginas carreguem sem erros de navegação, exibam mensagens claras e tenham menus consistentes,  
- **para** ter uma experiência de uso intuitiva e sem frustrações.  

**Descrição**  
A estrutura de navegação deve incluir logo, menu principal (Dashboard, Transferir, Empréstimo, Pagamentos, Configurações), e links de “Sair”. Mensagens de erro padrão devem usar cor vermelha e textos explicativos.  

**Critérios de Aceite**  
1. Todas as páginas têm cabeçalho com logo e menu de navegação.  
2. O menu está disponível em todas as páginas e possui links ativos corretos.  
3. Navegar entre páginas não gera erro 404 nem falhas de carregamento.  
4. Mensagens de erro (ex.: “Campo obrigatório”, “Saldo insuficiente”) aparecem em vermelho e desaparecem após 5 s ou ao corrigir o erro.  
5. O layout responde a dispositivos móveis (mobile‑first) e mantém consistência visual.  

---  

Esses 8 User Stories cobrem integralmente os requisitos do documento, mantendo cada história focada, testável e livre de sobreposição de escopo.