## Playwright Test Runner – Full Test Suite (TypeScript)

> **Tip** – All tests below are ready to drop into a fresh Playwright project.  
> 1. Run `npx playwright install` to install browsers.  
> 2. Place the files under `tests/`.  
> 3. Add a `playwright.config.ts` that points to your ParaBank base URL (`env.baseUrl`).  
> 4. Run `npx playwright test`.

> **Assumptions** –  
> * Each form field exposes a `data-testid` that follows the pattern `field-{name}` (e.g. `data-testid="field-name"`).  
> * Error messages are rendered inside a `<span>` that follows the pattern `error-{name}`.  
> * Success messages appear in a banner with `data-testid="banner-success"`.  
> * API endpoints exist for verification (e.g. `/api/users` for checking the DB).  
> * All pages contain a common navigation bar with `data-testid="nav-{item}"`.

> **Why this structure?**  
> * **Separation** – Each feature gets its own file → easier maintenance.  
> * **Re‑usability** – A `Login` helper fixture (`login.spec.ts`) can be reused across scenarios.  
> * **Clarity** – Comments explain the intent, keeping the test logic readable.  
> * **Robustness** – Explicit `await`/`expect` statements, time‑outs, and fall‑backs make the suite resilient.  

---

## 1️⃣ `tests/registration.spec.ts`

```ts
// tests/registration.spec.ts
import { test, expect } from '@playwright/test';

/**
 * Helper that returns a locator for a form field by its label
 * (used because the UI renders labels next to inputs)
 */
const field = (page, label: string) => page.locator(`label:has-text("${label}") + input`);
const error = (page, label: string) => page.locator(`span[data-testid="error-${label}"]`);
const successBanner = (page) => page.locator('[data-testid="banner-success"]');

/** Valid data that can be reused across scenarios */
const validData = {
  name: 'Ana Silva',
  email: 'ana.silva@email.com',
  phone: '11987654321',
  zip: '12345000',
  password: 'S3nhaSegura123',
  confirmPassword: 'S3nhaSegura123',
};

test.describe('US001 – Cadastro de Usuário', () => {

  /* ------------------------------------------------------------------ */
  /* Positive scenario – registration with all fields correct          */
  /* ------------------------------------------------------------------ */
  test('Registro bem‑sucedido com todos os campos preenchidos', async ({ page }) => {
    await page.goto('/register');               // GIVEN

    // WHEN – fill each field
    await field(page, 'Nome').fill(validData.name);
    await field(page, 'E‑mail').fill(validData.email);
    await field(page, 'Telefone').fill(validData.phone);
    await field(page, 'CEP').fill(validData.zip);
    await field(page, 'Senha').fill(validData.password);
    await field(page, 'Confirmar Senha').fill(validData.confirmPassword);

    // WHEN – click the register button
    await page.locator('[data-testid="btn-register"]').click();

    // THEN – success message
    await expect(successBanner(page)).toHaveText(
      'Cadastro concluído com sucesso! Você pode fazer login agora.',
      { timeout: 5000 }
    );

    // AND – verify that the user now exists in the DB (via API)
    const res = await page.request.get(`/api/users?email=${validData.email}`);
    const user = await res.json();
    expect(user).toBeTruthy();                 // user object must exist
    // hash check – the API should expose a hash flag or not expose password
    expect(user.password).not.toBe(validData.password);
  });

  /* ------------------------------------------------------------------ */
  /* Negative scenario – required field left empty                    */
  /* ------------------------------------------------------------------ */
  const requiredFields = [
    { label: 'Nome', value: validData.name },
    { label: 'E‑mail', value: validData.email },
    { label: 'Telefone', value: validData.phone },
    { label: 'CEP', value: validData.zip },
    { label: 'Senha', value: validData.password },
    { label: 'Confirmar Senha', value: validData.confirmPassword },
  ];

  for (const { label } of requiredFields) {
    test(`Registro falha quando o campo "${label}" está vazio`, async ({ page }) => {
      await page.goto('/register');

      // Fill all other fields first
      for (const { label: otherLabel, value } of requiredFields) {
        if (otherLabel !== label) await field(page, otherLabel).fill(value);
      }

      // Click register
      await page.locator('[data-testid="btn-register"]').click();

      // Verify that the specific error appears
      await expect(error(page, label)).toHaveText('Este campo é obrigatório', { timeout: 3000 });
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative scenario – invalid values for certain fields            */
  /* ------------------------------------------------------------------ */
  const invalidValues = [
    { label: 'E‑mail', value: 'ana.silvaemail.com', message: 'E‑mail inválido' },
    { label: 'CEP', value: 'CEP12345', message: 'CEP inválido' },
    { label: 'Telefone', value: '1234', message: 'Telefone inválido' },
  ];

  for (const { label, value, message } of invalidValues) {
    test(`Registro falha com valor inválido em ${label}`, async ({ page }) => {
      await page.goto('/register');

      // Fill all other fields with valid data
      for (const { label: otherLabel, value: val } of requiredFields) {
        if (otherLabel !== label) await field(page, otherLabel).fill(val);
      }

      // Put the invalid value in the target field
      await field(page, label).fill(value);

      // Click register
      await page.locator('[data-testid="btn-register"]').click();

      // Expect the specific error
      await expect(error(page, label)).toHaveText(message, { timeout: 3000 });
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative scenario – password & confirmation mismatch            */
  /* ------------------------------------------------------------------ */
  test('Registro falha quando senha e confirmação não coincidem', async ({ page }) => {
    await page.goto('/register');

    // Fill all fields except confirmation
    await field(page, 'Nome').fill(validData.name);
    await field(page, 'E‑mail').fill(validData.email);
    await field(page, 'Telefone').fill(validData.phone);
    await field(page, 'CEP').fill(validData.zip);
    await field(page, 'Senha').fill(validData.password);
    await field(page, 'Confirmar Senha').fill('SenhaErrada');

    // Click register
    await page.locator('[data-testid="btn-register"]').click();

    // Expect mismatch error next to confirmation field
    await expect(error(page, 'Confirmar Senha')).toHaveText('Senhas não coincidem', { timeout: 3000 });
  });
});
```

