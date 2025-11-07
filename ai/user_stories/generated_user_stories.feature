**US01 – Registro de Usuário**  
Como **novo usuário**, eu quero registrar minha conta para poder acessar os serviços bancários online.  
**Descrição**: O sistema deve disponibilizar um formulário de cadastro contendo todos os campos obrigatórios (nome completo, CPF, data de nascimento, endereço, telefone, CEP, e‑mail e senha). Cada campo deve ser validado de acordo com seus formatos específicos (ex.: telefone no padrão “(xx) xxxxx‑xxxx”, CEP no padrão “xxxxx‑xxx”, e‑mail com sintaxe válida). Quando o usuário submeter o formulário, o sistema deve confirmar o cadastro com uma mensagem de sucesso e tornar a conta imediatamente ativa para login.  
**Critérios de Aceite**  
- [ ] Todos os campos obrigatórios são obrigatórios e bloqueiam o envio se vazios.  
- [ ] Campos “telefone”, “CEP” e “e‑mail” exibem mensagem de erro clara caso o formato seja inválido.  
- [ ] Ao submeter o cadastro com dados válidos, o usuário recebe mensagem de confirmação “Cadastro concluído com sucesso!”.  
- [ ] Após a confirmação, o usuário pode acessar a tela de login e autenticar-se com a conta recém‑criada.  

---

**US02 – Login**  
Como **usuário autenticado**, eu quero fazer login no sistema usando credenciais válidas para acessar minha conta.  
**Descrição**: O usuário deverá inserir e‑mail (ou número de telefone) e senha em campo de login. O sistema deve validar a existência da conta e a correspondência da senha. Em caso de sucesso, o usuário é redirecionado para a página inicial da conta. Em caso de erro, a mensagem de falha deve ser exibida de forma clara.  
**Critérios de Aceite**  
- [ ] O usuário pode inserir credenciais corretas e é autenticado com sucesso.  
- [ ] O usuário recebe a página inicial da conta após login bem‑sucedido.  
- [ ] Credenciais inválidas (e‑mail ou senha incorretos) exibem a mensagem “Credenciais inválidas. Por favor, tente novamente.”  
- [ ] O sistema bloqueia o acesso à página inicial sem login.  

---

**US03 – Visualização do Saldo**  
Como **cliente bancário**, eu quero visualizar meu saldo atual para saber quanto dinheiro tenho disponível.  
**Descrição**: No painel inicial, o sistema deve exibir o saldo da conta do usuário, atualizado em tempo real após cada operação financeira (transferência, pagamento, etc.).  
**Critérios de Aceite**  
- [ ] O saldo exibido corresponde ao saldo real da conta no banco de dados.  
- [ ] Após qualquer operação financeira, o saldo é recalculado e mostrado imediatamente.  
- [ ] O saldo é formatado em moeda (ex.: R$ 1.234,56).  

---

**US04 – Extrato de Transações**  
Como **cliente bancário**, eu quero visualizar o extrato com transações recentes em ordem cronológica para acompanhar minhas movimentações.  
**Descrição**: O sistema deve listar no extrato as transações realizadas nos últimos 30 dias, exibindo data, descrição, tipo (crédito/débito) e valor, ordenadas do mais recente para o mais antigo.  
**Critérios de Aceite**  
- [ ] O extrato lista pelo menos as 10 transações mais recentes.  
- [ ] Cada linha contém data (dd/mm/aaaa), descrição, tipo (Crédito/Débito) e valor formatado.  
- [ ] As transações são ordenadas cronologicamente do mais recente ao mais antigo.  
- [ ] O usuário pode filtrar por período (opcional).  

---

**US05 – Transferência de Fundos**  
Como **cliente bancário**, eu quero transferir um valor de minha conta para outra conta para realizar pagamentos ou enviar dinheiro a terceiros.  
**Descrição**: O usuário deve selecionar a conta de origem (sua conta), escolher a conta de destino (identificada por número), inserir o valor e confirmar a operação. O sistema deve impedir transferências cujo valor exceda o saldo disponível, debitar a origem, creditar a destino e registrar a transação em ambas as contas.  
**Critérios de Aceite**  
- [ ] O sistema bloqueia transferências cujo valor seja maior que o saldo disponível, exibindo “Saldo insuficiente”.  
- [ ] Ao confirmar, o valor é debitado da conta de origem e creditado na conta de destino.  
- [ ] A transação aparece no histórico de ambas as contas.  
- [ ] O usuário recebe mensagem de confirmação “Transferência concluída com sucesso”.  

---

**US06 – Solicitação de Empréstimo**  
Como **cliente bancário**, eu quero solicitar um empréstimo informando valor e renda anual para obter financiamento.  
**Descrição**: O usuário preenche um formulário com o valor solicitado e a renda anual. O sistema avalia a solicitação e retorna um status (“Aprovado” ou “Negado”) com um motivo claro em caso de negativa.  
**Critérios de Aceite**  
- [ ] O formulário exige valor do empréstimo e renda anual, ambos válidos.  
- [ ] O sistema processa a solicitação e exibe “Empréstimo Aprovado” ou “Empréstimo Negado”.  
- [ ] Em caso de negativa, o sistema mostra uma razão (ex.: “Renda insuficiente” ou “Histórico de crédito ruim”).  
- [ ] O resultado é visível na tela de solicitação e pode ser salvo no histórico do usuário.  

---

**US07 – Pagamento de Contas**  
Como **cliente bancário**, eu quero registrar um pagamento de conta informando beneficiário e detalhes para que o pagamento seja incluído no histórico e agendado corretamente.  
**Descrição**: O usuário preenche campos: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento. O sistema deve validar o formato de cada campo e, ao confirmar, registrar a transação e permitir pagamentos futuros respeitando a data agendada.  
**Critérios de Aceite**  
- [ ] Todos os campos obrigatórios são preenchidos e validados (CEP, telefone, data).  
- [ ] O valor do pagamento não pode ser negativo.  
- [ ] Após confirmação, a transação aparece no histórico com data marcada.  
- [ ] O usuário pode editar ou cancelar pagamentos agendados antes da data de vencimento.  

---

**US08 – Navegação e Usabilidade Consistentes**  
Como **usuário do ParaBank**, eu quero que todas as páginas carreguem corretamente e que os menus sejam consistentes para que a experiência seja fluída e intuitiva.  
**Descrição**: O sistema deve garantir que cada página carregue sem erros de navegação, que os links e menus estejam presentes em todas as telas (login, cadastro, conta, extrato, transferências, empréstimo, pagamento). Mensagens de erro devem aparecer de forma clara e objetiva.  
**Critérios de Aceite**  
- [ ] Todas as páginas carregam dentro de 3 s em conexão típica.  
- [ ] Menus de navegação (ex.: “Conta”, “Transferência”, “Empréstimo”, “Pagamentos”, “Extrato”) estão visíveis em todas as telas de usuário autenticado.  
- [ ] Ao clicar em qualquer link, o usuário é levado à página correta.  
- [ ] Mensagens de erro (ex.: “Erro ao carregar a página”) são exibidas em destaque e com sugestão de ação.  
- [ ] A navegação funciona corretamente em dispositivos desktop e mobile (responsividade).  

---