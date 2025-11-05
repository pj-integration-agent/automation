## User Stories – Sistema ParaBank (Versão 1)

> **Formato**:  
> **Como** [papel do usuário]  
> **Quero** [funcionalidade que desejo]  
> **Para que** [benefício / valor que obtenho]  
>  
> **Critérios de Aceitação**  
> - ...

> **Notas de Design / Observações** (opcional)  

> **Estimativa** (Story Points ou tempo) – opcional para priorização.

---

### 1️⃣ Cadastro de Usuário

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑001 | **Como** usuário novo<br>**Quero** preencher um formulário de cadastro completo | - Todos os campos obrigatórios (nome, CPF, endereço, telefone, CEP, e‑mail, senha, confirmação de senha) devem ser preenchidos.<br>- Campos com formato inválido (telefone, CEP, e‑mail) acionam validação instantânea e exibem mensagem de erro clara.<br>- Ao submeter dados válidos, o sistema cria a conta, envia e‑mail de confirmação e habilita o login. | - As mensagens de erro devem estar localizadas (ex.: “O campo CEP deve conter 8 dígitos”).<br>- O e‑mail de confirmação deve conter link de validação. |
| US‑002 | **Como** usuário novo<br>**Quero** receber feedback de sucesso ao concluir o cadastro | - Após a criação bem‑sucedida, exibe banner “Cadastro concluído com sucesso! Faça login.”<br>- O usuário passa a poder usar as credenciais de login. | - Evitar redirecionamento automático para login; preferir mensagem clara na tela de cadastro. |

---

### 2️⃣ Login

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑003 | **Como** usuário cadastrado<br>**Quero** entrar no sistema usando credenciais válidas | - O sistema aceita CPF/username e senha.<br>- Se credenciais corretas: redireciona para a página inicial da conta (Dashboard).<br>- Se credenciais incorretas: exibe mensagem “CPF ou senha inválidos.” e mantém a tela de login. | - Adicionar opção “Esqueceu a senha?”. |
| US‑004 | **Como** usuário tentando se autenticar<br>**Quero** saber quando a autenticação falhou | - Mensagem de erro não revela se CPF ou senha está incorreto (evita informação sensível). | - Limitar tentativas a 5, exibindo mensagem “Tentativas excedidas. Aguarde 5 min.” |

---

### 3️⃣ Acesso à Conta – Saldo e Extrato

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑005 | **Como** cliente logado<br>**Quero** visualizar meu saldo atual | - Exibe valor atualizado na aba “Saldo”.<br>- Saldo reflete imediatamente após qualquer operação financeira (transferência, pagamento, empréstimo). | - Formatação monetária e moeda ISO. |
| US‑006 | **Como** cliente logado<br>**Quero** ver meu extrato em ordem cronológica | - Lista as últimas 10 transações na ordem mais recente primeiro.<br>- Cada entrada mostra data, descrição, tipo (depósito, transferência, pagamento), valor e saldo pós‑transação. | - Botão “Ver mais” para carregamento incremental. |

---

### 4️⃣ Transferência de Fundos

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑007 | **Como** cliente logado<br>**Quero** transferir dinheiro para outra conta | - Tela exige: conta de origem (pre‑selecionada), conta de destino (dropdown ou campo de digitação), valor, e botão “Confirmar”.<br>- Sistema bloqueia entrada de valor maior que saldo disponível, exibindo mensagem “Saldo insuficiente”. | - Confirmar saldo em tempo real. |
| US‑008 | **Como** cliente logado<br>**Quero** que a transferência seja registrada no histórico de ambas as contas | - Após confirmação, débito na conta de origem e crédito na conta de destino são processados.<br>- Ambas contas recebem registro na página de extrato (tipo “Transferência de [destino]”). | - Utilizar transação atômica para evitar inconsistências. |
| US‑009 | **Como** cliente logado<br>**Quero** saber que minha transferência foi concluída | - Exibe toast/alert “Transferência concluída com sucesso” e atualiza saldo instantaneamente. | - Registrar data/hora da operação. |

---

### 5️⃣ Solicitação de Empréstimo

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑010 | **Como** cliente logado<br>**Quero** solicitar empréstimo indicando valor e renda anual | - Formulário requer: valor desejado, renda anual, e botão “Enviar Solicitação”.<br>- O sistema avalia automaticamente e retorna status: “Aprovado” ou “Negado” em menos de 2 segundos. | - Em caso de “Negado”, exibir motivo resumido (“Renda insuficiente”). |
| US‑011 | **Como** cliente logado<br>**Quero** visualizar o resultado da solicitação | - Página de resultados exibe: valor solicitado, renda anual, status (Aprovado/Negado), e data de avaliação.<br>- Se aprovado, oferta de prazos e taxa de juros. | - Caso aprovado, permitir “Aceitar” e prosseguir para contrato. |

---

### 6️⃣ Pagamento de Contas

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑012 | **Como** cliente logado<br>**Quero** registrar pagamento de conta a futuro | - Formulário inclui: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento.<br>- Ao salvar, o pagamento entra na fila de pagamentos agendados e é exibido no histórico de transações no dia correto. | - Validação de data futura; impedir agendamentos em dias passados. |
| US‑013 | **Como** cliente logado<br>**Quero** ter certeza de que meu pagamento será processado na data marcada | - Sistema automatiza débito no dia agendado, creditando a conta de destino.<br>- Confirmação via e‑mail 24 h antes do pagamento. | - Exibir status “Agendado”, “Em andamento”, “Concluído”. |

---

### 7️⃣ Requisitos Gerais – Navegação & Usabilidade

| # | User Story | Critérios de Aceitação | Observações |
|---|------------|------------------------|-------------|
| US‑014 | **Como** usuário em qualquer página<br>**Quero** navegar sem erros | - Todas as rotas são responsivas (ex.: `/login`, `/dashboard`, `/transfer`, etc.).<br>- Erros 404 são redirecionados para página “Erro 404 – Página não encontrada”. | - Navegação deve ser consistente (header, footer, menu). |
| US‑015 | **Como** usuário que vê mensagem de erro<br>**Quero** entender o problema | - Mensagens de erro são claras, localizadas junto ao campo (ex.: “Telefone inválido”).<br>- Mensagem global “Ocorreu um erro inesperado. Tente novamente.” não aparece sem causa clara. | - Usar cores acessíveis (verde para sucesso, vermelho para erro). |
| US‑016 | **Como** usuário em qualquer página<br>**Quero** que menus e links sejam consistentes | - Todos os menus têm a mesma estrutura (Dashboard, Transferência, Empréstimo, Pagamentos, Logout).<br>- Links de ação (ex.: “Transferir”, “Solicitar Empréstimo”) mantêm localização padrão. | - Responsividade para dispositivos móveis. |

---

## Observações Finais

1. **Testabilidade** – Cada usuário story contém critérios de aceitação que podem ser convertidos em testes automatizados (unitários, de integração, UI).  
2. **Segurança** – O fluxo de dados sensíveis (senha, CPF, saldo) deve ser tratado com criptografia e HTTPS.  
3. **Acessibilidade** – Todos os elementos interativos devem ter rótulos ARIA e navegação via teclado.  
4. **Performance** – Operações críticas (login, transferência) devem responder em menos de 2 s.  

Com esses *User Stories* você tem uma base sólida para planejar, implementar e validar cada funcionalidade do ParaBank, garantindo aderência aos critérios de aceite descritos.