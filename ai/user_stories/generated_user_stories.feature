## User‑Story Backlog – ParaBank  
*(Siga a estrutura INVEST – Independente, Negotiable, Valuable, Estimável, Small, Testável)*  

| ID | Epic | User Story | Critérios de Aceitação (adaptados do documento) | Estimativa (Pontos) | Dependências |
|----|------|------------|----------------------------------------------|----------------------|--------------|
| **US‑01** | Cadastro de Usuário | **Como** novo cliente do ParaBank **quero** cadastrar minha conta no sistema **para que** eu possa usar os serviços bancários. | 1. Todos os campos obrigatórios (nome, e‑mail, senha, telefone, CEP, endereço, cidade, estado, CPF) devem estar preenchidos para concluir o cadastro. <br> 2. Validações de campo (formato de e‑mail, telefone, CEP, CPF) devem gerar mensagens de erro claras e específicas. <br> 3. Após cadastro bem‑sucedido, a tela exibe confirmação e habilita o usuário a fazer login. | 5 | |
| **US‑02** | Login | **Como** cliente já cadastrado **quero** fazer login no ParaBank **para que** eu acesse minha conta. | 1. A tela de login aceita e valida credenciais (e‑mail e senha) válidas. <br> 2. Se as credenciais forem inválidas, o sistema exibe mensagem de erro (ex.: “Usuário ou senha incorretos”). <br> 3. Após login bem‑sucedido, o usuário é redirecionado automaticamente para a página inicial da conta (dashboard). | 3 | US‑01 (pessoas já cadastradas) |
| **US‑03** | Dashboard – Saldo e Extrato | **Como** cliente autenticado **quero** ver meu saldo e extrato atualizados **para que** eu tenha controle sobre minhas finanças. | 1. A página de dashboard exibe o saldo atual da conta, refletindo todas as operações recentes. <br> 2. O extrato lista as transações mais recentes em ordem cronológica (data/hora, tipo, valor, saldo pós‑transação). <br> 3. Saldo e extrato são atualizados em tempo real ou via refresh automático. | 4 | US‑02 |
| **US‑04** | Transferência de Fundos | **Como** cliente autenticado **quero** transferir fundos entre minhas contas **para que** eu possa mover dinheiro de forma segura. | 1. A tela de transferência permite selecionar conta de origem, conta de destino e digitar valor. <br> 2. O sistema bloqueia transferências cujo valor excede o saldo disponível na conta de origem. <br> 3. Ao confirmar, o valor é debitado na origem e creditado na destino, e ambas as contas registram a transação no histórico. <br> 4. Mensagens de confirmação ou erro (ex.: “Transferência concluída com sucesso”) são exibidas. | 5 | US‑03 |
| **US‑05** | Solicitação de Empréstimo | **Como** cliente autenticado **quero** solicitar um empréstimo **para que** eu possa obter crédito quando necessário. | 1. A tela de solicitação pede valor do empréstimo e renda anual. <br> 2. O sistema processa a solicitação e retorna status “Aprovado” ou “Negado”, com justificativa (ex.: “Renda insuficiente”). <br> 3. O resultado é exibido em destaque na tela de solicitação. | 3 | US‑03 |
| **US‑06** | Pagamento de Contas | **Como** cliente autenticado **quero** registrar pagamentos de contas (eletrônicos ou agendados) **para que** eu mantenha meus débitos em dia. | 1. O formulário exige beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento. <br> 2. Após confirmação, o pagamento aparece no histórico de transações da conta. <br> 3. Pagamentos agendados respeitam a data programada (não são debitados antes). | 4 | US‑03 |
| **US‑07** | Navegação e Usabilidade | **Como** usuário de qualquer página **quero** que a navegação seja consistente e livre de erros **para que** eu possa usar o sistema sem confusão. | 1. Todas as páginas carregam sem erros de navegação (links válidos, menus acessíveis). <br> 2. Mensagens de erro são claras, objetivas e exibidas perto do campo afetado. <br> 3. Links e menus (Home, Saldo, Extrato, Transferir, Empréstimo, Pagamento, Logout) são consistentes em todas as páginas. | 2 | Todas |
| **US‑08** | Segurança e Validação | **Como** desenvolvedor QA **quero** que todas as validações sejam testáveis **para que** eu garanta qualidade. | 1. Todos os campos têm regras de validação unitárias e de integração. <br> 2. Mensagens de erro são retornadas via API com códigos HTTP adequados (400, 401, 403). <br> 3. Logs de erro não expõem dados sensíveis. | 3 | Todos |

---

### Exemplos de Histórias detalhadas