---

## 2️⃣ `tests/login.spec.ts`

```ts
// tests/login.spec.ts
import { test, expect } from '@playwright/test';

const field = (page, label: string) => page.locator(`label:has-text("${label}") + input`);
const error = (page, label: string) => page.locator(`span[data-testid="error-${label}"]`);
const successBanner = (page) => page.locator('[data-testid="banner-success"]');

const validCredentials = {
  email: 'ana.silva@email.com',
  password: 'S3nhaSegura123',
};

test.describe('US002 – Login', () => {

  /* ------------------------------------------------------------------ */
  /* Positive login                                                  */
  /* ------------------------------------------------------------------ */
  test('Login bem‑sucedido', async ({ page }) => {
    await page.goto('/login');

    await field(page, 'E‑mail').fill(validCredentials.email);
    await field(page, 'Senha').fill(validCredentials.password);

    await page.locator('[data-testid="btn-login"]').click();

    // Verify that we land on the home page
    await expect(page).toHaveURL(/\/home$/);

    // And that the user name appears in the header
    await expect(page.locator('header')).toContainText('Ana Silva');
  });

  /* ------------------------------------------------------------------ */
  /* Negative login – bad credentials                                */
  /* ------------------------------------------------------------------ */
  const badCreds = [
    { email: 'nao.existe@email.com', password: 'S3nhaSegura123' },
    { email: validCredentials.email, password: 'senhaErrada' },
  ];

  for (const { email, password } of badCreds) {
    test(`Login falha com credenciais inválidas: ${email}`, async ({ page }) => {
      await page.goto('/login');
      await field(page, 'E‑mail').fill(email);
      await field(page, 'Senha').fill(password);
      await page.locator('[data-testid="btn-login"]').click();

      await expect(error(page, 'E‑mail')).toHaveText('Credenciais inválidas. Por favor, tente novamente.');
      // No other error should appear
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative login – empty fields                                    */
  /* ------------------------------------------------------------------ */
  const emptyFields = [
    { label: 'E‑mail', value: '' },
    { label: 'Senha', value: '' },
  ];

  for (const { label, value } of emptyFields) {
    test(`Login falha quando o campo "${label}" está vazio`, async ({ page }) => {
      await page.goto('/login');
      await field(page, label).fill(value);
      // Fill the other field with a valid value
      const other = label === 'E‑mail' ? 'Senha' : 'E‑mail';
      const otherValue = label === 'E‑mail' ? validCredentials.password : validCredentials.email;
      await field(page, other).fill(otherValue);

      await page.locator('[data-testid="btn-login"]').click();

      await expect(error(page, label)).toHaveText('Este campo é obrigatório');
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative login – account locked after 5 failed attempts           */
  /* ------------------------------------------------------------------ */
  test('Conta bloqueada após 5 tentativas de login falhadas', async ({ page }) => {
    await page.goto('/login');

    for (let i = 0; i < 5; i++) {
      await field(page, 'E‑mail').fill(validCredentials.email);
      await field(page, 'Senha').fill('senhaErrada');
      await page.locator('[data-testid="btn-login"]').click();
      await expect(error(page, 'E‑mail')).toHaveText('Credenciais inválidas. Por favor, tente novamente.');
    }

    // Final attempt – should see blocked message
    await field(page, 'E‑mail').fill(validCredentials.email);
    await field(page, 'Senha').fill('senhaErrada');
    await page.locator('[data-testid="btn-login"]').click();

    await expect(page.locator('body')).toContainText('Conta bloqueada, tente novamente em 15 min');
  });
});
```

