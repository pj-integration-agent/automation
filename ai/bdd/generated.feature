## 📁 Estrutura de Features – ParaBank

> Cada feature corresponde a uma *User Story* e contém **cenários** que refletem os *Acceptance Criteria* fornecidos.  
> Os cenários estão escritos em **português** (keywords: `Funcionalidade`, `Cenário`, `Dado`, `Quando`, `Então`) para que possam ser diretamente utilizados em frameworks como Cucumber, SpecFlow, Behave, etc.

---

### 1️⃣ Cadastro de Usuário

```gherkin
# arquivo: cadastro_usuario.feature
# encoding: utf-8
# language: pt

Funcionalidade: Cadastro de Usuário

  Cenario: Registro com dados inválidos
    Dado que eu estou na tela de cadastro
    Quando eu preencher os campos obrigatórios com valores inválidos (telefone, CEP, e‑mail)
    E eu tentar salvar
    Então o sistema exibe a mensagem “Telefone inválido”
    E o sistema exibe a mensagem “CEP inválido”
    E o sistema exibe a mensagem “E‑mail inválido”

  Cenario: Registro com dados válidos
    Dado que eu estou na tela de cadastro
    Quando eu preencher todos os campos obrigatórios com valores válidos (nome, CPF, telefone, CEP, e‑mail, senha)
    E eu tentar salvar
    Então o cadastro é criado
    E aparece a mensagem “Cadastro concluído com sucesso”
    E eu consigo fazer login com as credenciais fornecidas
```

---

### 2️⃣ Login

```gherkin
# arquivo: login.feature
# encoding: utf-8
# language: pt

Funcionalidade: Login

  Cenario: Login com credenciais válidas
    Dado que a página de login está aberta
    Quando eu informar credenciais válidas (e‑mail e senha)
    Então o sistema autentica e redireciona para a página inicial da conta

  Cenario: Login com credenciais inválidas
    Dado que a página de login está aberta
    Quando eu informar credenciais inválidas
    Então o sistema exibe a mensagem “Credenciais inválidas”
```

---

### 3️⃣ Acesso à Conta – Saldo e Extrato

```gherkin
# arquivo: acesso_conta.feature
# encoding: utf-8
# language: pt

Funcionalidade: Acesso à Conta – Saldo e Extrato

  Background:  
    Dado que eu já estou autenticado e na página inicial da minha conta

  Cenario: Visualizar saldo atualizado
    Quando o sistema carregar a página
    Então o saldo exibido corresponde ao saldo real da conta

  Cenario: Visualizar extrato em ordem cronológica
    Quando eu acessar a seção de extrato
    Então o extrato lista todas as transações recentes em ordem cronológica, com a mais recente no topo
```

---

### 4️⃣ Transferência de Fundos

```gherkin
# arquivo: transferencia.feature
# encoding: utf-8
# language: pt

Funcionalidade: Transferência de Fundos

  Background:  
    Dado que eu já estou autenticado e na página de transferência

  Cenario: Tentativa de transferência com valor superior ao saldo
    Quando eu selecionar a conta de origem, a conta de destino e digitar um valor maior que o saldo disponível
    E eu tentar confirmar a transferência
    Então o sistema exibe a mensagem “Saldo insuficiente”
    E a transferência não é processada

  Cenario: Transferência válida
    Quando eu selecionar a conta de origem, a conta de destino e digitar um valor menor ou igual ao saldo
    E eu confirmar a transferência
    Então o valor é debitado da conta origem
    E o valor é creditado na conta destino
    E a transferência é registrada no histórico de ambas as contas
```

---

### 5️⃣ Solicitação de Empréstimo

```gherkin
# arquivo: solicitacao_emprestimo.feature
# encoding: utf-8
# language: pt

Funcionalidade: Solicitação de Empréstimo

  Background:  
    Dado que eu já estou autenticado e na página de solicitação de empréstimo

  Cenario: Empréstimo aprovado
    Quando eu informar o valor do empréstimo e minha renda anual
    Então o sistema retorna o status “Aprovado”
    E exibe a mensagem “Empréstimo aprovado”

  Cenario: Empréstimo negado
    Quando eu informar o valor do empréstimo e minha renda anual
    Então o sistema retorna o status “Negado”
    E exibe a mensagem “Empréstimo negado”
```

---

### 6️⃣ Pagamento de Contas

```gherkin
# arquivo: pagamento_contas.feature
# encoding: utf-8
# language: pt

Funcionalidade: Pagamento de Contas

  Background:  
    Dado que eu já estou autenticado e na página de pagamento de contas

  Cenario: Registro de pagamento agendado
    Quando eu preencher: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino, valor e data de pagamento
    E eu confirmar o pagamento
    Então o sistema valida os dados e exibe mensagens de erro se houver inconsistência
    E o pagamento aparece no histórico de transações
    E o pagamento será processado na data agendada

  Cenario: Registro de pagamento imediato
    Quando eu preencher: beneficiário, endereço, cidade, estado, CEP, telefone, conta de destino e valor
    E eu deixo a data de pagamento em aberto
    E eu confirmar o pagamento
    Então o pagamento é processado imediatamente
    E o pagamento aparece no histórico de transações
```

---

### 7️⃣ Navegação e Usabilidade

```gherkin
# arquivo: navegacao_usuabilidade.feature
# encoding: utf-8
# language: pt

Funcionalidade: Navegação e Usabilidade

  Cenario: Carregamento de página sem erros
    Dado que eu acesso qualquer página do ParaBank
    Quando o sistema carregar a página
    Então a página é exibida sem erros de carregamento nem redirecionamentos inesperados

  Cenario: Navegação por links ou menus
    Quando eu interajo com um link ou item de menu
    Então a página correta é exibida
    E a navegação é consistente em todas as páginas

  Cenario: Mensagens de erro claras
    Quando eu soufor informado de um erro de validação (por ex.: “Telefone inválido”)
    Então a mensagem de erro é exibida perto do campo responsável
    E a mensagem é clara, objetiva e de fácil entendimento
```

---

## 🎯 Observações Finais

| Item | Descrição |
|------|-----------|
| **Idiomas** | Gherkin em português (`Funcionalidade`, `Cenário`, `Dado`, `Quando`, `Então`). |
| **Separação** | Cada story em um arquivo `.feature` próprio. |
| **Background** | Utilizado quando há pré‑requisitos comuns (ex.: usuário autenticado). |
| **Dados de teste** | Você pode usar *Examples* ou *Data Tables* se quiser parametrizar cenários, mas os exemplos acima já cobrem os casos de aceitação. |
| **Integração** | Esses arquivos podem ser vinculados a passos de implementação em C#, Java, Python, etc., usando os frameworks BDD de sua escolha. |

Pronto! Agora você tem um conjunto completo de cenários Gherkin que representam as User Stories do ParaBank. Basta importá‑los no seu pipeline de testes e começar a validar a aplicação continuamente. 🚀