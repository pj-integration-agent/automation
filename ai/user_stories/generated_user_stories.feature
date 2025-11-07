**US01 – Cadastro de Usuário**  
Como **cliente** de um banco digital, eu quero **cadastros completos com validação dos campos obrigatórios** para que eu possa criar uma conta e acessar os serviços do ParaBank.

*Descrição detalhada*  
O fluxo de cadastro deve solicitar: nome completo, CPF, data de nascimento, telefone, CEP, email, endereço, cidade, estado, senha e confirmação de senha. Cada campo obrigatório deve ser validado no momento da digitação, exibindo mensagens de erro em tempo real quando o formato for inválido (ex.: telefone 000‑0000‑0000, CEP 00000‑000, email sem “@”). Após o envio bem‑sucedido, o usuário receberá uma mensagem de confirmação e a conta ficará habilitada para login.

*Critérios de aceite*  
- Todos os campos obrigatórios aparecem na tela de cadastro.  
- O sistema valida telefone, CEP e email no formato correto; exibe mensagem de erro clara caso o formato esteja incorreto.  
- Não é permitido submeter o cadastro se algum campo obrigatório estiver em branco ou inválido.  
- Após cadastro bem‑sucedido, o usuário recebe uma mensagem de “Cadastro concluído” e a conta fica marcada como “Ativa”.  
- A partir dessa situação, o usuário pode fazer login com as credenciais criadas.

---

**US02 – Login de Usuário**  
Como **cliente** autenticado, eu quero **acessar minha conta usando credenciais válidas** para que eu possa visualizar e gerenciar meus recursos bancários.

*Descrição detalhada*  
A tela de login aceita email/CPF e senha. O sistema verifica as credenciais; se válidas, redireciona o usuário para a página inicial da conta (dashboard). Se inválidas, exibe mensagem de erro (“Credenciais inválidas”). A sessão permanece ativa até que o usuário faça logout ou a sessão expire.

*Critérios de aceite*  
- O formulário de login contém campos para email/CPF e senha.  
- O sistema verifica as credenciais; credenciais corretas redirecionam para a página de dashboard.  
- Credenciais incorretas exibem a mensagem “Credenciais inválidas”.  
- Nenhum outro conteúdo da aplicação é acessível sem login.  

---

**US03 – Exibição de Saldo e Extrato**  
Como **cliente**, eu quero **ver meu saldo atualizado e o extrato de transações recentes** para acompanhar minhas finanças em tempo real.

*Descrição detalhada*  
A dashboard mostra o saldo atual após cada operação financeira. O extrato lista as transações (data, descrição, valor, tipo – crédito ou débito) em ordem cronológica decrescente (mais recente primeiro). O usuário pode expandir a lista para ver detalhes adicionais (referência, local, etc.) e pode filtrar por data ou tipo de transação.

*Critérios de aceite*  
- O saldo exibido na dashboard corresponde ao saldo contábil pós‑operações.  
- O extrato lista no mínimo as 10 transações mais recentes em ordem decrescente.  
- Cada entrada do extrato contém data, descrição e valor.  
- Ao expandir uma transação, são exibidos detalhes complementares (ex.: número de referência).  
- O usuário pode filtrar extrato por intervalo de datas e tipo de transação.  

---

**US04 – Transferência de Fundos**  
Como **cliente**, eu quero **transferir um valor entre contas dentro do ParaBank** para que eu possa movimentar recursos entre minhas contas ou enviar dinheiro para terceiros.

*Descrição detalhada*  
O usuário escolhe conta de origem, conta de destino e valor. O sistema bloqueia transferências que excedam o saldo disponível. Após confirmação, o valor é debitado da origem, creditado na destino e registrado no extrato de ambas as contas. A transferência deve ser atestada com confirmação de sucesso e um número de referência.

*Critérios de aceite*  
- O formulário de transferência exibe dropdowns das contas do usuário (origem e destino).  
- O campo de valor aceita apenas números positivos e até duas casas decimais.  
- Se o valor for maior que o saldo disponível, exibe “Saldo insuficiente” e impede a confirmação.  
- Após confirmação, o saldo da origem diminui e o saldo da destino aumenta exatamente pelo valor informado.  
- A transação aparece no extrato de ambas as contas com tipo “Transferência”.  
- Uma mensagem de “Transferência concluída” com número de referência é exibida.  

---

**US05 – Solicitação de Empréstimo**  
Como **cliente**, eu quero **solicitar um empréstimo informando valor e renda anual** para que eu possa avaliar a viabilidade de um crédito e receber decisão automática.

