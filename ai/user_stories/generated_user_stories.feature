**User Stories – ParaBank**  
*(todos os stories estão escritos em português, seguindo o formato “Como X, eu quero Y para que Z”).*  
*(As acepções são explicitadas em formato *Given‑When‑Then*, para facilitar a validação.)*  

---

### 1. Cadastro de Usuário  
**Como** um novo cliente do ParaBank,  
**Quero** registrar meus dados pessoais na aplicação,  
**Para que** eu possa ter uma conta bancária ativa e acessar o sistema.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| A tela de cadastro está aberta | Eu preencho todos os campos obrigatórios (nome, CPF, telefone, CEP, email, senha) | O sistema valida cada campo; se algum estiver inválido, exibe mensagem de erro específica |
| Os campos telefone, CEP e email contêm valores inválidos | Eu tento salvar | Mensagem de erro clara e objetiva é exibida (ex.: “Telefone inválido”, “CEP inválido”, “Email inválido”) |
| Todos os campos obrigatórios são preenchidos corretamente | Eu salvo | O cadastro é criado, uma mensagem de confirmação é exibida e eu consigo fazer login com as credenciais fornecidas |

---

### 2. Login  
**Como** usuário já cadastrado,  
**Quero** fazer login com minhas credenciais,  
**Para que** eu seja redirecionado para a página inicial da minha conta.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| A página de login está aberta | Eu informo credenciais válidas (email e senha) | O sistema autentica e redireciona para a página inicial da conta |
| Eu informo credenciais inválidas | Eu tento fazer login | O sistema exibe mensagem de erro adequada (ex.: “Credenciais inválidas” ou “Usuário não encontrado”) |

---

### 3. Acesso à Conta – Saldo e Extrato  
**Como** cliente autenticado,  
**Quero** visualizar o saldo atualizado e o extrato das minhas transações,  
**Para que** eu possa acompanhar minhas finanças em tempo real.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| Eu estou na página inicial da conta | O sistema carrega | O saldo exibido corresponde ao saldo real, atualizado após cada operação |
| Eu acesso a seção de extrato | O sistema carrega | O extrato lista todas as transações recentes em ordem cronológica (mais recente acima) |

---

### 4. Transferência de Fundos  
**Como** cliente autenticado,  
**Quero** transferir um valor de uma conta para outra,  
**Para que** eu possa movimentar meus recursos entre contas.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| Eu estou na página de transferência | Eu seleciono conta de origem, conta de destino e digito um valor | O sistema verifica se o valor é menor ou igual ao saldo da origem |
| O valor excede o saldo disponível | Eu tento confirmar a transferência | O sistema exibe mensagem de erro: “Saldo insuficiente” e a transferência não é processada |
| O valor é permitido | Eu confirmo a transferência | O valor é debitado da conta origem, creditado na conta destino e registrado no histórico de ambas as contas |

---

### 5. Solicitação de Empréstimo  
**Como** cliente interessado em obter um crédito,  
**Quero** solicitar um empréstimo informando valor e renda anual,  
**Para que** o sistema avalie minha proposta e me informe se foi aprovada ou negada.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| Eu estou na página de solicitação de empréstimo | Eu informo valor do empréstimo e renda anual | O sistema processa e retorna status “Aprovado” ou “Negado” |
| O status é retornado | O usuário visualiza o resultado | O resultado é exibido de forma clara e destacada (ex.: “Empréstimo aprovado” ou “Empréstimo negado”) |

---

### 6. Pagamento de Contas  
**Como** cliente autenticado,  
**Quero** registrar um pagamento de conta, informando beneficiário e demais dados,  
**Para que** o pagamento seja incluído no histórico e, se agendado, seja processado na data correta.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| Eu estou na página de pagamento de contas | Eu preencho: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data (se for agendamento) | O sistema valida os dados e exibe mensagens de erro se houver inconsistência |
| Eu confirmo o pagamento | O sistema registra a transação | O pagamento aparece no histórico de transações, e pagamentos futuros respeitam a data agendada |
| Eu deixo a data de pagamento em aberto | Eu confirmo | O pagamento é processado imediatamente e registrado no histórico |

---

### 7. Requisitos Gerais – Navegação e Usabilidade  
**Como** qualquer usuário (autenticado ou não)  
**Quero** que todas as páginas e funcionalidades estejam livres de erros de navegação e que a interface seja consistente,  
**Para que** a experiência seja fluida, segura e compreensível.  

**Acceptance Criteria**

| Given | When | Then |
|-------|------|------|
| Eu acesso qualquer página | O sistema carrega a página | Não há erros de carregamento nem redirecionamentos inesperados |
| Eu interajo com links ou menus | Eu clico | O link ou menu leva à página correta e a navegação é consistente em todas as páginas |
| Eu recebo mensagens de erro (por exemplo, campos inválidos) | O sistema exibe | As mensagens são claras, objetivas e localizadas perto do campo ou ação que causou o erro |

---

#### Observações Adicionais
- Todos os stories assumem que a aplicação está hospedada em um ambiente de teste controlado (ParaBank).
- As validações de campo (telefone, CEP, e‑mail) devem seguir os padrões oficiais brasileiros.
- A segurança de senhas e dados sensíveis deve obedecer às melhores práticas de criptografia e armazenamento.

**Próximos Passos**  
- Transformar os *stories* em testes automatizados (ex.: Cucumber ou Gherkin) para validação contínua.  
- Priorizar histórias com base em valor ao cliente e risco.  
- Criar histórias de *bugfix* caso falhas sejam identificadas durante testes de aceitação.  

Boa sorte no desenvolvimento e testes do ParaBank!