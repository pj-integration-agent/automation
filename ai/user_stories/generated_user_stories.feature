**User Stories – ParaBank (versão de demonstração)**  
*Abaixo estão listadas as histórias de usuário que cobrem todas as funcionalidades descritas no documento de critérios de aceite. Cada story segue a estrutura clássica **“Como [tipo de usuário] – quero [recurso] – para que [benefício]”** e traz os critérios de aceitação específicos que garantem a qualidade e a consistência do sistema.*

---

## 1. Cadastro de Usuário

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-01** | Novo cliente | Registrar uma conta no ParaBank | Tenha acesso ao sistema após a criação da conta |
| **US-02** | Usuário que tenta se cadastrar | Preencher todos os campos obrigatórios | Evitar erros de preenchimento incompleto |
| **US-03** | Usuário que digita dados inválidos | Validar telefone, CEP e e‑mail | Garantir que os dados sejam corretos antes de salvar |
| **US-04** | Usuário que conclui o cadastro | Receber confirmação de cadastro | Saber que o registro foi concluído com sucesso |

### Critérios de Aceitação

1. Todos os campos marcados com *“obrigatório”* devem estar preenchidos antes do envio.  
2. Validações de **telefone**, **CEP** e **e‑mail** devem ser executadas no momento da digitação ou antes do envio, exibindo mensagens de erro claras e específicas.  
3. Em caso de dados inválidos, o sistema deve impedir o envio e destacar o campo problemático.  
4. Após cadastro bem‑sucedido, o usuário recebe uma mensagem de confirmação e pode proceder ao login.  

---

## 2. Login

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-05** | Cliente existente | Entrar no sistema | Ter acesso à sua conta bancária |
| **US-06** | Usuário com credenciais inválidas | Receber mensagem de erro | Entender que a tentativa falhou e corrigir a informação |

### Critérios de Aceitação

1. O sistema aceita credenciais (e‑mail/CPF + senha) válidas e redireciona para a **página inicial da conta**.  
2. Credenciais inválidas acionam mensagem de erro genérica (“E‑mail ou senha inválidos”).  
3. Após login, a sessão permanece válida enquanto o usuário não sair.  

---

## 3. Acesso à aplicação bancária – Saldo e Extrato

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-07** | Cliente logado | Visualizar saldo atualizado | Saber quanto dinheiro tenho disponível |
| **US-08** | Cliente logado | Ver extrato de transações | Entender histórico de movimentações |

### Critérios de Aceitação

1. A tela de saldo mostra o valor atual **imediatamente** após qualquer operação (depósito, retirada, transferência, pagamento).  
2. O extrato lista **transações recentes** em ordem cronológica decrescente (mais recente primeiro).  
3. Cada linha do extrato deve conter data, tipo, valor e saldo após a transação.  

---

## 4. Transferência de Fundos

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-09** | Cliente logado | Transferir dinheiro para outra conta | Movimentar fundos sem sair da aplicação |
| **US-10** | Cliente logado | Selecionar origem, destino e valor | Garantir que a transferência seja realizada corretamente |
| **US-11** | Cliente logado | Prevenir transferências acima do saldo | Evitar débito negativo e manter consistência de saldos |

### Critérios de Aceitação

1. A interface exibe campos para **conta de origem**, **conta de destino** e **valor**.  
2. O sistema valida que o valor não excede o saldo disponível da conta origem. Se exceder, exibe mensagem de erro (“Saldo insuficiente”).  
3. Após confirmação, o valor é debitado da origem, creditado na destino e registrado no histórico de ambas as contas.  
4. A transação aparece no extrato da conta de origem como “Transferência” e no extrato da conta de destino como “Transferência recebida”.  

---

## 5. Solicitação de Empréstimo

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-12** | Cliente logado | Solicitar um empréstimo | Obter crédito adicional se necessário |
| **US-13** | Cliente logado | Informar valor e renda anual | Possibilitar análise de crédito automatizada |
| **US-14** | Cliente logado | Receber decisão de aprovação ou negação | Saber imediatamente se a solicitação foi aceita |

### Critérios de Aceitação

