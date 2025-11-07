**User Stories – ParaBank (Sprints 1‑2)**  

---

### US01 – Cadastro de Usuário  
**Como** visitante do site,  
**eu quero** criar uma conta no ParaBank informando meus dados pessoais,  
**para** poder acessar posteriormente a aplicação e realizar operações bancárias.

**Descrição**  
- O formulário de cadastro deve conter os campos obrigatórios: nome completo, e‑mail, telefone, CEP, senha e confirmação de senha.  
- Cada campo deve ter validação em tempo real (ex.: CEP 8 dígitos numérico, e‑mail formato válido).  
- Ao submeter o formulário, o sistema deve validar todos os dados e exibir mensagens de erro específicas para cada campo inválido.  
- Se todos os campos forem válidos, a conta é criada, o usuário recebe e‑mail de confirmação e fica habilitado a fazer login.

**Critérios de Aceite**  
1. A tela de cadastro mostra os campos obrigatórios e não permite submissão em branco.  
2. Ao digitar um e‑mail inválido, aparece mensagem “Formato de e‑mail inválido”.  
3. Um CEP com menos de 8 dígitos dispara mensagem “CEP inválido”.  
4. Um telefone com caracteres não numéricos gera mensagem “Telefone deve conter apenas números”.  
5. Se a senha e a confirmação não coincidirem, exibe “As senhas não correspondem”.  
6. Quando todos os campos forem preenchidos corretamente, a conta é criada, um e‑mail de confirmação é enviado e o usuário é redirecionado para a tela de login.  

---

### US02 – Login  
**Como** usuário cadastrado,  
**eu quero** fazer login com minhas credenciais,  
**para** acessar a área de serviços bancários.

**Descrição**  
- A tela de login possui campos para e‑mail e senha, além de “Esqueceu a senha?”.  
- O sistema valida as credenciais em tempo real e permite acesso apenas se forem corretas.  
- Em caso de falha, exibe mensagem de erro clara e mantém a mesma página.  
- Após login bem‑sucedido, o usuário é redirecionado automaticamente para a página inicial da conta (Dashboard).

**Critérios de Aceite**  
1. O formulário requer preenchimento de e‑mail e senha.  
2. Se o e‑mail ou senha forem inválidos, exibe “Credenciais inválidas. Tente novamente.”  
3. A sessão permanece ativa enquanto o usuário não clicar em “Logout”.  
4. O redirecionamento pós‑login leva à página “Dashboard” contendo saldo e extrato.  

---

### US03 – Exibir Saldo e Extrato  
**Como** cliente autenticado,  
**eu quero** visualizar meu saldo atual e o extrato das transações recentes,  
**para** acompanhar o uso dos meus recursos financeiros.

**Descrição**  
- A página de “Dashboard” mostra o saldo em moeda local, atualizado após cada operação.  
- O extrato lista as últimas 10 transações em ordem cronológica decrescente, exibindo data, descrição, tipo (crédito/débito) e valor.  
- Um botão “Ver mais” permite carregar o extrato completo se desejar.

**Critérios de Aceite**  
1. O saldo exibido corresponde ao saldo real da conta do usuário.  
2. O extrato lista no mínimo 10 transações recentes.  
3. Cada transação mostra data (dd/mm/aaaa), descrição, valor e tipo (C/D).  
4. Ao clicar em “Ver mais”, são carregadas as transações restantes sem recarregar a página inteira (AJAX).  

---

### US04 – Transferência de Fundos  
**Como** cliente autenticado,  
**eu quero** transferir dinheiro de uma conta para outra,  
**para** gerenciar meus recursos entre contas ou enviar para terceiros.

**Descrição**  
- O usuário seleciona a conta de origem, a conta de destino (pode ser interna ou externa) e o valor da transferência.  
- O sistema bloqueia a operação se o valor exceder o saldo disponível da conta de origem.  
- Ao confirmar, o valor é debitado da origem e creditado na destinação imediatamente, sendo registrado no histórico de ambas as contas.  
- A tela exibe confirmação da transação com número de referência.