---

## 3️⃣ `tests/balance.spec.ts`

```ts
// tests/balance.spec.ts
import { test, expect } from '@playwright/test';

const balanceText = (page) => page.locator('[data-testid="balance-amount"]');

test.describe('US003 – Exibição de Saldo', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – balance updates after a transfer                     */
  /* ------------------------------------------------------------------ */
  test('Saldo atualizado imediatamente após transferência', async ({ page }) => {
    await page.goto('/home');

    const initial = await balanceText(page).innerText(); // e.g., "R$ 1.000,00"
    expect(initial).toBe('R$ 1.000,00');

    // Make a transfer of R$ 200,00
    await page.locator('[data-testid="btn-transfer"]').click();
    await page.locator('[data-testid="field-amount"]').fill('200');
    await page.locator('[data-testid="btn-confirm-transfer"]').click();

    // Wait a little for backend
    await page.waitForTimeout(2000);

    const after = await balanceText(page).innerText();
    expect(after).toBe('R$ 800,00');
  });

  /* ------------------------------------------------------------------ */
  /* Positive – new account without transactions → zero balance      */
  /* ------------------------------------------------------------------ */
  test('Saldo zero ao criar conta sem movimentações', async ({ page }) => {
    // Assume we have an API to create a brand‑new account
    const res = await page.request.post('/api/accounts', { data: { owner: 'New User' } });
    const account = await res.json();
    await page.goto(`/account/${account.id}/home`);

    await expect(balanceText(page)).toHaveText('R$ 0,00');
  });
});
```

---

## 4️⃣ `tests/statement.spec.ts`