#### US‑01 – Cadastro de Usuário  
**Como** novo cliente do ParaBank  
**Quero** preencher um formulário de cadastro completo  
**Para que** eu obtenha uma conta bancária válida e possa fazer login.

- **Critérios**  
  - O formulário possui campos: nome, e‑mail, senha, telefone, CEP, endereço, cidade, estado, CPF.  
  - Se algum campo obrigatório estiver vazio, a mensagem “Campo obrigatório” aparece abaixo do campo.  
  - Se o e‑mail não estiver no formato padrão, aparece “E‑mail inválido”.  
  - Se o CEP não for numérico ou tiver tamanho incorreto, aparece “CEP inválido”.  
  - Se o CPF não for válido, aparece “CPF inválido”.  
  - Ao submeter dados válidos, a página exibe “Cadastro realizado com sucesso” e redireciona para a tela de login após 3 s.

#### US‑04 – Transferência de Fundos  
**Como** cliente autenticado  
**Quero** transferir 100,00 R$ da minha Conta Corrente para a Conta Poupança  
**Para que** eu possa movimentar dinheiro entre minhas contas.

- **Critérios**  
  1. O usuário abre a tela Transferir.  
  2. Selecione “Conta Corrente” como origem e “Conta Poupança” como destino.  
  3. Insira valor 100,00.  
  4. Se o saldo da conta origem for < 100,00, exibe “Saldo insuficiente” e desabilita o botão “Confirmar”.  
  5. Caso contrário, ao clicar “Confirmar”, a transação ocorre em < 5 s.  
  6. O saldo da conta origem diminui 100,00; a conta destino aumenta 100,00.  
  7. A transação aparece no extrato das duas contas com data/hora, tipo “Transferência”, valor e saldo pós‑transação.  
  8. Exibe “Transferência concluída” em popup.

#### US‑06 – Pagamento de Contas  
**Como** cliente autenticado  
**Quero** agendar um pagamento de 150,00 R$ para o beneficiário “Electric Co.” no dia 15/12/2025  
**Para que** o pagamento seja debitado na data correta.

- **Critérios**  
  1. O usuário abre a tela “Pagamentos”.  
  2. Preenche: Beneficiário = Electric Co., Endereço = Rua X, 123, Cidade = São Paulo, Estado = SP, CEP = 01234-567, Telefone = (11) 91234-5678, Conta de Destino = 987654321, Valor = 150,00, Data = 2025‑12‑15.  
  3. Ao confirmar, aparece “Pagamento agendado para 15/12/2025”.  
  4. No extrato, a transação aparece como “Pagamento” com data 15/12/2025, valor 150,00, saldo pós‑transação.  
  5. Se a data for no passado, exibe “Data de pagamento inválida – deve ser futura”.  

---

### Prioridade (MVP)

1. **US‑01** – Cadastro  
2. **US‑02** – Login  
3. **US‑03** – Dashboard (saldo & extrato)  
4. **US‑04** – Transferência de Fundos  
5. **US‑06** – Pagamento de Contas  
6. **US‑05** – Solicitação de Empréstimo  
7. **US‑07** – Navegação & Usabilidade  
8. **US‑08** – Segurança & Validação  

> *Obs.: Os itens 6–8 são fundamentais para garantir qualidade e experiência, mas podem ser entregues em iterações posteriores.*

---

## Checklist de Aceitação (para cada Epic)

- **Validação de UI** – Todos os campos têm rótulos claros e placeholders (ex.: “ex.: joao@exemplo.com”).
- **Validação de Dados** – Testes unitários (frontend) e de API (backend) cobrem casos de sucesso e falha.
- **Teste de Navegação** – Navegações de página (Home → Transferir → Extrato → Logout) não geram erros 404.
- **Testes de Segurança** – Senhas são criptografadas; CSRF/XSS mitigados; logs não expõem dados sensíveis.
- **Testes de Performance** – Transferências e pagamentos respondem < 5 s em condições de carga padrão.
- **Testes de Usabilidade** – 5 usuários de teste avaliam clareza das mensagens e fluxo de operação.

---

### Próximos Passos

1. **Backlog Refinement** – Ajustar estimativas e quebrar histórias muito grandes (ex.: “Transferência” pode ser subdividida em “Seleção de contas” e “Confirmação de valor”).  
2. **Sprint Planning** – Definir iteração de 2 semanas para entregar o MVP (US‑01 a US‑04).  
3. **Automated Acceptance Tests** – Implementar testes Cucumber/Gherkin alinhados aos critérios.  
4. **UX Review** – Revisão de interface com designers para garantir consistência de menus e mensagens.  

--- 

**Fim do backlog**