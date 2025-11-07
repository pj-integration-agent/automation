**titulo: US01 – Cadastro de Usuário**  
**cenario_bdd:**  
  - nome: Cadastro com dados válidos  
    tipo: positivo  
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro com dados válidos\n  Given o usuário acessa a página de cadastro\n  When preenche todos os campos obrigatórios com dados válidos\n  And clica em 'Cadastrar'\n  Then exibe mensagem 'Cadastro concluído com sucesso'\n  And permite login com as credenciais criadas"  

  - nome: Cadastro com campo obrigatório em branco  
    tipo: negativo  
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro com campo obrigatório em branco\n  Given o usuário acessa a página de cadastro\n  When preenche todos os campos obrigatórios exceto 'CEP'\n  And clica em 'Cadastrar'\n  Then exibe mensagem de erro 'Este campo é obrigatório.' ao lado do campo 'CEP'"  

  - nome: Cadastro com e‑mail inválido  
    tipo: negativo  
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro com e‑mail inválido\n  Given o usuário acessa a página de cadastro\n  When preenche todos os campos obrigatórios com e‑mail 'usuario.com'\n  And clica em 'Cadastrar'\n  Then exibe mensagem de erro 'Formato de e‑mail inválido.' ao lado do campo 'Email'"  

  - nome: Cadastro com telefone no formato incorreto  
    tipo: negativo  
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro com telefone no formato incorreto\n  Given o usuário acessa a página de cadastro\n  When preenche todos os campos obrigatórios com telefone '123456789'\n  And clica em 'Cadastrar'\n  Then exibe mensagem de erro 'Formato de telefone inválido. Use (99) 99999-9999.' ao lado do campo 'Telefone'"  

  - nome: Cadastro com CEP inexistente  
    tipo: negativo  
    gherkin: "Feature: Cadastro de Usuário\nScenario: Cadastro com CEP inexistente\n  Given o usuário acessa a página de cadastro\n  When preenche todos os campos obrigatórios com CEP '00000-000'\n  And clica em 'Cadastrar'\n  Then exibe mensagem de erro 'CEP não encontrado.' ao lado do campo 'CEP'"

---

**titulo: US02 – Login de Usuário**  
**cenario_bdd:**  
  - nome: Login com credenciais corretas  
    tipo: positivo  
    gherkin: "Feature: Login de Usuário\nScenario: Login com credenciais corretas\n  Given o usuário está na página de login\n  When insere e‑mail e senha corretos\n  And clica em 'Entrar'\n  Then redireciona para a Dashboard\n  And exibe saldo atual"  

  - nome: Login com credenciais inválidas  
    tipo: negativo  
    gherkin: "Feature: Login de Usuário\nScenario: Login com credenciais inválidas\n  Given o usuário está na página de login\n  When insere e‑mail 'usuario@exemplo.com' e senha 'senhaErrada'\n  And clica em 'Entrar'\n  Then exibe mensagem 'Credenciais inválidas. Verifique e tente novamente.'"  

  - nome: Botão 'Entrar' só habilitado quando ambos os campos preenchidos  
    tipo: negativo  
    gherkin: "Feature: Login de Usuário\nScenario: Botão 'Entrar' habilitado apenas com ambos campos preenchidos\n  Given o usuário está na página de login\n  When deixa o campo 'Senha' em branco\n  Then o botão 'Entrar' permanece desativado\n  When preenche a senha\n  Then o botão 'Entrar' fica habilitado"

---

**titulo: US03 – Visualização do Saldo**  
**cenario_bdd:**  
  - nome: Exibição inicial do saldo na Dashboard  
    tipo: positivo  
    gherkin: "Feature: Visualização do Saldo\nScenario: Exibição inicial do saldo na Dashboard\n  Given o usuário está autenticado e na Dashboard\n  Then exibe saldo no formato monetário 'R$ 3.245,67' que corresponde ao saldo armazenado"  

  - nome: Atualização do saldo após transferência  
    tipo: positivo  
    gherkin: "Feature: Visualização do Saldo\nScenario: Atualização do saldo após transferência\n  Given o usuário está na Dashboard com saldo 'R$ 5.000,00'\n  When realiza transferência de 'R$ 500,00' para conta '1234-5'\n  Then saldo atual na origem diminui para 'R$ 4.500,00'\n  And saldo na conta destino aumenta em 'R$ 500,00'"