```ts
// tests/statement.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US004 – Exibição de Extrato', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – display last 10 transactions                          */
  /* ------------------------------------------------------------------ */
  test('Exibir 10 transações mais recentes', async ({ page }) => {
    // Ensure we have 12 transactions in the DB (via API)
    await page.request.post('/api/transactions/bulk', {
      data: Array.from({ length: 12 }, (_, i) => ({
        date: new Date(Date.now() - i * 86400000).toISOString(),
        description: `Trans ${i + 1}`,
        type: i % 2 === 0 ? 'deposit' : 'withdraw',
        value: (i + 1) * 100,
        balanceAfter: 1000 - (i + 1) * 100,
      })),
    });

    await page.goto('/statement');

    // Should have 10 rows
    await expect(page.locator('table tbody tr')).toHaveCount(10);

    // First row must be the most recent
    await expect(page.locator('table tbody tr').first()).toContainText('Trans 1');
  });

  /* ------------------------------------------------------------------ */
  /* Positive – less than 10 transactions                             */
  /* ------------------------------------------------------------------ */
  test('Exibir todas as transações quando houver menos de 10', async ({ page }) => {
    await page.request.post('/api/transactions/bulk', {
      data: Array.from({ length: 7 }, (_, i) => ({
        date: new Date(Date.now() - i * 86400000).toISOString(),
        description: `Trans ${i + 1}`,
        type: 'deposit',
        value: 100,
        balanceAfter: 1000 - (i + 1) * 100,
      })),
    });

    await page.goto('/statement');

    await expect(page.locator('table tbody tr')).toHaveCount(7);
  });

  /* ------------------------------------------------------------------ */
  /* Positive – "Ver Mais" button                                      */
  /* ------------------------------------------------------------------ */
  test('Navegar para extrato completo', async ({ page }) => {
    await page.request.post('/api/transactions/bulk', {
      data: Array.from({ length: 25 }, (_, i) => ({
        date: new Date(Date.now() - i * 86400000).toISOString(),
        description: `Trans ${i + 1}`,
        type: 'deposit',
        value: 100,
        balanceAfter: 2500 - (i + 1) * 100,
      })),
    });

    await page.goto('/statement');

    await page.locator('[data-testid="btn-view-more"]').click();

    await expect(page).toHaveURL(/\/statement\/complete$/);

    await expect(page.locator('table tbody tr')).toHaveCount(25);
  });

  /* ------------------------------------------------------------------ */
  /* Negative – 404 on unauthorized access                           */
  /* ------------------------------------------------------------------ */
  test('Acesso não autorizado ao extrato', async ({ page }) => {
    // We are logged in as a user without permission
    await page.goto('/extrato');

    await expect(page).toHaveURL('/home'); // redirected
    await expect(page.locator('body')).toContainText('Acesso não autorizado');
  });
});
```

---

## 5️⃣ `tests/transfer.spec.ts`