*Descrição detalhada*  
O usuário fornece o valor desejado e a renda anual. O sistema aplica regras de crédito simples (ex.: limite de valor proporcional à renda). Após o cálculo, o sistema retorna o status “Aprovado” ou “Negado” e exibe o motivo em caso de negativa. O resultado aparece na página de solicitação, e o cliente pode optar por “Cancelar” ou “Prosseguir” (se aprovado).

*Critérios de aceite*  
- O formulário de solicitação possui campos obrigatórios: valor do empréstimo e renda anual.  
- O sistema valida que ambos os campos são numéricos positivos.  
- O status da solicitação aparece imediatamente após o envio.  
- Se aprovado, exibe “Empréstimo aprovado” e os termos (valor, prazo, taxa).  
- Se negado, exibe “Empréstimo negado” com motivo (ex.: “Renda insuficiente”).  

---

**US06 – Pagamento de Contas**  
Como **cliente**, eu quero **registrar um pagamento de contas com beneficiário, endereço, telefone, conta de destino, valor e data** para que eu possa agendar e acompanhar pagamentos futuros.

*Descrição detalhada*  
O usuário insere: beneficiário (nome), endereço completo (logradouro, cidade, estado, CEP), telefone, conta bancária do beneficiário, valor do pagamento e data de pagamento. O pagamento pode ser instantâneo ou agendado para uma data futura. Após confirmação, a transação aparece no histórico e o valor é debitado na conta do usuário no dia do pagamento (ou no próximo dia útil, se o saldo for insuficiente, deve exibir alerta).

*Critérios de aceite*  
- Todos os campos obrigatórios são obrigatórios e validados (CEP, telefone, data).  
- O valor é debitado da conta do cliente no dia do pagamento agendado.  
- A transação aparece no extrato com tipo “Pagamento”.  
- Se o pagamento for agendado em data futura, o sistema exibe “Pagamento agendado para [data]”.  
- Se o saldo não for suficiente na data de pagamento, exibe “Saldo insuficiente” e não executa a transação.  

---

**US07 – Navegação e Usabilidade Consistentes**  
Como **cliente** que usa o ParaBank, eu quero **uma navegação consistente e mensagens de erro claras** para que eu possa usar a aplicação sem surpresas ou falhas.

*Descrição detalhada*  
Todos os menus, cabeçalhos e rodapés devem aparecer em todas as páginas, com links que funcionam. As mensagens de erro devem usar linguagem simples e indicar exatamente o campo que precisa ser corrigido. A aplicação deve carregar cada página em menos de 3 segundos (tempo de resposta aceitável para testes).

*Critérios de aceite*  
- Menus (Home, Conta, Transferência, Empréstimo, Pagamento, Logout) são visíveis e clicáveis em todas as páginas.  
- Links que não levam a outra página exibir “Não disponível” (evitando links quebrados).  
- Mensagens de erro aparecem abaixo do campo correspondente e são claras (“Telefone inválido – use (XX)XXXXX-XXXX”).  
- Tempo de carregamento de cada página ≤ 3 s em rede simulada.  

---

**US08 – Segurança de Dados Pessoais**  
Como **cliente**, eu quero **que meus dados pessoais sejam protegidos** para que eu não tenha que me preocupar com vazamentos ou acessos não autorizados.

*Descrição detalhada*  
Todas as senhas são armazenadas em hash seguro (ex.: bcrypt). Dados sensíveis (CPF, telefone, endereço) são criptografados em repouso e transmitidos apenas por HTTPS. O sistema exibe aviso de “Sessão expirada” após 15 minutos de inatividade. O logout elimina o token de sessão.

*Critérios de aceite*  
- Senhas são hashadas antes de serem salvas no banco de dados.  
- Todos os dados transmitidos entre cliente e servidor são via HTTPS (SSL/TLS).  
- Sessões expiram automaticamente após 15 minutos de inatividade.  
- O botão “Logout” destrói a sessão e redireciona para a página de login.  

---  

**Rastreabilidade**  
| ID | Módulo | Descrição |
|---|--------|-----------|
| US01 | Cadastro | Criação de conta com validação de campos. |
| US02 | Login | Autenticação segura e redirecionamento. |
| US03 | Saldo/Extrato | Visualização do saldo e histórico de transações. |
| US04 | Transferência | Movimento de fundos entre contas. |
| US05 | Empréstimo | Solicitação e aprovação automática de crédito. |
| US06 | Pagamento | Registro e agendamento de pagamentos. |
| US07 | Usabilidade | Navegação consistente e mensagens claras. |
| US08 | Segurança | Proteção de senhas e dados sensíveis. |

Estas User Stories cobrem integralmente os critérios de aceite do documento “ParaBank – Visão Geral”, mantendo clareza, testabilidade e ausência de sobreposição entre funcionalidades.