1. Formulário aceita **valor do empréstimo** e **renda anual** do cliente.  
2. O sistema processa a solicitação e retorna status **“Aprovado”** ou **“Negado”**.  
3. A decisão é exibida de forma clara e imediata (ex.: banner, modal).  
4. Em caso de aprovação, o valor deve ser creditado na conta do cliente.  

---

## 6. Pagamento de Contas

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-15** | Cliente logado | Registrar pagamento a terceiros | Pagar contas de forma automatizada |
| **US-16** | Cliente logado | Informar beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data | Garantir que o pagamento seja executado com todos os dados corretos |
| **US-17** | Cliente logado | Agendar pagamentos futuros | Planejar despesas sem intervenção manual |

### Critérios de Aceitação

1. O formulário requer todos os campos listados (beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor, data).  
2. Após confirmação, o pagamento é registrado no histórico de transações da conta do cliente.  
3. Pagamentos agendados devem respeitar a data de agendamento e não serem debitados antes da data marcada.  
4. O sistema exibe confirmação de pagamento com detalhes (beneficiário, valor, data).  

---

## 7. Requisitos Gerais de Navegação e Usabilidade

| História | Como | Quero | Para que |
|----------|------|-------|----------|
| **US-18** | Usuário em qualquer página | Navegar entre as funcionalidades sem erros | Experiência de uso fluida |
| **US-19** | Usuário | Mensagens de erro claras e objetivas | Entender rapidamente o que está errado |
| **US-20** | Usuário | Links e menus consistentes em todas as páginas | Não se perder no sistema |

### Critérios de Aceitação

1. Todas as páginas devem carregar **sem erros de navegação** (ex.: rotas inválidas, links quebrados).  
2. Mensagens de erro devem aparecer **imediatamente** e conter linguagem simples.  
3. Menus de navegação (header, sidebar, footer) devem possuir os mesmos itens em todas as páginas e ter comportamento responsivo.  
4. O layout deve ser responsivo e funcionar em dispositivos de tamanhos variados (desktop, tablet, mobile).  

---

## Resumo das Histórias

| ID | Título | Prioridade (1‑Alta) |
|----|--------|---------------------|
| US‑01 | Registro de Conta | 1 |
| US‑02 | Campos obrigatórios | 1 |
| US‑03 | Validação de dados | 1 |
| US‑04 | Confirmação de cadastro | 1 |
| US‑05 | Login | 1 |
| US‑06 | Mensagem de erro login | 1 |
| US‑07 | Visualizar saldo | 1 |
| US‑08 | Visualizar extrato | 2 |
| US‑09 | Transferir fundos | 1 |
| US‑10 | Seleção de contas e valor | 1 |
| US‑11 | Evitar saldo insuficiente | 1 |
| US‑12 | Solicitar empréstimo | 2 |
| US‑13 | Informar dados de empréstimo | 2 |
| US‑14 | Decisão de empréstimo | 2 |
| US‑15 | Registrar pagamento | 2 |
| US‑16 | Dados do pagamento | 2 |
| US‑17 | Agendar pagamento | 2 |
| US‑18 | Navegação sem erros | 1 |
| US‑19 | Mensagens de erro | 1 |
| US‑20 | Menus consistentes | 1 |

> **Observação**: A priorização é apenas orientativa; em sprints de menor escopo pode ser ajustada de acordo com as necessidades do cliente.

---

### Como usar esses stories

1. **Planejamento**: Crie um backlog contendo todas as stories.  
2. **Refinamento**: Quebre cada história em tarefas menores (design, API, testes).  
3. **Desenvolvimento**: Implemente as histórias em sprints curtos, garantindo que os critérios de aceitação sejam cobertos pelos testes automatizados.  
4. **Validação**: Realize testes de usabilidade e de interface para confirmar a consistência das mensagens e navegação.  
5. **Release**: Disponibilize a versão de demonstração, garantindo que cada story esteja funcionando conforme o esperado.

Esses User Stories fornecem um roteiro completo para desenvolver, testar e validar o ParaBank, garantindo que todos os requisitos de aceite sejam atendidos de forma estruturada e orientada ao usuário.