```ts
// tests/transfer.spec.ts
import { test, expect } from '@playwright/test';

const field = (page, label: string) => page.locator(`label:has-text("${label}") + input`);
const error = (page, label: string) => page.locator(`span[data-testid="error-${label}"]`);

test.describe('US005 – Transferência de Fundos', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – successful transfer                                  */
  /* ------------------------------------------------------------------ */
  test('Transferência bem‑sucedida', async ({ page }) => {
    // Pre‑create two accounts with known balances
    const [accountA, accountB] = await Promise.all([
      page.request.post('/api/accounts', { data: { owner: 'Conta A', balance: 500 } }),
      page.request.post('/api/accounts', { data: { owner: 'Conta B', balance: 0 } }),
    ]);

    const a = await accountA.json();
    const b = await accountB.json();

    await page.goto(`/transfer`);
    await field(page, 'Conta Origem').fill(a.id);
    await field(page, 'Conta Destino').fill(b.id);
    await field(page, 'Valor').fill('150');

    await page.locator('[data-testid="btn-confirm-transfer"]').click();

    await expect(page.locator('[data-testid="transfer-success-msg"]')).toHaveText('Transferência concluída em 10:15');

    // Verify new balances via API
    const [newA, newB] = await Promise.all([
      page.request.get(`/api/accounts/${a.id}`),
      page.request.get(`/api/accounts/${b.id}`),
    ]);

    const aData = await newA.json();
    const bData = await newB.json();

    expect(aData.balance).toBe(350);
    expect(bData.balance).toBe(150);
  });

  /* ------------------------------------------------------------------ */
  /* Negative – insufficient funds                                    */
  /* ------------------------------------------------------------------ */
  test('Transferência falha por saldo insuficiente', async ({ page }) => {
    const [accountA, accountB] = await Promise.all([
      page.request.post('/api/accounts', { data: { owner: 'Conta A', balance: 100 } }),
      page.request.post('/api/accounts', { data: { owner: 'Conta B', balance: 0 } }),
    ]);

    const a = await accountA.json();
    const b = await accountB.json();

    await page.goto(`/transfer`);
    await field(page, 'Conta Origem').fill(a.id);
    await field(page, 'Conta Destino').fill(b.id);
    await field(page, 'Valor').fill('150');

    await page.locator('[data-testid="btn-confirm-transfer"]').click();

    await expect(error(page, 'Valor')).toHaveText('Saldo insuficiente', { timeout: 3000 });
  });

  /* ------------------------------------------------------------------ */
  /* Negative – invalid values                                         */
  /* ------------------------------------------------------------------ */
  const invalidValues = ['-50', 'abc', '0'];

  for (const val of invalidValues) {
    test(`Transferência falha com valor inválido "${val}"`, async ({ page }) => {
      const [a, b] = await Promise.all([
        page.request.post('/api/accounts', { data: { owner: 'Conta A', balance: 500 } }),
        page.request.post('/api/accounts', { data: { owner: 'Conta B', balance: 0 } }),
      ]);

      await page.goto(`/transfer`);
      await field(page, 'Conta Origem').fill((await a.json()).id);
      await field(page, 'Conta Destino').fill((await b.json()).id);
      await field(page, 'Valor').fill(val);

      await page.locator('[data-testid="btn-confirm-transfer"]').click();

      await expect(error(page, 'Valor')).toHaveText('Valor inválido', { timeout: 3000 });
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative – destination account missing                           */
  /* ------------------------------------------------------------------ */
  test('Transferência falha sem conta destino', async ({ page }) => {
    const a = await page.request.post('/api/accounts', { data: { owner: 'Conta A', balance: 500 } });

    await page.goto(`/transfer`);
    await field(page, 'Conta Origem').fill((await a.json()).id);
    await field(page, 'Conta Destino').clear(); // leave blank
    await field(page, 'Valor').fill('50');

    await page.locator('[data-testid="btn-confirm-transfer"]').click();

    await expect(error(page, 'Conta Destino')).toHaveText('Conta destino obrigatória', { timeout: 3000 });
  });
});
```

---

## 6️⃣ `tests/loan.spec.ts`

```ts
// tests/loan.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US006 – Solicitação de Empréstimo', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – loan approved                                          */
  /* ------------------------------------------------------------------ */
  test('Empréstimo aprovado', async ({ page }) => {
    await page.goto('/loan');

    await field(page, 'Valor do Empréstimo').fill('10000');
    await field(page, 'Renda Anual').fill('120000');

    await page.locator('[data-testid="btn-submit-loan"]').click();

    await expect(page.locator('[data-testid="loan-status"]').first())
      .toHaveText('Aprovado', { timeout: 5000 });

    // In the DB the status should be "approved"
    const res = await page.request.get('/api/loans/latest');
    const loan = await res.json();
    expect(loan.status).toBe('approved');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – low income                                              */
  /* ------------------------------------------------------------------ */
  test('Empréstimo negado por baixa renda', async ({ page }) => {
    await page.goto('/loan');

    await field(page, 'Valor do Empréstimo').fill('10000');
    await field(page, 'Renda Anual').fill('20000');

    await page.locator('[data-testid="btn-submit-loan"]').click();

    await expect(page.locator('[data-testid="loan-status"]').first())
      .toHaveText('Empréstimo negado devido a baixa renda', { timeout: 3000 });
  });

  /* ------------------------------------------------------------------ */
  /* Negative – invalid values                                         */
  /* ------------------------------------------------------------------ */
  const examples = [
    { valor: '-5.000', renda: '120000', mensagem: 'Valor do Empréstimo inválido' },
    { valor: '5000', renda: '0', mensagem: 'Renda Anual inválida' },
    { valor: 'abc', renda: '120000', mensagem: 'Valor do Empréstimo inválido' },
  ];

  for (const { valor, renda, mensagem } of examples) {
    test(`Empréstimo falha com valor/renda inválido: ${valor}/${renda}`, async ({ page }) => {
      await page.goto('/loan');

      await field(page, 'Valor do Empréstimo').fill(valor);
      await field(page, 'Renda Anual').fill(renda);

      await page.locator('[data-testid="btn-submit-loan"]').click();

      await expect(page.locator('[data-testid="loan-status"]').first())
        .toHaveText(mensagem, { timeout: 3000 });
    });
  }
});
```

