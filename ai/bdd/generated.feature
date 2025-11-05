## 1️⃣ Cadastro de Novo Usuário (Story #1)

```gherkin
Feature: Cadastro de usuário no ParaBank
  Como novo cliente
  Quero registrar minha conta
  Para que eu possa acessar os serviços bancários online

  @Cadastro
  Scenario Outline: Cadastro bem‑sucedido com dados válidos
    Given o usuário acessa a página de cadastro
    When preenche os campos obrigatórios com "<nome>", "<cpf>", "<dataNascimento>", "<email>", "<telefone>", "<endereco>", "<cep>", "<senha>", "<confSenha>"
    And clica no botão “Registrar”
    Then deve ser exibida a mensagem "Cadastro concluído com sucesso"
    And o usuário deve ser redirecionado para a tela de login

    Examples:
      | nome           | cpf          | dataNascimento | email              | telefone        | endereco           | cep     | senha     | confSenha |
      | João Silva     | 123.456.789-00 | 1985-02-15 | joao.silva@email.com | (11) 98765-4321 | Av. Paulista, 1000 | 01234-567 | senha123 | senha123 |

  @Cadastro
  Scenario Outline: Erro de campo obrigatório (campo vazio)
    Given o usuário acessa a página de cadastro
    When deixa o campo "<campo>" vazio e preenche os demais com dados válidos
    And clica no botão “Registrar”
    Then deve aparecer a mensagem de erro "<mensagem>" abaixo do campo "<campo>"

    Examples:
      | campo     | mensagem                          |
      | nome      | O nome é obrigatório              |
      | cpf       | O CPF é obrigatório               |
      | email     | O e‑mail é obrigatório            |
      | senha     | A senha é obrigatória             |
      | confSenha | A confirmação de senha é obrigatória |

  @Cadastro
  Scenario Outline: Email inválido
    Given o usuário acessa a página de cadastro
    When preenche todos os campos obrigatórios com "<emailInvalido>"
    And clica no botão “Registrar”
    Then deve aparecer a mensagem de erro "E‑mail inválido – inclua '@' e domínio válido"

    Examples:
      | emailInvalido         |
      | joaosilvaemail.com    |
      | joao.silva@.com      |

  @Cadastro
  Scenario Outline: Telefone fora do padrão
    Given o usuário acessa a página de cadastro
    When preenche todos os campos obrigatórios com "<telefoneInvalido>"
    And clica no botão “Registrar”
    Then deve aparecer a mensagem de erro "Telefone inválido – deve seguir o padrão (xx) xxxxx‑xxxx"

    Examples:
      | telefoneInvalido     |
      | 1234567890           |
      | (11) 1234-5678       |

  @Cadastro
  Scenario Outline: CEP inválido (não existente)
    Given o usuário acessa a página de cadastro
    When preenche todos os campos obrigatórios com "<cepInvalido>"
    And clica no botão “Registrar”
    Then deve aparecer a mensagem de erro "CEP inválido – deve ter 8 dígitos numéricos"

    Examples:
      | cepInvalido |
      | 1234-56     |
      | abcde-123   |

  @Cadastro
  Scenario Outline: Senha e confirmação diferentes
    Given o usuário acessa a página de cadastro
    When preenche todos os campos obrigatórios com "<senha>" e "<confSenha>"
    And clica no botão “Registrar”
    Then deve aparecer a mensagem de erro "Senhas não conferem – confirme novamente"

    Examples:
      | senha   | confSenha |
      | abc123  | abc124    |
      | senha!  | senha!@   |
```

---

## 2️⃣ Login de Usuário já Registrado (Story #2)

```gherkin
Feature: Login do usuário
  Como cliente já cadastrado
  Quero fazer login
  Para que eu possa acessar minha conta

  @Login
  Scenario: Login bem‑sucedido
    Given o usuário acessa a tela de login
    When insere "<email>" e "<senha>" válidos
    And clica em “Login”
    Then deve ser redirecionado para a página inicial (dashboard)

    Examples:
      | email                 | senha     |
      | joao.silva@email.com | senha123  |

  @Login
  Scenario: Credenciais inválidas (e‑mail/CPF ou senha incorretas)
    Given o usuário acessa a tela de login
    When insere "<credencial>" e "<senha>"
    And clica em “Login”
    Then deve aparecer a mensagem "Credenciais inválidas. Verifique seu e‑mail e senha."

    Examples:
      | credencial                | senha      |
      | joao.silva@email.com     | senhaErrada|
      | 123.456.789-00            | senhaErrada|
```

---

## 3️⃣ Visualizar Saldo e Extrato (Story #3)

