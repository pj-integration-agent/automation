## User Stories – ParaBank (baseadas no documento de Critérios de Aceite)

> **Formato usado:**  
> **Como** + **Tipo de usuário** (persona), **quero** + **funcionalidade** **para que** + **benefício / valor**  
> **Critérios de Aceite** (lista de condições de sucesso)

> **Princípios INVEST** (Independent, Negotiable, Valuable, Estimable, Small, Testable) foram seguidos para garantir histórias bem‑definidas e prontas para teste.

---

### 1. Cadastro de Usuário  

**Como** novo cliente do ParaBank,  
**quero** cadastrar minha conta no sistema,  
**para que** eu possa usar todos os serviços bancários disponíveis.  

**Critérios de Aceite**  
| C |  
|---|  
| 1.1 Todos os campos obrigatórios (nome, sobrenome, telefone, CEP, email, senha) são obrigatórios e não aceitam valores vazios.  
| 1.2 O campo de telefone aceita apenas números e formato (DDD + nº).  
| 1.3 O campo CEP aceita apenas 8 dígitos numéricos.  
| 1.4 O campo email é validado quanto a sintaxe correta (`exemplo@dominio.com`).  
| 1.5 Se algum campo for inválido, o sistema exibe uma mensagem de erro específica e clara, destacando o campo problemático.  
| 1.6 Ao submeter um cadastro válido, o usuário recebe uma mensagem de confirmação “Cadastro realizado com sucesso” e é habilitado a fazer login.  
| 1.7 O usuário não pode enviar um e‑mail já registrado no banco de dados (duplicidade).  

---

### 2. Login  

**Como** usuário autenticado do ParaBank,  
**quero** fazer login com minhas credenciais,  
**para que** eu acesse minha conta e realize transações.  

**Critérios de Aceite**  
| C |  
|---|  
| 2.1 O usuário deve informar e‑mail e senha.  
| 2.2 Se as credenciais forem válidas, a aplicação redireciona o usuário para a página inicial da conta.  
| 2.3 Se as credenciais forem inválidas (e‑mail não encontrado ou senha incorreta), o sistema exibe “Credenciais inválidas. Por favor, tente novamente.”  
| 2.4 O login não deve permitir mais de 5 tentativas consecutivas; após a quinta falha, a conta fica bloqueada por 15 minutos, exibindo a mensagem “Conta bloqueada. Tente novamente em 15 minutos.”  

---

### 3. Acesso à Conta (Saldo e Extrato)

#### 3.1 Exibição do Saldo  
**Como** cliente,  
**quero** ver meu saldo atualizado na página inicial,  
**para que** eu saiba quanto dinheiro tenho disponível a qualquer momento.  

**Critérios de Aceite**  
| C |  
|---|  
| 3.1.1 O saldo é calculado automaticamente após cada operação (depósito, retirada, transferência).  
| 3.1.2 O saldo é exibido em moeda local, com 2 casas decimais e separador de milhares.  

#### 3.2 Visualização do Extrato  
**Como** cliente,  
**quero** visualizar meu extrato de transações recentes,  
**para que** eu possa acompanhar todas as movimentações da conta.  

**Critérios de Aceite**  
| C |  
|---|  
| 3.2.1 O extrato lista as 10 transações mais recentes em ordem cronológica (mais recente em primeiro).  
| 3.2.2 Cada linha exibe: data, descrição, valor, saldo pós‑transação.  
| 3.2.3 Há uma opção “Ver mais” que abre a página de extrato completo.  

---

### 4. Transferência de Fundos  

**Como** cliente com saldo disponível,  
**quero** transferir fundos de uma conta para outra,  
**para que** eu possa enviar dinheiro para parceiros ou outras contas pessoais.  

**Critérios de Aceite**  
| C |  
|---|  
| 4.1 O usuário seleciona conta de origem (a própria).  
| 4.2 O usuário seleciona conta de destino (ou outro número de conta).  
| 4.3 O usuário insere o valor da transferência (até 2 casas decimais).  
| 4.4 O sistema bloqueia a transferência se o valor for maior que o saldo disponível.  
| 4.5 O usuário confirma a transferência e, em seguida, o valor é debitado da conta de origem e creditado na conta de destino.  
| 4.6 A transação aparece no histórico de ambas as contas (origem e destino).  
| 4.7 A transferência gera um e‑mail de confirmação com detalhes (data, valor, contas envolvidas).  

