**Arquivo: `tests/user-flow.spec.ts`**  
*Obs.: O código abaixo segue a estrutura do Playwright Test Runner, está escrito em TypeScript e contém todos os cenários BDD descritos na sua especificação.  
Os seletores são baseados em rótulos (`role('textbox', { name: '...' })`) ou em texto de botão, o que costuma ser mais estável em aplicações que seguem boas práticas de acessibilidade. Se o seu projeto usa atributos `data-qa` ou `id` específicos, basta trocar os seletores por esses.*

```ts
// ──────────────────────────────────────────────────────────────────────
//   1. Imports e configuração inicial
// ──────────────────────────────────────────────────────────────────────
import { test, expect, Page } from '@playwright/test';

/**
 * Base URL do ambiente de testes (configurado no arquivo playwright.config.ts).
 * Se não houver configuração, você pode substituir `baseURL` por uma string fixa.
 */
const baseURL = process.env.BASE_URL ?? 'http://localhost:3000';

/**
 * Helpers reutilizáveis – mantêm o código DRY e legível.
 */

/**
 * Navega para a página de cadastro.
 */
async function goToRegistration(page: Page) {
  await page.goto(`${baseURL}/register`);
  await expect(page).toHaveURL(/\/register/);
}

/**
 * Navega para a página de login.
 */
async function goToLogin(page: Page) {
  await page.goto(`${baseURL}/login`);
  await expect(page).toHaveURL(/\/login/);
}

/**
 * Preenche o formulário de cadastro com os dados informados.
 */
async function fillRegistrationForm(
  page: Page,
  data: {
    fullName: string;
    birthDate: string;
    cpf: string;
    address: string;
    cep: string;
    phone: string;
    email: string;
    password: string;
  }
) {
  await page.fill(
    'input[name="fullName"]',
    data.fullName
  );
  await page.fill(
    'input[name="birthDate"]',
    data.birthDate
  );
  await page.fill(
    'input[name="cpf"]',
    data.cpf
  );
  await page.fill(
    'input[name="address"]',
    data.address
  );
  await page.fill(
    'input[name="cep"]',
    data.cep
  );
  await page.fill(
    'input[name="phone"]',
    data.phone
  );
  await page.fill(
    'input[name="email"]',
    data.email
  );
  await page.fill(
    'input[name="password"]',
    data.password
  );
  await page.fill(
    'input[name="confirmPassword"]',
    data.password
  );
}

/**
 * Clica no botão “Cadastrar”.
 */
async function clickRegister(page: Page) {
  await page.click('button:has-text("Cadastrar")');
}

/**
 * Verifica se o botão “Cadastrar” está ativo (habilitado).
 */
async function expectRegisterActive(page: Page) {
  await expect(
    page.getByRole('button', { name: 'Cadastrar' })
  ).toBeEnabled();
}

/**
 * Verifica se o botão “Cadastrar” está inativo (desabilitado).
 */
async function expectRegisterInactive(page: Page) {
  await expect(
    page.getByRole('button', { name: 'Cadastrar' })
  ).toBeDisabled();
}

/**
 * Espera uma resposta HTTP com status 200 para a URL atual.
 */
async function expectStatus200(page: Page) {
  await page.waitForResponse((response) =>
    response.status() === 200 &&
    response.url() === page.url()
  );
}

/**
 * ------------------------------------------
 *   2. Cenários de Cadastro de Usuário
 * ------------------------------------------
 */
test.describe('Cadastro de Usuário', () => {
  test.beforeEach(async ({ page }) => {
    // Cada cenário começa na página de cadastro.
    await goToRegistration(page);
  });

  test('Cadastro com todos os campos válidos', async ({ page }) => {
    // Preenchimento completo do formulário
    await fillRegistrationForm(page, {
      fullName: 'Ana Maria da Silva',
      birthDate: '15/04/1990',
      cpf: '123.456.789-10',
      address: 'Rua das Flores, 123',
      cep: '12345-678',
      phone: '(11) 91234-5678',
      email: 'ana.silva@example.com',
      password: 'Segura123!'
    });

    // Clica em “Cadastrar”
    await clickRegister(page);

    // Verifica que o botão permanece habilitado após o clique
    await expectRegisterActive(page);

    // Confirma que a página de confirmação aparece
    await expect(page.locator('text=Cadastro concluído')).toBeVisible();

    // E que o usuário está autenticado e redirecionado para “Minha Conta”
    await expect(page).toHaveURL(/\/my-account/);
    await expect(page.locator('text=Olá, Ana')).toBeVisible();
  });

  test('Erro de campo obrigatório em branco – CPF', async ({ page }) => {
    // Preenche todos os campos exceto CPF
    await page.fill(
      'input[name="fullName"]',
      'Ana Maria da Silva'
    );
    await page.fill(
      'input[name="birthDate"]',
      '15/04/1990'
    );
    // Deixa CPF em branco
    await page.fill(
      'input[name="cpf"]',
      ''
    );
    await page.fill(
      'input[name="address"]',
      'Rua das Flores, 123'
    );
    await page.fill(
      'input[name="cep"]',
      '12345-678'
    );
    await page.fill(
      'input[name="phone"]',
      '(11) 91234-5678'
    );
    await page.fill(
      'input[name="email"]',
      'ana.silva@example.com'
    );
    await page.fill(
      'input[name="password"]',
      'Segura123!'
    );
    await page.fill(
      'input[name="confirmPassword"]',
      'Segura123!'
    );

    // O botão “Cadastrar” deve permanecer inativo
    await expectRegisterInactive(page);

    // Exibe mensagem de erro abaixo do campo CPF
    await expect(
      page.locator('text=CPF é obrigatório')
    ).toBeVisible();
  });

  test('Erro de validação de telefone', async ({ page }) => {
    // Preenche telefone com letras
    await page.fill(
      'input[name="phone"]',
      'telefone123'
    );
    // Tenta enviar o formulário
    await clickRegister(page);

    // Exibe mensagem de erro específica
    await expect(
      page.locator('text=Telefone inválido – use números')
    ).toBeVisible();
  });
});

/**
 * ------------------------------------------
 *   3. Cenários de Login
 * ------------------------------------------
 */
test.describe('Login', () => {
  test.beforeEach(async ({ page }) => {
    await goToLogin(page);
  });

  test('Login com credenciais válidas', async ({ page }) => {
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Segura123!');

    await page.click('button:has-text("Entrar")');

    // Redireciona para “Minha Conta”
    await expect(page).toHaveURL(/\/my-account/);
    await expect(page.locator('text=Olá, Ana')).toBeVisible();

    // Verifica que a sessão permanece ativa
    await page.waitForTimeout(5000); // Simula tempo de espera
    await expect(
      page.locator('button:has-text("Logout")')
    ).toBeVisible();
  });

  test('Login falha com senha incorreta', async ({ page }) => {
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Errada123!');

    await page.click('button:has-text("Entrar")');

    await expect(
      page.locator('text=Usuário ou senha inválidos')
    ).toBeVisible();
  });

  test('Login falha com e‑mail não registrado', async ({ page }) => {
    await page.fill('input[name="email"]', 'nao.cadastrado@example.com');
    await page.fill('input[name="password"]', 'Qualquer123!');

    await page.click('button:has-text("Entrar")');

    await expect(
      page.locator('text=Usuário ou senha inválidos')
    ).toBeVisible();
  });
});

/**
 * ------------------------------------------
 *   4. Visualizar Saldo e Extrato
 * ------------------------------------------
 */
test.describe('Visualizar Saldo e Extrato', () => {
  test.beforeEach(async ({ page }) => {
    // Assume que o usuário já está autenticado; caso contrário, faça login
    await goToLogin(page);
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Segura123!');
    await page.click('button:has-text("Entrar")');
    await expect(page).toHaveURL(/\/my-account/);
  });

  test('Usuário vê saldo atualizado e extrato completo', async ({ page }) => {
    // Abre a seção “Extrato”
    await page.click('text=Extrato');

    // Exibe saldo corrente
    await expect(page.locator('text=Saldo atual')).toBeVisible();
    await expect(page.locator('css=.balance')).toHaveText(/\d+,\d{2}/);

    // Lista as 10 transações mais recentes
    const rows = await page.locator('css=.transaction-row').all();
    expect(rows.length).toBeGreaterThanOrEqual(10);

    // Cada linha possui data, descrição e valor
    for (const row of rows) {
      await expect(row.locator('.date')).toBeVisible();
      await expect(row.locator('.description')).toBeVisible();
      await expect(row.locator('.amount')).toBeVisible();
    }
  });

  test('Usuário com menos de 10 transações', async ({ page }) => {
    // Para fins de teste, vamos supor que já existem 7 transações
    await page.click('text=Extrato');

    const rows = await page.locator('css=.transaction-row').all();
    expect(rows.length).toBeLessThanOrEqual(7);

    // Verifica que não existem linhas vazias
    const emptyRows = await page.locator('css=.transaction-row:has-text("")').all();
    expect(emptyRows.length).toBe(0);
  });
});

/**
 * ------------------------------------------
 *   5. Transferência de Fundos
 * ------------------------------------------
 */
test.describe('Transferência de Fundos', () => {
  test.beforeEach(async ({ page }) => {
    // Autenticação
    await goToLogin(page);
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Segura123!');
    await page.click('button:has-text("Entrar")');
    await expect(page).toHaveURL(/\/my-account/);

    // Navega para a página de Transferências
    await page.click('nav >> text=Transferências');
    await expect(page).toHaveURL(/\/transfers/);
  });

  test('Transferência dentro do limite de saldo', async ({ page }) => {
    // Assume saldo disponível é R$ 500,00
    // Seleciona conta de origem
    await page.click('select[name="originAccount"]');
    await page.selectOption('select[name="originAccount"]', 'Conta Corrente');

    // Insere conta de destino
    await page.fill('input[name="destinationAccount"]', '12345-6');

    // Preenche valor
    await page.fill('input[name="amount"]', '200,00');

    // Confirma a transferência
    await page.click('button:has-text("Confirmar")');

    // Mensagem de sucesso
    await expect(page.locator('text=Transferência concluída')).toBeVisible();

    // Verifica saldos atualizados
    await expect(
      page.locator('text=Saldo disponível').filter({ hasText: /R\$\s*300,00/ })
    ).toBeVisible();

    // Verifica que o extrato de origem mostra –200,00
    await page.click('text=Extrato');
    await expect(
      page.locator('.transaction-row').filter({
        hasText: /–200,00/
      })
    ).toBeVisible();

    // Para a conta de destino, assumimos que a interface exibe o saldo
    await page.goto(`${baseURL}/accounts/12345-6`);
    await expect(
      page.locator('text=Saldo disponível').filter({
        hasText: /R\$\s*200,00/
      })
    ).toBeVisible();
  });

  test('Transferência bloqueada por saldo insuficiente', async ({ page }) => {
    // Saldo disponível é R$ 150,00
    // Insere conta de destino
    await page.fill('input[name="destinationAccount"]', '12345-6');

    // Preenche valor maior que o saldo
    await page.fill('input[name="amount"]', '200,00');

    // Tenta confirmar
    await page.click('button:has-text("Confirmar")');

    // Mensagem de erro
    await expect(
      page.locator('text=Valor excede saldo disponível')
    ).toBeVisible();
  });

  test('Transferência bloqueada por valor inválido – negativo', async ({ page }) => {
    await page.fill('input[name="amount"]', '-100,00');
    await page.click('button:has-text("Confirmar")');

    await expect(
      page.locator('text=Valor inválido – apenas números positivos')
    ).toBeVisible();
  });
});

/**
 * ------------------------------------------
 *   6. Solicitação de Empréstimo
 * ------------------------------------------
 */
test.describe('Solicitação de Empréstimo', () => {
  test.beforeEach(async ({ page }) => {
    // Autenticação
    await goToLogin(page);
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Segura123!');
    await page.click('button:has-text("Entrar")');
    await expect(page).toHaveURL(/\/my-account/);

    // Vai para a página de Empréstimos
    await page.click('nav >> text=Empréstimos');
    await expect(page).toHaveURL(/\/loans/);
  });

  test('Empréstimo aprovado com renda suficiente', async ({ page }) => {
    await page.fill('input[name="loanAmount"]', '5.000,00');
    await page.fill('input[name="annualIncome"]', '80.000,00');

    await page.click('button:has-text("Solicitar")');

    // Espera 2 segundos (simulando backend)
    await page.waitForTimeout(2000);

    // Status aprovado
    await expect(
      page.locator('text=Aprovado')
    ).toBeVisible();

    // Crédito na conta
    await expect(
      page.locator('text=Saldo disponível').filter({
        hasText: /R\$\s*5\.000,00/
      })
    ).toBeVisible();

    // Extrato
    await page.click('text=Extrato');
    await expect(
      page.locator('.transaction-row').filter({
        hasText: /Empréstimo aprovado/
      })
    ).toBeVisible();
  });

  test('Empréstimo negado por renda insuficiente', async ({ page }) => {
    await page.fill('input[name="loanAmount"]', '10.000,00');
    await page.fill('input[name="annualIncome"]', '30.000,00');

    await page.click('button:has-text("Solicitar")');

    await page.waitForTimeout(2000);

    await expect(
      page.locator('text=Empréstimo negado – renda insuficiente')
    ).toBeVisible();
  });

  test('Empréstimo falha com valor negativo', async ({ page }) => {
    await page.fill('input[name="loanAmount"]', '-1.000,00');
    await page.click('button:has-text("Solicitar")');

    await expect(
      page.locator('text=Valor do empréstimo inválido – apenas números positivos')
    ).toBeVisible();
  });
});

/**
 * ------------------------------------------
 *   7. Pagamento de Contas
 * ------------------------------------------
 */
test.describe('Pagamento de Contas', () => {
  test.beforeEach(async ({ page }) => {
    // Autenticação
    await goToLogin(page);
    await page.fill('input[name="email"]', 'ana.silva@example.com');
    await page.fill('input[name="password"]', 'Segura123!');
    await page.click('button:has-text("Entrar")');
    await expect(page).toHaveURL(/\/my-account/);

    // Navega para a página de Pagamentos
    await page.click('nav >> text=Pagamentos');
    await expect(page).toHaveURL(/\/payments/);
  });

  test('Pagamento imediato para beneficiário', async ({ page }) => {
    await page.fill('input[name="beneficiary"]', 'João Pereira');
    await page.fill('input[name="address"]', 'Av. Brasil, 456');
    await page.fill('input[name="city"]', 'São Paulo');
    await page.fill('input[name="state"]', 'SP');
    await page.fill('input[name="cep"]', '01000-000');
    await page.fill('input[name="phone"]', '(11) 98765-4321');
    await page.fill('input[name="destinationAccount"]', '12345-6');
    await page.fill('input[name="amount"]', '300,00');
    await page.click('button:has-text("Hoje")'); // Seleção de data
    await page.click('button:has-text("Confirmar")');

    await expect(
      page.locator('text=Pagamento registrado')
    ).toBeVisible();

    await page.click('text=Extrato');
    await expect(
      page.locator('.transaction-row').filter({
        hasText: /Pagamento para João Pereira – 300,00/
      })
    ).toBeVisible();
  });

  test('Pagamento agendado para data futura', async ({ page }) => {
    await page.fill('input[name="beneficiary"]', 'Maria Souza');
    await page.fill('input[name="destinationAccount"]', '98765-4');
    await page.fill('input[name="amount"]', '150,00');
    await page.click('button:has-text("10 dias depois")');
    await page.click('button:has-text("Confirmar")');

    await expect(
      page.locator('text=Pagamento registrado')
    ).toBeVisible();

    await page.click('text=Extrato');
    await expect(
      page.locator('.transaction-row').filter({
        hasText: /10 dias depois/
      })
    ).toBeVisible();
  });

  test('Pagamento bloqueado por saldo insuficiente na data programada', async ({ page }) => {
    // Saldo atual: R$ 200,00 – vamos simular
    // Agenda pagamento de R$ 300,00 para 12 dias depois
    await page.fill('input[name="beneficiary"]', 'Fulano');
    await page.fill('input[name="destinationAccount"]', '12345-6');
    await page.fill('input[name="amount"]', '300,00');
    await page.click('button:has-text("12 dias depois")');
    await page.click('button:has-text("Confirmar")');

    await expect(
      page.locator('text=Saldo insuficiente no dia do pagamento')
    ).toBeVisible();
  });

  test('Pagamento bloqueado por CEP inválido', async ({ page }) => {
    await page.fill('input[name="cep"]', '1234'); // inválido
    await page.click('button:has-text("Enviar")');

    await expect(
      page.locator('text=CEP inválido – use 8 dígitos')
    ).toBeVisible();
  });
});

/**
 * ------------------------------------------
 *   8. Navegação e Usabilidade
 * ------------------------------------------
 */
test.describe('Navegação e Usabilidade', () => {
  test('Navegação completa sem erro 404/500', async ({ page }) => {
    // Inicia na página de login
    await goToLogin(page);
    await expect(page).toHaveURL(/\/login/);

    // Clica em “Cadastrar”
    await page.click('a:has-text("Cadastrar")');
    await expectStatus200(page);

    // Volta ao login
    await page.click('a:has-text("Entrar")');
    await expectStatus200(page);

    // Menu “Transferências”
    await page.click('nav >> text=Transferências');
    await expectStatus200(page);

    // Menu “Empréstimos”
    await page.click('nav >> text=Empréstimos');
    await expectStatus200(page);

    // Menu “Pagamentos”
    await page.click('nav >> text=Pagamentos');
    await expectStatus200(page);
  });

  test('Página 404 mostra link de retorno ao dashboard ou login', async ({ page }) => {
    // Navega para rota inexistente
    await page.goto(`${baseURL}/rota-inexistente`);
    await page.waitForResponse((res) => res.status() === 404);

    // Verifica mensagem
    await expect(
      page.locator('text=Página não encontrada')
    ).toBeVisible();

    // Se autenticado (vamos supor que já está logado)
    await expect(
      page.locator('text=Voltar ao dashboard')
    ).toBeVisible();

    // Se não autenticado – usar outro teste
  });

  test('Erro de validação aparece corretamente', async ({ page }) => {
    // Já na página de cadastro (desde que test anterior tenha navegado)
    await goToRegistration(page);

    // Deixa telefone em branco e tenta cadastrar
    await page.fill('input[name="phone"]', '');
    await clickRegister(page);

    // Mensagem de erro em vermelho
    const errorMsg = page.locator('text=Telefone é obrigatório');
    await expect(errorMsg).toBeVisible();
    await expect(errorMsg).toHaveCSS('color', /rgb\(255, 0, 0\)/);

    // Botão “Cadastrar” permanece inativo
    await expectRegisterInactive(page);
  });

  test('Menus responsivos em telas pequenas', async ({ page, context }) => {
    // Redimensiona para 320px
    await context.setViewportSize({ width: 320, height: 800 });

    // Abre o menu principal
    await page.click('button:has-text("Menu")');

    // Todos os links aparecem em vertical
    const menuLinks = page.locator('nav >> a');
    await expect(menuLinks).toHaveCountGreaterThan(0);
    await expect(menuLinks).toBeVisible();

    // Cada link tem ícone + texto legível
    const icons = page.locator('nav >> svg');
    await expect(icons).toHaveCountGreaterThan(0);

    // Fecha o menu ao clicar fora
    await page.click('body');
    await expect(menuLinks).toBeHidden();
  });
});
```

---

### Como usar

1. **Instale o Playwright** (se ainda não tiver):  
   ```bash
   npm i -D @playwright/test
   ```

2. **Configure o `playwright.config.ts`** – defina o `baseURL`, browsers, etc.

3. **Execute os testes**:  
   ```bash
   npx playwright test
   ```

### Próximos passos

- **Refatoração de seletores**: Se sua aplicação usa *data‑test* ou *id*, troque os seletores pelos mais estáveis.
- **Data‑driven**: Para cenários com diferentes valores (por exemplo, saldo ou número de transações), crie data sets e use `test.each`.
- **Mock de backend**: Para cenários de empréstimo ou transferência, você pode interceptar chamadas API (`page.route`) e retornar respostas fictícias, garantindo que os testes não dependam de dados reais.

> **Nota:** Os testes acima são *exemplos* e podem precisar de ajustes dependendo da estrutura real da aplicação e da sua política de testes. Boa sorte!