```gherkin
Feature: Visualizar saldo e extrato
  Como cliente
  Quero ver saldo e extrato
  Para que eu acompanhe minha movimentação

  @Extrato
  Scenario: Saldo atual atualizado após transação
    Given o usuário está no dashboard com saldo "<saldoInicial>"
    When faz uma transferência de "<valorTransferencia>" para outra conta
    Then o saldo deve ser "<saldoAtual>"
    And a transferência deve aparecer no extrato com descrição "Transferência" e saldo após a transação

    Examples:
      | saldoInicial | valorTransferencia | saldoAtual |
      | 5000          | 1500               | 3500       |

  @Extrato
  Scenario Outline: Extrato lista transações em ordem cronológica
    Given o usuário tem as transações: <transacoes>
    When acessa a página de extrato
    Then o extrato exibe as transações em ordem decrescente de data

    Examples:
      | transacoes                                          |
      | "Compra: 30/10/2023, R$ 200, Saldo 4800"           |
      | "Transferência: 28/10/2023, R$ 1000, Saldo 5000"  |

  @Extrato
  Scenario: Extrato vazio (sem transações)
    Given o usuário tem saldo "<saldo>" e não realizou nenhuma transação
    When acessa a página de extrato
    Then deve ver a mensagem "Nenhuma transação encontrada" e a lista está vazia
```

---

## 4️⃣ Transferência de Fundos (Story #4)

```gherkin
Feature: Transferir fundos
  Como cliente
  Quero transferir dinheiro entre contas
  Para que possa movimentar meu dinheiro

  @Transferencia
  Scenario: Transferência bem‑sucedida entre duas contas
    Given o usuário tem saldo "<saldoOrigem>" na conta "<contaOrigem>"
    And a conta "<contaDestino>" existe
    When seleciona "<contaOrigem>" como origem, "<contaDestino>" como destino e transfere "<valor>"
    Then a origem deve ser debitada em "<valor>"
    And a destino deve ser creditada em "<valor>"
    And o histórico de ambas as contas mostra a transação
    And aparece a mensagem "Transferência realizada com sucesso"

    Examples:
      | saldoOrigem | contaOrigem | contaDestino | valor |
      | 3000        | Conta Poupança | Conta Corrente | 500  |

  @Transferencia
  Scenario: Valor maior que o saldo disponível bloqueia a transferência
    Given o usuário tem saldo "<saldoOrigem>" na conta "<contaOrigem>"
    When tenta transferir "<valorExcessivo>" para "<contaDestino>"
    Then o sistema bloqueia a operação
    And exibe a mensagem "Valor excede saldo disponível"

    Examples:
      | saldoOrigem | contaOrigem | contaDestino | valorExcessivo |
      | 2000        | Conta Corrente | Conta Poupança | 2500       |

  @Transferencia
  Scenario: Valor inválido (número negativo ou zero)
    Given o usuário seleciona as contas de origem e destino
    When tenta transferir "<valorInvalido>"
    Then o sistema exibe a mensagem "Valor inválido – deve ser maior que R$ 0,00"

    Examples:
      | valorInvalido |
      | -100          |
      | 0             |
```

---

## 5️⃣ Solicitação de Empréstimo (Story #5)

```gherkin
Feature: Solicitar empréstimo
  Como cliente
  Quero solicitar um empréstimo
  Para que obtenha crédito quando necessário

  @Emprestimo
  Scenario: Empréstimo aprovado
    Given o usuário informa "<valorSolicitado>" como valor do empréstimo
    And informa "<rendaAnual>" como renda anual
    When submete a solicitação
    Then o resultado deve ser “Aprovado”
    And exibe “Empréstimo aprovado: R$ <valorSolicitado>”

    Examples:
      | valorSolicitado | rendaAnual |
      | 10000           | 80000      |

  @Emprestimo
  Scenario: Empréstimo negado por renda insuficiente
    Given o usuário informa "<valorSolicitado>" e "<rendaAnual>" baixo
    When submete a solicitação
    Then o resultado deve ser “Negado”
    And exibe “Empréstimo negado: renda anual insuficiente”

    Examples:
      | valorSolicitado | rendaAnual |
      | 15000           | 20000      |
```

---

## 6️⃣ Pagamento de Contas (Story #6)

