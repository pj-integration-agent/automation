**User Stories – ParaBank (Version 1.0)**  

*(Todos os usuários referidos abaixo são **Clientes** – pessoas físicas que utilizam o portal online ParaBank.)*

---

## US01 – Cadastro de Usuário  
**Como** cliente, **eu quero** criar uma conta no ParaBank preenchendo todos os campos obrigatórios, **para** poder acessar os serviços bancários online.  

**Descrição**  
O fluxo de cadastro deve solicitar os dados pessoais (nome, CPF, data de nascimento, e‑mail, telefone, CEP, endereço completo, senha) e validar cada campo em tempo real. Ao enviar o formulário, o sistema verifica a integridade dos dados, garante que a senha tenha pelo menos 8 caracteres, o e‑mail seja válido, o telefone e o CEP estejam no formato brasileiro e que o CPF não seja duplicado. Se algum campo estiver incorreto ou faltante, uma mensagem de erro específica é exibida ao lado do campo correspondente.  

**Critérios de Aceite**  
- [x] Todos os campos obrigatórios são marcados com um asterisco * e não podem ser deixados em branco.  
- [x] O e‑mail segue o padrão `usuario@dominio.com`.  
- [x] O telefone segue o padrão `(99) 99999‑9999`.  
- [x] O CEP segue o padrão `99999‑999`.  
- [x] O CPF não pode ser duplicado; se já existir, exibe mensagem “CPF já cadastrado”.  
- [x] Mensagens de erro são exibidas imediatamente abaixo do campo afetado.  
- [x] Após cadastro bem‑sucedido, o usuário recebe e‑mail de confirmação e é redirecionado para a tela de login.  
- [x] O usuário não pode logar antes de concluir o cadastro.  

---

## US02 – Login  
**Como** cliente, **eu quero** entrar no ParaBank usando minhas credenciais, **para** acessar minha conta bancária e realizar operações.  

**Descrição**  
A tela de login contém os campos *E‑mail* e *Senha*. O usuário insere suas credenciais e clica em “Entrar”. O sistema verifica a validade das credenciais contra a base de usuários. Se estiverem corretas, o usuário é redirecionado para a página principal com o resumo da conta. Caso contrário, uma mensagem de erro genérica (“Credenciais inválidas”) é mostrada.  

**Critérios de Aceite**  
- [x] E‑mail e senha são obrigatórios.  
- [x] Mensagem “Credenciais inválidas” é exibida quando as credenciais não correspondem.  
- [x] Usuário com credenciais válidas é redirecionado para a página de “Conta” (saldo, extrato).  
- [x] O sistema bloqueia login após 5 tentativas consecutivas falhadas, exibindo “Conta bloqueada, contate o suporte”.  
- [x] O botão “Entrar” fica desabilitado enquanto a requisição está em andamento (feedback visual).  

---

## US03 – Exibir Saldo e Extrato  
**Como** cliente, **eu quero** ver o saldo atual da minha conta e o extrato de transações recentes, **para** monitorar meus recursos e verificar histórico de movimentações.  

**Descrição**  
Ao acessar a página inicial da conta, o sistema mostra o saldo atual em moeda local. Abaixo, aparece a lista das 10 últimas transações, ordenadas cronologicamente (mais recente primeiro). Cada linha exibe data, descrição, tipo (crédito/débito), valor e saldo pós‑transação.  

**Critérios de Aceite**  
- [x] Saldo exibido em reais, com duas casas decimais, atualizado após qualquer operação.  
- [x] Extrato lista as 10 transações mais recentes, em ordem decrescente de data.  
- [x] Cada linha do extrato contém: data (DD/MM/AAAA), descrição (ex.: “Transferência de Conta A”), tipo (Crédito/Débito), valor e saldo final.  
- [x] Se não houver transações, exibe mensagem “Nenhuma transação encontrada”.  

---

## US04 – Transferência de Fundos  
**Como** cliente, **eu quero** transferir dinheiro entre contas (minha própria ou de terceiros), **para** movimentar recursos de forma rápida e segura.  

**Descrição**  
A tela de transferência permite selecionar:  
1. Conta de origem (lista das contas do usuário).  
2. Conta de destino (pode ser sua própria conta ou outra conta do banco, indicada pelo número da conta).  
3. Valor da transferência.  

O sistema bloqueia a transferência se o valor for superior ao saldo disponível na conta de origem. Após confirmação, debita a origem, credita o destino e registra a transação nos extratos de ambas as contas.  

**Critérios de Aceite**  
- [x] Campos “Conta de Origem”, “Conta de Destino” e “Valor” são obrigatórios.  
- [x] O valor deve ser positivo e em reais com duas casas decimais.  
- [x] Se o valor > saldo da origem, exibe mensagem “Saldo insuficiente”.  
- [x] Ao confirmar, debita a origem, credita o destino e grava a transação em ambos os extratos.  
- [x] Exibe confirmação: “Transferência concluída. Valor transferido: R$ XXXX.XX”.  
- [x] Se a conta de destino não existir, exibe “Conta de destino não encontrada”.  