**Critérios de Aceite**  
1. O formulário exige escolha de conta de origem, conta de destino e valor numérico positivo.  
2. Se o valor for maior que o saldo da origem, exibe “Saldo insuficiente”.  
3. A transferência é processada em 3 segundos e mostra “Transferência concluída – Ref: 123456”.  
4. O saldo da conta de origem diminui e o saldo da conta de destino aumenta imediatamente.  
5. As duas contas adicionam a transação ao seu histórico, visível no extrato.  

---

### US05 – Solicitação de Empréstimo  
**Como** cliente autenticado,  
**eu quero** solicitar um empréstimo informando o valor e minha renda anual,  
**para** obter crédito adicional com base no meu perfil financeiro.

**Descrição**  
- O usuário entra em “Solicitar Empréstimo”, preenche o valor desejado e a renda anual.  
- O sistema avalia a solicitação instantaneamente e retorna status “Aprovado” ou “Negado”.  
- O resultado aparece em destaque, e o usuário pode consultar detalhes de cada decisão (ex.: taxa, prazo).

**Critérios de Aceite**  
1. O formulário requer valor do empréstimo (até 5‑6 dígitos) e renda anual.  
2. Se o valor for maior que 500.000 ou a renda for inválida, exibe “Dados fora do limite permitido”.  
3. O sistema processa a solicitação em 5 segundos e exibe “Empréstimo Aprovado – 12% ao ano” ou “Empréstimo Negado – Renda insuficiente”.  
4. O resultado fica visível na página de “Histórico de Empréstimos” para consulta futura.  

---

### US06 – Pagamento de Contas  
**Como** cliente autenticado,  
**eu quero** registrar pagamentos de contas (bills) com dados do beneficiário e agendamento de data,  
**para** garantir que meus débitos sejam realizados na hora certa.

**Descrição**  
- O usuário preenche: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento.  
- O sistema valida todos os campos (CEP 8 dígitos, telefone numérico, data futura).  
- Após confirmação, o pagamento é registrado no histórico e, se agendado, será debitado na data escolhida.  
- Pagamentos futuros não alteram o saldo imediatamente, apenas aguardam a data de cobrança.

**Critérios de Aceite**  
1. Todos os campos são obrigatórios e validados em tempo real.  
2. Se a data de pagamento for no passado, exibe “Data inválida – escolha uma data futura”.  
3. Ao confirmar, exibe “Pagamento agendado para dd/mm/aaaa”.  
4. O pagamento aparece no histórico de transações com status “Agendado”.  
5. No dia da data agendada, o sistema debita automaticamente a conta do usuário e registra a transação como “Pago”.  

---

### US07 – Navegação e Usabilidade (Cross‑Cutting)  
**Como** usuário de qualquer página,  
**eu quero** ter navegação consistente e mensagens de erro claras,  
**para** usar o sistema de forma intuitiva sem confusão.

**Descrição**  
- Todos os menus, links e botões permanecem idênticos em todas as páginas (header, sidebar, footer).  
- As mensagens de erro são exibidas em cores vermelhas e textos claros, sempre alinhadas ao campo problemático.  
- Todas as páginas carregam em menos de 2 s em conexão padrão (3G).  
- O layout é responsivo, suportando desktop, tablet e mobile.

**Critérios de Aceite**  
1. O menu principal contém links: “Dashboard”, “Transferir”, “Empréstimos”, “Pagamentos”, “Extrato”, “Sair”.  
2. A navegação não gera erros 404 nem redirecionamentos inesperados.  
3. Mensagens de erro aparecem sob o campo relevante e não no topo da página.  
4. Em dispositivos móveis, o menu colapsa em um ícone “hamburger” e mantém todas as opções.  
5. O tempo de resposta da página inicial (Dashboard) não ultrapassa 2 s sob tráfego mínimo.  

---

> **Rastreabilidade**  
> *US01* → Cadastro de Usuário  
> *US02* → Login  
> *US03* → Visualização de Saldo & Extrato  
> *US04* → Transferência de Fundos  
> *US05* → Solicitação de Empréstimo  
> *US06* → Pagamento de Contas  
> *US07* → Navegação & Usabilidade  

Essas User Stories cobrem de forma completa e não sobreposta todas as funcionalidades descritas nos critérios de aceite, permitindo planejar o desenvolvimento em sprints ágeis, testar de forma objetiva e entregar valor real ao usuário final.