```gherkin
Feature: Pagar contas
  Como cliente
  Quero pagar contas
  Para manter meus pagamentos em dia

  @Pagamento
  Scenario: Pagamento imediato (data atual)
    Given o usuário preenche o formulário com beneficiário "<beneficiario>"
    And define a data de pagamento como hoje
    When confirma o pagamento
    Then a transação é registrada imediatamente no histórico
    And exibe a mensagem "Pagamento realizado com sucesso"

    Examples:
      | beneficiario   |
      | Luz Nova       |

  @Pagamento
  Scenario: Pagamento agendado para data futura
    Given o usuário preenche o formulário com beneficiário "<beneficiario>"
    And define a data de pagamento como "<dataFutura>"
    When confirma o pagamento
    Then o pagamento deve ser agendado
    And exibe "Pagamento agendado para <dataFutura>"

    Examples:
      | beneficiario   | dataFutura  |
      | Água Saneamento | 20/12/2025 |

  @Pagamento
  Scenario Outline: Campo obrigatório faltando
    Given o usuário preenche o formulário omitindo "<campo>"
    When tenta enviar
    Then deve aparecer a mensagem "O campo '<campo>' é obrigatório"

    Examples:
      | campo            |
      | beneficiário     |
      | telefone         |
      | valor            |
```

---

## 7️⃣ Desempenho de Navegação (Story #7)

```gherkin
Feature: Navegação sem erros
  Como cliente
  Quero que todas as páginas carreguem rapidamente
  Para que a experiência seja fluída

  @Navegacao
  Scenario Outline: Tempo de carregamento das rotas internas
    Given o usuário está na página "<pagina>"
    When a página carrega
    Then o tempo de carregamento deve ser ≤ 2 segundos

    Examples:
      | pagina     |
      | dashboard  |
      | extrato    |
      | transferir |
      | emprestimo |
      | pagamento  |

  @Navegacao
  Scenario: Links não quebrados
    Given o usuário clica em cada link do menu principal
    When a navegação ocorre
    Then ele deve chegar na página correta sem erro 404
```

---

## 8️⃣ Mensagens de Erro Claras (Story #8)

```gherkin
Feature: Mensagens de erro
  Como cliente
  Quero mensagens de erro claras
  Para que eu possa corrigir rapidamente

  @Erro
  Scenario Outline: Mensagens de erro específicas aparecem abaixo do campo
    Given o usuário deixa o campo "<campo>" inválido
    When tenta submeter o formulário
    Then aparece a mensagem "<mensagem>" embaixo do campo

    Examples:
      | campo     | mensagem                                               |
      | email     | E‑mail inválido – inclua '@' e domínio válido           |
      | cep       | CEP inválido – deve ter 8 dígitos numéricos             |
      | senha     | Senha mínima de 6 caracteres                            |

  @Erro
  Scenario: Mensagem não genérica
    Given o usuário tenta fazer login com e‑mail inválido
    When envia o formulário
    Then a mensagem exibida não deve conter apenas “Erro”
    And deve indicar o erro exato: “E‑mail inválido”
```

---

## 9️⃣ Consistência de Menus (Story #9)

```gherkin
Feature: Consistência do menu
  Como cliente
  Quero menus e links consistentes em todas as páginas
  Para que não me perca na navegação

  @Menu
  Scenario Outline: Menu principal presente em todas as páginas
    Given o usuário navega para "<pagina>"
    Then o menu principal deve conter os links: Home, Saldo, Transferir, Empréstimo, Contas, Logout

    Examples:
      | pagina     |
      | dashboard  |
      | extrato    |
      | transferir |
      | emprestimo |

  @Menu
  Scenario: Link “Logout” funciona corretamente
    Given o usuário clica em “Logout”
    When a navegação ocorre
    Then ele deve retornar à página de login e a sessão deve ser encerrada
```

---

## 🔟 Validação de QA (Story #10)

```gherkin
Feature: Validação de requisitos pelo QA
  Como QA
  Quero validar que todos os critérios de aceitação foram implementados
  Para que o sistema esteja pronto para produção

  @QA
  Scenario: Cobertura de testes
    Given existe um repositório de testes automatizados
    When os testes são executados
    Then a cobertura de código deve ser 100% para os requisitos listados nas histórias
    And o relatório de testes deve indicar “Pass” para cada AC

  @QA
  Scenario: Relatório de status
    Given o relatório de testes está disponível
    When o QA consulta
    Then cada requisito deve ter um status “Pass” ou “Fail”
```

---

> **Resumo:**  
> - Cada **Story** possui **cenários positivos** (o fluxo normal) e **cenários negativos** (casos de erro).  
> - Os cenários cobrem todos os **Acceptance Criteria** listados.  
> - Os testes são escritos em **Gherkin** (Português) e incluem **exemplos** para variações de dados.  
> - Os cenários podem ser usados diretamente em ferramentas BDD como **Cucumber**, **SpecFlow** ou **Behave**.