---

**titulo: US04 – Acesso ao Extrato**  
**cenario_bdd:**  
  - nome: Exibição das 10 transações mais recentes  
    tipo: positivo  
    gherkin: "Feature: Acesso ao Extrato\nScenario: Exibição das 10 transações mais recentes\n  Given o usuário está na página de Extrato\n  Then exibe pelo menos 10 transações ordenadas por data decrescente"  

  - nome: Detalhes de transação ao clicar em 'Mais detalhes'  
    tipo: positivo  
    gherkin: "Feature: Acesso ao Extrato\nScenario: Exibir detalhes completos de uma transação\n  Given o usuário vê uma lista de transações\n  When clica em 'Mais detalhes' na linha da transação 'Transferência para João Silva'\n  Then exibe histórico completo incluindo data, descrição, valor e saldo final"

---

**titulo: US05 – Transferência de Fundos**  
**cenario_bdd:**  
  - nome: Transferência dentro do saldo disponível  
    tipo: positivo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência dentro do saldo disponível\n  Given o usuário está na tela de Transferência\n  And possui saldo de 'R$ 1.000,00'\n  When escolhe conta de origem própria, conta destino '9876-0', valor 'R$ 200,00'\n  And confirma a transferência\n  Then origem é debitada em 'R$ 200,00' e destino creditado em 'R$ 200,00'\n  And transação aparece no extrato de ambas as contas"  

  - nome: Transferência com valor superior ao saldo  
    tipo: negativo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência com valor superior ao saldo\n  Given o usuário está na tela de Transferência\n  And possui saldo de 'R$ 150,00'\n  When tenta transferir 'R$ 200,00'\n  Then exibe mensagem 'Saldo insuficiente' e cancela a transferência"  

  - nome: Transferência para conta inexistente  
    tipo: negativo  
    gherkin: "Feature: Transferência de Fundos\nScenario: Transferência para conta inexistente\n  Given o usuário está na tela de Transferência\n  When preenche número de conta destino '0000-0' que não existe\n  Then exibe mensagem 'Conta destino não encontrada'"

---

**titulo: US06 – Solicitação de Empréstimo**  
**cenario_bdd:**  
  - nome: Empréstimo aprovado e creditado imediatamente  
    tipo: positivo  
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo aprovado e creditado\n  Given o usuário está na tela de Empréstimo\n  When preenche valor 'R$ 50.000,00' e renda anual 'R$ 120.000,00'\n  And submete a solicitação\n  Then exibe mensagem 'Empréstimo aprovado'\n  And crédito 'R$ 50.000,00' é adicionado ao saldo imediatamente"  

  - nome: Empréstimo negado por renda insuficiente  
    tipo: negativo  
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo negado por renda insuficiente\n  Given o usuário está na tela de Empréstimo\n  When preenche valor 'R$ 30.000,00' e renda anual 'R$ 20.000,00'\n  And submete a solicitação\n  Then exibe mensagem 'Empréstimo negado: Renda insuficiente'"  

  - nome: Empréstimo negado por valor exceder limite  
    tipo: negativo  
    gherkin: "Feature: Empréstimo\nScenario: Empréstimo negado por valor exceder limite\n  Given o usuário está na tela de Empréstimo\n  When preenche valor 'R$ 150.000,00'\n  And renda anual 'R$ 200.000,00'\n  And submete a solicitação\n  Then exibe mensagem 'Empréstimo negado: Valor excede limite máximo'"  

---