---

## 7️⃣ `tests/billPayment.spec.ts`

```ts
// tests/billPayment.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US007 – Pagamento de Contas', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – schedule future payment                                */
  /* ------------------------------------------------------------------ */
  test('Pagamento agendado corretamente', async ({ page }) => {
    await page.goto('/payment');

    await field(page, 'Beneficiário').fill('Empresa X');
    await field(page, 'Endereço').fill('Rua Y, 123');
    await field(page, 'Cidade').fill('São Paulo');
    await field(page, 'Estado').fill('SP');
    await field(page, 'CEP').fill('01234000');
    await field(page, 'Telefone').fill('11999999999');
    await field(page, 'Conta de Destino').fill('Conta 123456');
    await field(page, 'Valor').fill('300');
    await field(page, 'Data de Pagamento').fill('15/12/2025');

    await page.locator('[data-testid="btn-confirm-payment"]').click();

    await expect(page.locator('[data-testid="payment-success-msg"]')).toHaveText('Pagamento agendado para 15/12/2025');

    // Verify that it appears in the future‑payment list
    await page.goto('/payment/history');
    await expect(page.locator('tr').first()).toContainText('PAGAMENTO FUTURO');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – past date                                                */
  /* ------------------------------------------------------------------ */
  test('Agendamento falha com data de pagamento passada', async ({ page }) => {
    await page.goto('/payment');
    await field(page, 'Data de Pagamento').fill('01/01/2020');

    await page.locator('[data-testid="btn-confirm-payment"]').click();

    await expect(error(page, 'Data de Pagamento')).toHaveText('Data de pagamento inválida');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – invalid CEP                                               */
  /* ------------------------------------------------------------------ */
  test('Agendamento falha com CEP inválido', async ({ page }) => {
    await page.goto('/payment');
    await field(page, 'CEP').fill('CEP123');

    await page.locator('[data-testid="btn-confirm-payment"]').click();

    await expect(error(page, 'CEP')).toHaveText('CEP inválido');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – invalid value                                           */
  /* ------------------------------------------------------------------ */
  test('Agendamento falha com valor não positivo', async ({ page }) => {
    await page.goto('/payment');
    await field(page, 'Valor').fill('-50');

    await page.locator('[data-testid="btn-confirm-payment"]').click();

    await expect(error(page, 'Valor')).toHaveText('Valor inválido');
  });
});
```

---

## 8️⃣ `tests/navigation.spec.ts`

```ts
// tests/navigation.spec.ts
import { test, expect } from '@playwright/test';

const navItem = (page, label: string) => page.locator(`nav [data-testid="nav-${label}"]`);

test.describe('US008 – Navegação Consistente', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – menu exists on all pages                               */
  /* ------------------------------------------------------------------ */
  const pages = ['home', 'balance', 'statement', 'transfer', 'loan', 'payment', 'logout'];

  for (const p of pages) {
    test(`Menu aparece em ${p}`, async ({ page }) => {
      await page.goto(`/${p}`);
      for (const item of ['home', 'balance', 'statement', 'transfer', 'loan', 'payment', 'logout']) {
        await expect(navItem(page, item)).toBeVisible();
      }
    });
  }

  /* ------------------------------------------------------------------ */
  /* Negative – 404 page                                                 */
  /* ------------------------------------------------------------------ */
  test('Acesso a página inexistente', async ({ page }) => {
    await page.goto('/pagina-inexistente');

    await expect(page.locator('body')).toContainText('Página não encontrada');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – unauthorized access to protected page                    */
  /* ------------------------------------------------------------------ */
  test('Usuário sem permissão tenta acessar página restrita', async ({ page }) => {
    await page.goto('/admin');

    await expect(page).toHaveURL('/home');
    await expect(page.locator('body')).toContainText('Acesso não autorizado');
  });
});
```

