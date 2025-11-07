## User Stories – Sistema ParaBank  
*(Todas as histórias estão escritas em português, seguindo o padrão INVEST – Independente, Negociável, Valorizável, Estimável, Pequeno, Testável.)*

| # | Papel | Como | Quero | Para que | Critérios de Aceitação | Prioridade |
|---|-------|------|-------|----------|------------------------|------------|
| **1** | Usuário cadastrado | Como **usuário** que nunca usou o ParaBank, | eu quero poder criar uma conta | para acessar os serviços bancários online | • Todos os campos obrigatórios (nome, CPF, email, telefone, CEP, senha, confirm‑senha) são preenchidos.<br>• Campos inválidos (telefone com formato errado, CEP fora do padrão, email sem “@”) acionam mensagem de erro clara.<br>• Após cadastro bem‑sucedido, o sistema exibe “Cadastro concluído” e redireciona para a página de login. | Alta |
| **2** | Usuário cadastrado | Como **usuário** já registrado, | eu quero fazer login usando email e senha | para acessar minha conta e serviços bancários | • Senha válida e email existentes permitem login.<br>• Credenciais inválidas mostram mensagem “Usuário ou senha inválidos”.<br>• Login bem‑sucedido redireciona para a **Dashboard** (página inicial da conta). | Alta |
| **3** | Usuário logado | Como **usuário** logado, | eu quero ver meu saldo atual | para saber quanto dinheiro tenho disponível | • Saldo aparece imediatamente após login.<br>• Saldo atualiza automaticamente após qualquer operação (transferência, pagamento, empréstimo). | Alta |
| **4** | Usuário logado | Como **usuário** logado, | eu quero visualizar o extrato de transações | para acompanhar histórico e validar movimentações | • Lista as transações recentes em ordem cronológica.<br>• Cada entrada mostra data, descrição, débito/crédito e saldo após a operação.<br>• Página carrega sem erros de navegação. | Média |
| **5** | Usuário logado | Como **usuário** que possui várias contas, | eu quero transferir fundos entre minhas contas | para movimentar recursos conforme necessidade | • Seleção de conta origem e destino, campo de valor.<br>• Sistema bloqueia transferências cujo valor excede o saldo da conta origem.<br>• Confirmação da transferência debita origem e credita destino.<br>• Registro de transação aparece no extrato das duas contas. | Alta |
| **6** | Usuário logado | Como **usuário** interessado em crédito, | eu quero solicitar um empréstimo | para obter recursos adicionais | • Entrada de valor do empréstimo e renda anual.<br>• Sistema processa e devolve status “Aprovado” ou “Negado”.<br>• Resultado é exibido de forma clara, sem erros de navegação. | Média |
| **7** | Usuário logado | Como **usuário** que tem contas a pagar, | eu quero registrar pagamentos de contas | para manter histórico e agendar futuros pagamentos | • Cadastro requer beneficiário, endereço, cidade, estado, CEP, telefone, conta destino, valor e data de pagamento.<br>• Pagamento confirmado adiciona transação ao histórico.<br>• Pagamentos futuros respeitam data de agendamento e não são processados antes da data indicada.<br>• Mensagens de erro claras se campos obrigatórios não forem preenchidos. | Média |
| **8** | Usuário | Como **qualquer usuário** (cadastrado ou não), | eu quero que todas as páginas carreguem sem erros de navegação | para garantir experiência de uso fluída | • Navegação entre menus, links e botões funciona em todas as páginas.<br>• Mensagens de erro aparecem de forma objetiva e contextual.<br>• Menus e links permanecem consistentes (ex.: “Minha Conta”, “Transferir”, “Empréstimos”, “Pagamentos”). | Alta |
| **9** | Usuário | Como **qualquer usuário**, | eu quero que o sistema forneça feedback imediato em cada ação | para saber se a operação foi bem‑sucedida ou falhou | • Mensagens de sucesso e erro são exibidas em modais ou banners visíveis.<br>• Cada mensagem descreve claramente o problema ou a confirmação (ex.: “Transferência concluída” ou “Saldo insuficiente”). | Alta |

---

### Exemplos de Histórias Refinadas (para backlog)

```gherkin
Feature: Cadastro de Usuário
  Como usuário que nunca utilizou o ParaBank
  Quero criar uma conta
  Para acessar os serviços bancários online

  Scenario: Cadastro completo e válido
    Given eu acesso a página de cadastro
    When preencho todos os campos obrigatórios com dados válidos
    And clico em "Registrar"
    Then devo ver mensagem "Cadastro concluído"
    And devo ser redirecionado para a página de login

  Scenario: Cadastro com campo inválido
    Given eu acesso a página de cadastro
    When preencho o campo CEP com "ABCDE"
    And clico em "Registrar"
    Then devo ver mensagem de erro "CEP inválido"
    And a página não deve submeter o cadastro
```

```gherkin
Feature: Transferência de Fundos
  Como usuário que possui múltiplas contas
  Quero transferir fundos entre elas
  Para movimentar recursos conforme minha necessidade

  Scenario: Transferência válida
    Given estou na tela de Transferência
    When escolho conta origem "Conta A"
    And escolho conta destino "Conta B"
    And insiro valor "200"
    And clico em "Confirmar"
    Then o valor deve ser debitado de Conta A
    And o valor deve ser creditado em Conta B
    And a transação deve aparecer no extrato de ambas as contas

  Scenario: Transferência com saldo insuficiente
    Given estou na tela de Transferência
    When escolho conta origem "Conta A" com saldo "100"
    And escolho conta destino "Conta B"
    And insiro valor "150"
    And clico em "Confirmar"
    Then devo ver mensagem "Saldo insuficiente"
    And nenhuma conta deve ser alterada
```

---

> **Obs.:**  
> - Todas as histórias podem ser quebradas em tarefas menores (ex.: criação da API de cadastro, UI, testes unitários, testes de aceitação) conforme necessário.  
> - O backlog pode ser priorizado conforme as necessidades do negócio; as histórias listadas acima já trazem a prioridade sugerida.  
> - Os critérios de aceitação são diretamente extraídos do documento fornecido e garantem cobertura completa das Features do ParaBank.