**titulo: US07 – Pagamento de Contas**  
**cenario_bdd:**  
  - nome: Pagamento imediato de conta  
    tipo: positivo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento imediato de conta\n  Given o usuário está na tela de Pagamento\n  And possui saldo suficiente\n  When preenche beneficiário, endereço, telefone, conta destino e valor 'R$ 300,00'\n  And agenda data de pagamento 'hoje'\n  And confirma o pagamento\n  Then exibe confirmação\n  And transação aparece no extrato na data de hoje\n  And saldo é debitado imediatamente"  

  - nome: Pagamento agendado futuro  
    tipo: positivo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento agendado futuro\n  Given o usuário está na tela de Pagamento\n  And possui saldo suficiente\n  When preenche beneficiário, endereço, telefone, conta destino e valor 'R$ 300,00'\n  And agenda data de pagamento '31/12/2025'\n  And confirma o pagamento\n  Then exibe confirmação\n  And transação aparece no extrato com status 'Agendado'\n  And saldo não é alterado até a data programada"  

  - nome: Pagamento com campo obrigatório em branco  
    tipo: negativo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento com campo obrigatório em branco\n  Given o usuário está na tela de Pagamento\n  When preenche todos os campos exceto 'Telefone'\n  And agenda data de pagamento 'hoje'\n  Then exibe mensagem 'Este campo é obrigatório.' ao lado de 'Telefone'"  

  - nome: Pagamento imediato com saldo insuficiente  
    tipo: negativo  
    gherkin: "Feature: Pagamento de Contas\nScenario: Pagamento imediato com saldo insuficiente\n  Given o usuário está na tela de Pagamento\n  And possui saldo 'R$ 200,00'\n  When tenta pagar 'R$ 300,00'\n  Then exibe mensagem 'Saldo insuficiente para este pagamento'"

---

**titulo: US08 – Navegação Consistente**  
**cenario_bdd:**  
  - nome: Navegação sem erros em desktop  
    tipo: positivo  
    gherkin: "Feature: Navegação Consistente\nScenario: Navegação sem erros em desktop\n  Given o usuário abre o ParaBank em um navegador desktop\n  When navega por todos os menus (Conta, Transferir, Empréstimo, Pagamentos, Extrato)\n  Then todas as rotas carregam sem erros 404 ou 500"  

  - nome: Navegação sem erros em dispositivos móveis  
    tipo: positivo  
    gherkin: "Feature: Navegação Consistente\nScenario: Navegação sem erros em dispositivos móveis\n  Given o usuário abre o ParaBank em um dispositivo de largura mínima 320 px\n  When navega pelos mesmos menus\n  Then todas as rotas carregam sem erros 404 ou 500"  

  - nome: Rota inexistente retorna erro 404  
    tipo: negativo  
    gherkin: "Feature: Navegação Consistente\nScenario: Rota inexistente retorna erro 404\n  Given o usuário tenta acessar a rota '/contas/123456'\n  Then recebe página de erro 404"

---

**titulo: US09 – Mensagens de Erro Claras**  
**cenario_bdd:**  
  - nome: Mensagem de erro para telefone inválido  
    tipo: negativo  
    gherkin: "Feature: Mensagens de Erro\nScenario: Erro de telefone inválido\n  Given o usuário preenche telefone com '123456'\n  Then exibe mensagem de erro 'Formato de telefone inválido. Use (99) 99999-9999.'"  

  - nome: Mensagem de erro para campo obrigatório ausente  
    tipo: negativo  
    gherkin: "Feature: Mensagens de Erro\nScenario: Erro de campo obrigatório ausente\n  Given o usuário deixa campo 'CEP' em branco\n  Then exibe mensagem 'Este campo é obrigatório.'"  

  - nome: Mensagem de erro para login inválido  
    tipo: negativo  
    gherkin: "Feature: Mensagens de Erro\nScenario: Erro de login inválido\n  Given o usuário digita credenciais inválidas\n  When clica em 'Entrar'\n  Then exibe mensagem 'Credenciais inválidas.'"  

  - nome: Mensagem de erro para saldo insuficiente em transferência  
    tipo: negativo  
    gherkin: "Feature: Mensagens de Erro\nScenario: Erro de saldo insuficiente em transferência\n  Given o usuário tenta transferir um valor maior que o saldo disponível\n  Then exibe mensagem 'Saldo insuficiente para esta transferência.'"  

---