---

## US05 – Solicitação de Empréstimo  
**Como** cliente, **eu quero** solicitar um empréstimo informando valor e renda anual, **para** obter financiamento de acordo com minhas necessidades.  

**Descrição**  
O cliente insere:  
- Valor do empréstimo desejado (R$).  
- Renda anual (R$).  

O sistema calcula automaticamente o índice de risco e devolve o status: *Aprovado* ou *Negado*. O resultado aparece em destaque na tela, com explicação resumida (ex.: “Empréstimo aprovado com taxa de juros de 8% ao ano”).  

**Critérios de Aceite**  
- [x] Campos “Valor do Empréstimo” e “Renda Anual” são obrigatórios.  
- [x] Valor mínimo de empréstimo: R$ 1.000; valor máximo: R$ 100.000.  
- [x] Se a renda anual não atender ao critério interno (ex.: renda < 1.5 × valor), o status é “Negado”.  
- [x] Resultados são exibidos em mensagem clara, com código de status (Aprovado / Negado) e, se aprovado, a taxa de juros.  
- [x] Em caso de “Negado”, sugere “Revisar renda anual ou reduzir valor do empréstimo”.  

---

## US06 – Pagamento de Contas  
**Como** cliente, **eu quero** cadastrar e agendar pagamentos de contas (ex.: água, luz, internet), **para** garantir que sejam liquidados na data correta sem precisar lembrar manualmente.  

**Descrição**  
A tela de pagamento aceita:  
- Beneficiário (nome).  
- Endereço completo (rua, número, complemento).  
- Cidade, estado e CEP.  
- Telefone do beneficiário.  
- Conta de destino (número da conta onde o valor será debitado).  
- Valor da fatura.  
- Data de vencimento (ou data de agendamento).  

O sistema valida cada campo, garante que a data não seja anterior à atual e que o valor não exceda o saldo disponível. Depois de confirmado, o pagamento é registrado no extrato com status “Agendado”. Na data agendada, a operação ocorre automaticamente, debitando a conta de origem.  

**Critérios de Aceite**  
- [x] Todos os campos são obrigatórios, exceto complemento de endereço.  
- [x] CEP segue padrão `99999‑999`; telefone segue `(99) 99999‑9999`.  
- [x] Data de vencimento não pode ser anterior à data atual.  
- [x] Valor não pode superar o saldo da conta de origem.  
- [x] Após confirmação, exibe mensagem “Pagamento agendado para DD/MM/AAAA”.  
- [x] Pagamento futuro é incluído no extrato com status “Agendado” até ser liquidado.  
- [x] Se a data agendada chegar e o saldo for insuficiente, exibe “Pagamento não processado – saldo insuficiente”.  

---

## US07 – Requisitos Gerais de Navegação e Usabilidade  
**Como** cliente, **eu quero** que todas as páginas carreguem sem erros, que os menus sejam consistentes e que as mensagens de erro sejam claras, **para** ter uma experiência de uso agradável e confiável.  

**Descrição**  
O sistema deve garantir:  
- Carregamento de cada página em no máximo 2 segundos.  
- Menus (home, extrato, transferências, empréstimos, pagamentos) presentes e com links corretos em todas as páginas.  
- Navegação “Back” do navegador continua funcional.  
- Mensagens de erro são específicas, localizadas ao lado do campo afetado (ou no topo da página, quando global).  
- Estilo visual consistente (cores, fontes, espaçamento).  

**Critérios de Aceite**  
- [x] Todas as rotas são acessíveis sem erro 404 ou 500.  
- [x] Tempo de carregamento da página inicial ≤ 2 s em conexão padrão (3G).  
- [x] Todos os links no menu redirecionam para as páginas corretas.  
- [x] Mensagens de erro aparecem em vermelho, com ícone de alerta, e são removidas automaticamente após 5 s ou quando o usuário corrige o campo.  
- [x] Layout segue o mockup aprovado (cores #0066CC, #FFFFFF, tipografia Roboto).  
- [x] Responsividade: telas em dispositivos móveis (iOS/Android) exibem menus em barra de navegação inferior.  

---

### Rastreabilidade
- **US01** – Registro de Usuário  
- **US02** – Login  
- **US03** – Exibir Saldo e Extrato  
- **US04** – Transferência de Fundos  
- **US05** – Solicitação de Empréstimo  
- **US06** – Pagamento de Contas  
- **US07** – Requisitos Gerais de Navegação e Usabilidade  

Estas User Stories cobrem todas as funcionalidades descritas nos critérios de aceite do documento ParaBank 1. Elas são claras, não sobrepostas, testáveis e alinhadas com os objetivos de negócio de oferecer serviços bancários simples e confiáveis ao cliente.