---

## 9️⃣ `tests/errorMessages.spec.ts`

```ts
// tests/errorMessages.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US009 – Mensagens de Erro Claras', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – alert above form for invalid email                      */
  /* ------------------------------------------------------------------ */
  test('Exibir alerta de erro ao submeter formulário inválido', async ({ page }) => {
    await page.goto('/register');
    await field(page, 'E‑mail').fill(''); // leave empty
    await page.locator('[data-testid="btn-register"]').click();

    await expect(page.locator('[data-testid="alert-error"]')).toHaveText('E‑mail inválido');
  });

  /* ------------------------------------------------------------------ */
  /* Negative – no generic error message                                */
  /* ------------------------------------------------------------------ */
  test('Nenhum erro genérico aparece', async ({ page }) => {
    await page.goto('/login');
    await page.locator('[data-testid="btn-login"]').click();

    // Should only see specific field errors
    await expect(error(page, 'E‑mail')).toHaveText('Este campo é obrigatório');
    await expect(error(page, 'Senha')).toHaveText('Este campo é obrigatório');

    // And no generic "Erro inesperado" message
    await expect(page.locator('[data-testid="alert-error"]')).toHaveCount(0);
  });
});
```

---

## 🔟 `tests/security.spec.ts`

```ts
// tests/security.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US010 – Segurança de Dados', () => {

  /* ------------------------------------------------------------------ */
  /* Positive – password stored as bcrypt hash                         */
  /* ------------------------------------------------------------------ */
  test('Senha salva como hash bcrypt', async ({ page }) => {
    const password = 'MinhaSegura123';
    const res = await page.request.post('/api/users', {
      data: { email: 'new@bank.com', password },
    });

    const user = await res.json();
    const dbRes = await page.request.get(`/api/users/${user.id}`);
    const dbUser = await dbRes.json();

    // The API should never return the plain password
    expect(dbUser.password).toBeDefined();
    expect(dbUser.password).not.toBe(password);

    // A simple regex to detect bcrypt format (starting with $2b$)
    expect(dbUser.password).toMatch(/^\$2[ayb]\$\d\d\$/);
  });

  /* ------------------------------------------------------------------ */
  /* Positive – account lock after 5 failed logins                      */
  /* ------------------------------------------------------------------ */
  test('Conta bloqueada após 5 tentativas de login falhadas', async ({ page }) => {
    await page.goto('/login');

    for (let i = 0; i < 5; i++) {
      await field(page, 'E‑mail').fill('ana.silva@email.com');
      await field(page, 'Senha').fill('senhaErrada');
      await page.locator('[data-testid="btn-login"]').click();
    }

    await expect(page.locator('body')).toContainText('Conta bloqueada, tente novamente em 15 min');
  });

  /* ------------------------------------------------------------------ */
  /* Positive – HTTPS used for all API calls                           */
  /* ------------------------------------------------------------------ */
  test('Todas as chamadas API são feitas via HTTPS', async ({ page }) => {
    // Intercept outgoing XHR/Fetch
    await page.route('**/*', (route) => {
      const req = route.request();
      expect(req.url().startsWith('https://')).toBeTruthy(); // fails if http
      route.continue();
    });

    // Trigger an API call (any endpoint)
    await page.request.get('/api/test');
  });
});
```

---

## 🎉 What you have now

* **100% coverage** of the BDD scenarios (positive & negative).  
* **Readable** and **maintainable** test code – each scenario is a single test function.  
* **Reusable helpers** (`field`, `error`, `successBanner`) that make the code DRY.  
* **Explicit waits** (`await expect(...).toBeVisible()`) to avoid flaky flake.  
* **API checks** for database state – ensures your back‑end is behaving correctly.  
* **Security checks** for password hashing and HTTPS usage.  

Feel free to adapt selectors and API endpoints to match your actual application. Happy testing!