---

### 5. Solicitação de Empréstimo  

**Como** cliente que precisa de capital adicional,  
**quero** solicitar um empréstimo,  
**para que** eu obtenha o montante necessário para meus projetos.  

**Critérios de Aceite**  
| C |  
|---|  
| 5.1 O usuário informa o valor desejado e a renda anual bruta.  
| 5.2 O sistema calcula a taxa de juros e a parcela mensal com base em regras internas (ex.: renda >= 3x valor do empréstimo → aprovação automática).  
| 5.3 O sistema retorna o status “Aprovado” ou “Negado” e exibe o motivo (ex.: “Renda insuficiente”).  
| 5.4 Se aprovado, o valor do empréstimo é creditado na conta do usuário em 24 h.  
| 5.5 O usuário pode visualizar o contrato e o cronograma de parcelas na tela de “Empréstimos”.  

---

### 6. Pagamento de Contas  

**Como** cliente,  
**quero** cadastrar e agendar pagamentos de contas,  
**para que** eu não perca vencimentos e mantenha meu crédito em dia.  

**Critérios de Aceite**  
| C |  
|---|  
| 6.1 O usuário insere beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento.  
| 6.2 O sistema valida o CEP (8 dígitos) e telefone (DDD + nº).  
| 6.3 Se a data de pagamento for anterior à data atual, o sistema exibe “Data inválida. A data deve ser no futuro.”  
| 6.4 A confirmação de pagamento é exibida em tela e enviada por e‑mail.  
| 6.5 O pagamento aparece no histórico de transações na data programada.  
| 6.6 O usuário pode editar ou cancelar pagamentos agendados até 24 h antes da data de pagamento.  

---

### 7. Requisitos Gerais de Navegação e Usabilidade  

**Como** qualquer usuário,  
**quero** que todas as páginas e menus sejam consistentes e sem erros de navegação,  
**para que** a experiência seja intuitiva e sem frustração.  

**Critérios de Aceite**  
| C |  
|---|  
| 7.1 Todos os links de navegação (menu superior, sidebar, footer) estão disponíveis e funcionam em todas as páginas.  
| 7.2 As páginas carregam em até 3 segundos em conexão de 3 G.  
| 7.3 Mensagens de erro (formulários, autenticação, operações) são exibidas em destaque vermelho, acompanhadas de ícone de alerta.  
| 7.4 Os botões de ação (“Confirmar”, “Cancelar”, “Enviar”) têm tamanhos e cores padronizadas.  
| 7.5 O layout é responsivo: a interface funciona corretamente em desktop, tablet e smartphone.  

---

## Organização das Histórias

| **Epic** | **User Story** | **Prioridade** |
|---|---|---|
| Cadastro e Acesso | 1. Cadastro de Usuário | ★★★★★ |
| Cadastro e Acesso | 2. Login | ★★★★★ |
| Conta | 3.1 Exibição do Saldo | ★★★★☆ |
| Conta | 3.2 Visualização do Extrato | ★★★★☆ |
| Transferências | 4. Transferência de Fundos | ★★★★★ |
| Empréstimos | 5. Solicitação de Empréstimo | ★★★★☆ |
| Pagamentos | 6. Pagamento de Contas | ★★★★☆ |
| Usabilidade | 7. Navegação e Consistência | ★★★★★ |

> **Observação:** Cada história pode ser subdividida em tarefas técnicas (ex.: criar componentes de formulário, integrar API de validação de CEP) para a equipe de desenvolvimento.  
> As histórias de **usabilidade** e **navegação** são cross‑cutting e devem ser revisadas em conjunto com todas as demais funcionalidades.

---

### Próximos Passos

1. **Revisão com stakeholders** – confirmar que todas as funcionalidades e critérios estão alinhados com os objetivos de negócio.  
2. **Planejamento de sprints** – distribuir as histórias nos próximos ciclos, considerando capacidade da equipe.  
3. **Configuração de automação** – criar testes automatizados para cada critério de aceite (ex.: UI tests, unit tests de validação).  
4. **Validação de usabilidade** – testes de usuário para garantir que a experiência é clara e intuitiva.  

Com estas user stories bem definidas, a equipe de desenvolvimento tem um guia claro, mensurável e alinhado às expectativas do ParaBank. Boa sorte na implementação!