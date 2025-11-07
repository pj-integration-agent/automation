## 📦 Estrutura de Projeto

```
.
├── tests
│   ├── registration.spec.ts
│   ├── login.spec.ts
│   ├── balance.spec.ts
│   ├── statement.spec.ts
│   ├── transfer.spec.ts
│   ├── loan.spec.ts
│   ├── bill-payment.spec.ts
│   └── navigation.spec.ts
├── pages
│   ├── login-page.ts
│   ├── register-page.ts
│   ├── home-page.ts
│   ├── statement-page.ts
│   ├── transfer-page.ts
│   ├── loan-page.ts
│   └── bill-payment-page.ts
├── utils
│   └── helpers.ts
├── playwright.config.ts
└── package.json
```

> **Obs.**  
> – Os *selectors* usados abaixo são **exemplos**; ajuste‑os conforme o HTML da sua aplicação.  
> – O código utiliza **TypeScript** e o *Playwright Test Runner*.

---

## 🔧 1. `playwright.config.ts`

```ts
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  timeout: 30_000,                     // 30s por teste
  retries: 1,                          // 1 retry em caso de falha inesperada
  use: {
    baseURL: 'https://app.seubanco.com', // Altere para sua URL
    headless: true,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    // Adicione Firefox/Chromium/… se quiser
  ],
  testDir: './tests',
});
```

---

## 📄 2. `utils/helpers.ts`

```ts
// utils/helpers.ts
export const generateRandomEmail = (): string =>
  `user_${Date.now()}_${Math.random().toString(36).substring(2, 8)}@demo.com`;

export const formatCurrency = (value: number): string =>
  new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 2,
  }).format(value);
```

---

## 📦 3. Page Objects

> Cada *page object* encapsula os **seletores** e os **métodos** que representam a UI da página.

### 3.1 `pages/login-page.ts`

```ts
// pages/login-page.ts
import { Page, expect } from '@playwright/test';
import { formatCurrency } from '../utils/helpers';

export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid="email-input"]', email);
    await this.page.fill('[data-testid="password-input"]', password);
    await this.page.click('[data-testid="login-button"]');
  }

  async getErrorMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="error-message"]')).toBeVisible();
    return this.page.locator('[data-testid="error-message"]').innerText();
  }

  async getUserName(): Promise<string> {
    await expect(this.page.locator('[data-testid="user-name"]')).toBeVisible();
    return this.page.locator('[data-testid="user-name"]').innerText();
  }
}
```

### 3.2 `pages/register-page.ts`

```ts
// pages/register-page.ts
import { Page, expect } from '@playwright/test';

export class RegisterPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/register');
  }

  async fillForm({
    name,
    email,
    cpf,
    phone,
    password,
  }: {
    name?: string;
    email?: string;
    cpf?: string;
    phone?: string;
    password?: string;
  }) {
    if (name !== undefined) await this.page.fill('[data-testid="name-input"]', name);
    if (email !== undefined) await this.page.fill('[data-testid="email-input"]', email);
    if (cpf !== undefined) await this.page.fill('[data-testid="cpf-input"]', cpf);
    if (phone !== undefined) await this.page.fill('[data-testid="phone-input"]', phone);
    if (password !== undefined) await this.page.fill('[data-testid="password-input"]', password);
  }

  async submit() {
    await this.page.click('[data-testid="register-button"]');
  }

  async getSuccessMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="success-message"]')).toBeVisible();
    return this.page.locator('[data-testid="success-message"]').innerText();
  }

  async getErrorMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="error-message"]')).toBeVisible();
    return this.page.locator('[data-testid="error-message"]').innerText();
  }
}
```

### 3.3 `pages/home-page.ts`

```ts
// pages/home-page.ts
import { Page, expect } from '@playwright/test';

export class HomePage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/');
  }

  async getBalanceText(): Promise<string> {
    await expect(this.page.locator('[data-testid="balance"]')).toBeVisible();
    return this.page.locator('[data-testid="balance"]').innerText();
  }

  async clickTransferButton() {
    await this.page.click('[data-testid="transfer-button"]');
  }

  async clickLoanButton() {
    await this.page.click('[data-testid="loan-button"]');
  }

  async clickBillPaymentButton() {
    await this.page.click('[data-testid="bill-payment-button"]');
  }

  async clickStatementButton() {
    await this.page.click('[data-testid="statement-button"]');
  }

  async reload() {
    await this.page.reload();
  }
}
```

### 3.4 `pages/statement-page.ts`

```ts
// pages/statement-page.ts
import { Page, expect } from '@playwright/test';

export class StatementPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/statement');
  }

  async getTransactions(): Promise<string[]> {
    await expect(this.page.locator('[data-testid="transaction-row"]')).toBeVisible();
    const rows = await this.page.locator('[data-testid="transaction-row"]').all();
    const texts = [];
    for (const row of rows) {
      texts.push(await row.innerText());
    }
    return texts;
  }

  async clickShowMore() {
    await this.page.click('[data-testid="show-more-button"]');
  }

  async hasNoTransactionsMessage(): Promise<boolean> {
    const locator = this.page.locator('[data-testid="no-transactions-message"]');
    return (await locator.count()) > 0;
  }
}
```

### 3.5 `pages/transfer-page.ts`

```ts
// pages/transfer-page.ts
import { Page, expect } from '@playwright/test';

export class TransferPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/transfer');
  }

  async selectOriginAccount(accountName: string) {
    await this.page.selectOption('[data-testid="origin-account-select"]', { label: accountName });
  }

  async selectDestinationAccount(accountName: string) {
    await this.page.selectOption('[data-testid="destination-account-select"]', { label: accountName });
  }

  async setAmount(amount: string) {
    await this.page.fill('[data-testid="amount-input"]', amount);
  }

  async confirm() {
    await this.page.click('[data-testid="confirm-transfer-button"]');
  }

  async getSuccessMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="transfer-success-message"]')).toBeVisible();
    return this.page.locator('[data-testid="transfer-success-message"]').innerText();
  }

  async getErrorMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="transfer-error-message"]')).toBeVisible();
    return this.page.locator('[data-testid="transfer-error-message"]').innerText();
  }
}
```

### 3.6 `pages/loan-page.ts`

```ts
// pages/loan-page.ts
import { Page, expect } from '@playwright/test';

export class LoanPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/loan');
  }

  async setAmount(amount: string) {
    await this.page.fill('[data-testid="loan-amount-input"]', amount);
  }

  async setAnnualIncome(income: string) {
    await this.page.fill('[data-testid="annual-income-input"]', income);
  }

  async submit() {
    await this.page.click('[data-testid="apply-loan-button"]');
  }

  async getModalMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="loan-modal-message"]')).toBeVisible();
    return this.page.locator('[data-testid="loan-modal-message"]').innerText();
  }

  async getErrorMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="loan-error-message"]')).toBeVisible();
    return this.page.locator('[data-testid="loan-error-message"]').innerText();
  }
}
```

### 3.7 `pages/bill-payment-page.ts`

```ts
// pages/bill-payment-page.ts
import { Page, expect } from '@playwright/test';

export class BillPaymentPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/bill-payment');
  }

  async setBeneficiary(beneficiary: string) {
    await this.page.fill('[data-testid="beneficiary-input"]', beneficiary);
  }

  async setAmount(amount: string) {
    await this.page.fill('[data-testid="payment-amount-input"]', amount);
  }

  async setDate(date: string) {
    // Data no formato YYYY-MM-DD
    await this.page.fill('[data-testid="payment-date-input"]', date);
  }

  async confirm() {
    await this.page.click('[data-testid="confirm-payment-button"]');
  }

  async getSuccessMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="payment-success-message"]')).toBeVisible();
    return this.page.locator('[data-testid="payment-success-message"]').innerText();
  }

  async getErrorMessage(): Promise<string> {
    await expect(this.page.locator('[data-testid="payment-error-message"]')).toBeVisible();
    return this.page.locator('[data-testid="payment-error-message"]').innerText();
  }
}
```

---

## 🧪 4. Testes

> Cada *test* segue os passos do BDD e inclui **esperas** (`expect`) e **comentários** explicativos.

### 4.1 `tests/registration.spec.ts`

```ts
// tests/registration.spec.ts
import { test, expect } from '@playwright/test';
import { RegisterPage } from '../pages/register-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US01 – Registro de conta', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/register');
  });

  test('Registro de conta com dados válidos', async ({ page }) => {
    const register = new RegisterPage(page);
    const email = generateRandomEmail();

    // Preenche todos os campos obrigatórios
    await register.fillForm({
      name: 'Fulano Silva',
      email,
      cpf: '12345678901',
      phone: '11987654321',
      password: 'Senha!123',
    });

    await register.submit();

    // Verifica mensagem de sucesso e redirecionamento
    await expect(page).toHaveURL('/login');
    const successMsg = await register.getSuccessMessage();
    expect(successMsg).toBe('Cadastro concluído com sucesso');
  });

  test('Erro ao omitir campo obrigatório (CPF)', async ({ page }) => {
    const register = new RegisterPage(page);
    const email = generateRandomEmail();

    // Preenche todos os campos exceto CPF
    await register.fillForm({
      name: 'Ana Santos',
      email,
      phone: '11987654321',
      password: 'Senha!123',
    });

    await register.submit();

    // Espera a mensagem de erro específica
    const errorMsg = await register.getErrorMessage();
    expect(errorMsg).toBe('CPF é obrigatório');
  });

  test('Erro de formato de telefone (texto alfabético)', async ({ page }) => {
    const register = new RegisterPage(page);
    const email = generateRandomEmail();

    await register.fillForm({
      name: 'Carlos Pereira',
      email,
      cpf: '12345678901',
      phone: 'telefone123',
      password: 'Senha!123',
    });

    await register.submit();

    const errorMsg = await register.getErrorMessage();
    expect(errorMsg).toBe('Telefone inválido, apenas números são permitidos');
  });

  test('Registro com e‑mail já cadastrado', async ({ page }) => {
    const register = new RegisterPage(page);
    const existingEmail = 'usuario@exemplo.com'; // email que já está no BD

    await register.fillForm({
      name: 'João da Silva',
      email: existingEmail,
      cpf: '12345678901',
      phone: '11987654321',
      password: 'Senha!123',
    });

    await register.submit();

    const errorMsg = await register.getErrorMessage();
    expect(errorMsg).toBe('E‑mail já cadastrado');
  });
});
```

---

### 4.2 `tests/login.spec.ts`

```ts
// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/login-page';
import { RegisterPage } from '../pages/register-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US02 – Login', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
  });

  // Helpers: cria um usuário de teste antes de cada caso de login bem‑sucedido
  const createUser = async (page) => {
    const register = new RegisterPage(page);
    const email = generateRandomEmail();
    await register.goto();
    await register.fillForm({
      name: 'Test User',
      email,
      cpf: '12345678901',
      phone: '11987654321',
      password: 'Senha!123',
    });
    await register.submit();
    return { email, password: 'Senha!123' };
  };

  test('Login bem-sucedido', async ({ page }) => {
    const { email, password } = await createUser(page);

    const login = new LoginPage(page);
    await login.login(email, password);

    // Espera o redirecionamento e a exibição do nome do usuário
    await expect(page).toHaveURL('/');
    const userName = await login.getUserName();
    expect(userName).toContain('Test User'); // Ajuste conforme o texto exibido
  });

  test('Falha de login por e‑mail inexistente', async ({ page }) => {
    const login = new LoginPage(page);
    await login.login('nonexistent@demo.com', 'Senha!123');
    const errorMsg = await login.getErrorMessage();
    expect(errorMsg).toBe('E‑mail ou senha inválidos');
  });

  test('Falha de login por senha incorreta', async ({ page }) => {
    // Primeiro cria usuário
    const { email } = await createUser(page);

    const login = new LoginPage(page);
    await login.login(email, 'SenhaIncorreta!'); // senha errada
    const errorMsg = await login.getErrorMessage();
    expect(errorMsg).toBe('E‑mail ou senha inválidos');
  });

  test('Erro ao deixar campo de e‑mail vazio', async ({ page }) => {
    const login = new LoginPage(page);
    await login.page.fill('[data-testid="password-input"]', 'Senha!123');
    await login.page.click('[data-testid="login-button"]');

    const errorMsg = await login.getErrorMessage();
    expect(errorMsg).toBe('E‑mail é obrigatório');
  });
});
```

---

### 4.3 `tests/balance.spec.ts`

```ts
// tests/balance.spec.ts
import { test, expect } from '@playwright/test';
import { HomePage } from '../pages/home-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US03 – Exibir saldo', () => {
  async function loginAsTestUser(page) {
    const register = new LoginPage(page); // reutiliza a mesma classe
    const email = generateRandomEmail();
    const password = 'Senha!123';

    // Cria usuário
    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', 'Saldo Teste');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="cpf-input"]', '12345678901');
    await page.fill('[data-testid="phone-input"]', '11987654321');
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="register-button"]');

    // Faz login
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
  }

  test.beforeEach(async ({ page }) => {
    await loginAsTestUser(page);
  });

  test('Exibir saldo formatado corretamente', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();

    const balanceText = await home.getBalanceText();
    // Exemplo: "R$ 1.234,56"
    expect(balanceText).toMatch(/^R\$\s?\d{1,3}(?:\.\d{3})*,\d{2}$/);
  });

  test('Atualização automática do saldo após transferência', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();

    // Saldo inicial
    const initialBalance = await home.getBalanceText();

    // Faz uma transferência
    await home.clickTransferButton();
    const transferPage = new (await import('../pages/transfer-page')).TransferPage(page);
    await transferPage.selectOriginAccount('Conta Corrente');
    await transferPage.selectDestinationAccount('Conta Poupança');
    await transferPage.setAmount('500');
    await transferPage.confirm();

    // Confirma que a transferência foi concluída
    const transferSuccess = await transferPage.getSuccessMessage();
    expect(transferSuccess).toBe('Transferência concluída');

    // Recarrega a página inicial
    await home.reload();

    const newBalance = await home.getBalanceText();

    // Simples verificação de subtração (não valida o valor exato, apenas mudança)
    expect(newBalance).not.toBe(initialBalance);
  });

  test('Falha no carregamento do saldo', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();

    // Simula falha via mock de API (exemplo, depende da sua aplicação)
    await page.route('**/api/balance', async route => {
      await route.fulfill({
        status: 500,
        body: JSON.stringify({ error: 'service unavailable' }),
      });
    });

    // Tenta obter o saldo (a página tenta, falha e mostra mensagem)
    const errorBanner = page.locator('[data-testid="balance-error-banner"]');
    await expect(errorBanner).toBeVisible();
    const bannerText = await errorBanner.innerText();
    expect(bannerText).toBe('Não foi possível carregar o saldo. Tente novamente.');
  });
});
```

---

### 4.4 `tests/statement.spec.ts`

```ts
// tests/statement.spec.ts
import { test, expect } from '@playwright/test';
import { HomePage } from '../pages/home-page';
import { StatementPage } from '../pages/statement-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US04 – Extrato de transações', () => {
  async function loginAsTestUser(page) {
    const email = generateRandomEmail();
    const password = 'Senha!123';

    // Registro rápido
    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', 'Transação Teste');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="cpf-input"]', '12345678901');
    await page.fill('[data-testid="phone-input"]', '11987654321');
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="register-button"]');

    // Login
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
  }

  test.beforeEach(async ({ page }) => {
    await loginAsTestUser(page);
  });

  test('Exibir as 10 transações mais recentes', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();

    await home.clickStatementButton();
    const statement = new StatementPage(page);
    const transactions = await statement.getTransactions();

    expect(transactions.length).toBeLessThanOrEqual(10);
    // Verifica ordem decrescente (data mais recente primeiro)
    const dates = transactions.map(t => new Date(t.split(' - ')[0])); // ajuste caso o formato seja diferente
    for (let i = 1; i < dates.length; i++) {
      expect(dates[i - 1]).toBeGreaterThanOrEqual(dates[i]);
    }
  });

  test('Carregar mais transações ao clicar em "Mostrar mais"', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();
    await home.clickStatementButton();

    const statement = new StatementPage(page);
    const initialCount = (await statement.getTransactions()).length;

    await statement.clickShowMore();

    const afterCount = (await statement.getTransactions()).length;
    expect(afterCount).toBeGreaterThan(initialCount);
    expect(afterCount).toBe(initialCount + 10);
  });

  test('Nenhuma transação encontrada', async ({ page }) => {
    const home = new HomePage(page);
    await home.goto();
    await home.clickStatementButton();

    const statement = new StatementPage(page);
    // Simula ausência de transações via mock
    await page.route('**/api/transactions', route => route.fulfill({
      status: 200,
      body: JSON.stringify({ transactions: [] }),
    }));

    const noMsg = await statement.hasNoTransactionsMessage();
    expect(noMsg).toBeTruthy();
  });
});
```

---

### 4.5 `tests/transfer.spec.ts`

```ts
// tests/transfer.spec.ts
import { test, expect } from '@playwright/test';
import { TransferPage } from '../pages/transfer-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US05 – Transferência de fundos', () => {
  async function loginAsTestUser(page) {
    const email = generateRandomEmail();
    const password = 'Senha!123';

    // Registro
    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', 'Transferencia Teste');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="cpf-input"]', '12345678901');
    await page.fill('[data-testid="phone-input"]', '11987654321');
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="register-button"]');

    // Login
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
  }

  test.beforeEach(async ({ page }) => {
    await loginAsTestUser(page);
  });

  test('Transferência bem-sucedida entre contas', async ({ page }) => {
    const transfer = new TransferPage(page);
    await transfer.goto();

    await transfer.selectOriginAccount('Conta Corrente');
    await transfer.selectDestinationAccount('Conta Poupança');
    await transfer.setAmount('300');
    await transfer.confirm();

    const msg = await transfer.getSuccessMessage();
    expect(msg).toBe('Transferência concluída');

    // Os saldos podem ser verificados no HomePage (p.ex. via API mock ou DOM)
  });

  test('Falha por saldo insuficiente', async ({ page }) => {
    // Supondo que saldo atual seja R$5.000,00
    const transfer = new TransferPage(page);
    await transfer.goto();

    await transfer.selectOriginAccount('Conta Corrente');
    await transfer.selectDestinationAccount('Conta Poupança');
    await transfer.setAmount('10000'); // 10.000
    await transfer.confirm();

    const errMsg = await transfer.getErrorMessage();
    expect(errMsg).toBe('Saldo insuficiente');
  });

  test('Erro ao inserir valor negativo ou zero', async ({ page }) => {
    const transfer = new TransferPage(page);
    await transfer.goto();

    await transfer.setAmount('-50');
    await transfer.confirm();

    const errMsg = await transfer.getErrorMessage();
    expect(errMsg).toBe('Valor inválido, deve ser positivo');
  });
});
```

---

### 4.6 `tests/loan.spec.ts`

```ts
// tests/loan.spec.ts
import { test, expect } from '@playwright/test';
import { LoanPage } from '../pages/loan-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';

test.describe('US06 – Solicitação de empréstimo', () => {
  async function loginAsTestUser(page) {
    const email = generateRandomEmail();
    const password = 'Senha!123';

    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', 'Empréstimo Teste');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="cpf-input"]', '12345678901');
    await page.fill('[data-testid="phone-input"]', '11987654321');
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="register-button"]');

    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
  }

  test.beforeEach(async ({ page }) => {
    await loginAsTestUser(page);
  });

  test('Empréstimo aprovado', async ({ page }) => {
    const loan = new LoanPage(page);
    await loan.goto();

    await loan.setAmount('50000');
    await loan.setAnnualIncome('200000');
    await loan.submit();

    const msg = await loan.getModalMessage();
    expect(msg).toBe('Seu empréstimo foi aprovado');
  });

  test('Empréstimo negado por valor máximo excedido', async ({ page }) => {
    const loan = new LoanPage(page);
    await loan.goto();

    await loan.setAmount('250000'); // > 200k
    await loan.setAnnualIncome('300000');
    await loan.submit();

    const err = await loan.getErrorMessage();
    expect(err).toBe('Valor máximo de empréstimo é R$ 200.000,00');
  });

  test('Empréstimo negado por renda anual muito baixa', async ({ page }) => {
    const loan = new LoanPage(page);
    await loan.goto();

    await loan.setAmount('50000');
    await loan.setAnnualIncome('20000'); // muito baixo
    await loan.submit();

    const err = await loan.getErrorMessage();
    expect(err).toBe('Seu empréstimo foi negado');
    // Sugestão de revisão de renda pode ser verificada em outro elemento
  });

  test('Erro ao inserir valor não numérico', async ({ page }) => {
    const loan = new LoanPage(page);
    await loan.goto();

    await loan.setAmount('abc');
    await loan.setAnnualIncome('200000');
    await loan.submit();

    const err = await loan.getErrorMessage();
    expect(err).toBe('Valor inválido, apenas números são permitidos');
  });
});
```

---

### 4.7 `tests/bill-payment.spec.ts`

```ts
// tests/bill-payment.spec.ts
import { test, expect } from '@playwright/test';
import { BillPaymentPage } from '../pages/bill-payment-page';
import { LoginPage } from '../pages/login-page';
import { generateRandomEmail } from '../utils/helpers';
import { formatCurrency } from '../utils/helpers';

test.describe('US07 – Pagamento de conta', () => {
  async function loginAsTestUser(page) {
    const email = generateRandomEmail();
    const password = 'Senha!123';

    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', 'Pagamento Teste');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="cpf-input"]', '12345678901');
    await page.fill('[data-testid="phone-input"]', '11987654321');
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="register-button"]');

    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
  }

  test.beforeEach(async ({ page }) => {
    await loginAsTestUser(page);
  });

  test('Agendamento de pagamento futuro', async ({ page }) => {
    const payment = new BillPaymentPage(page);
    await payment.goto();

    const futureDate = new Date();
    futureDate.setDate(futureDate.getDate() + 10);
    const dateStr = futureDate.toISOString().split('T')[0]; // YYYY-MM-DD

    await payment.setBeneficiary('Fornecedor X');
    await payment.setAmount('1500');
    await payment.setDate(dateStr);
    await payment.confirm();

    const msg = await payment.getSuccessMessage();
    expect(msg).toBe('Pagamento agendado');

    // Verifica se a transação aparece como "Pendente" no extrato
    // (pode ser feita via API mock ou verificando um elemento no extrato)
  });

  test('Erro por data no passado', async ({ page }) => {
    const payment = new BillPaymentPage(page);
    await payment.goto();

    const pastDate = new Date();
    pastDate.setDate(pastDate.getDate() - 1);
    const dateStr = pastDate.toISOString().split('T')[0];

    await payment.setBeneficiary('Fornecedor Y');
    await payment.setAmount('500');
    await payment.setDate(dateStr);
    await payment.confirm();

    const err = await payment.getErrorMessage();
    expect(err).toBe('Data inválida');
  });

  test('Erro por valor negativo', async ({ page }) => {
    const payment = new BillPaymentPage(page);
    await payment.goto();

    await payment.setBeneficiary('Fornecedor Z');
    await payment.setAmount('-100');
    await payment.setDate(new Date().toISOString().split('T')[0]);
    await payment.confirm();

    const err = await payment.getErrorMessage();
    expect(err).toBe('Valor inválido, deve ser positivo');
  });

  test('Erro ao omitir campo obrigatório (Beneficiário)', async ({ page }) => {
    const payment = new BillPaymentPage(page);
    await payment.goto();

    await payment.setAmount('200');
    await payment.setDate(new Date().toISOString().split('T')[0]);
    // Beneficiário deixado em branco
    await payment.confirm();

    const err = await payment.getErrorMessage();
    expect(err).toBe('Beneficiário é obrigatório');
  });
});
```

---

### 4.8 `tests/navigation.spec.ts`

```ts
// tests/navigation.spec.ts
import { test, expect } from '@playwright/test';

test.describe('US08 – Navegação e Consistência de página', () => {
  const pagesToTest = [
    { url: '/', name: 'Home' },
    { url: '/login', name: 'Login' },
    { url: '/register', name: 'Register' },
    { url: '/transfer', name: 'Transfer' },
    { url: '/loan', name: 'Loan' },
    { url: '/bill-payment', name: 'Bill Payment' },
    { url: '/statement', name: 'Statement' },
  ];

  test('Todas as páginas carregam sem erros 404', async ({ page }) => {
    for (const p of pagesToTest) {
      await page.goto(p.url);
      await expect(page).not.toHaveURL(/.*\.404/); // Não redireciona para 404
      // Verifica se há banner de erro
      const banner = page.locator('[data-testid="error-banner"]');
      await expect(banner).not.toBeVisible();
    }
  });

  test('Link inválido gera erro 404', async ({ page }) => {
    // Clica em um link que não existe (exemplo: /nonexistent)
    await page.goto('/');
    await page.click('text=Nonexistent'); // assume que há um link de texto
    await page.waitForLoadState('networkidle');

    await expect(page).toHaveURL(/.*\/nonexistent/);
    const errorBanner = page.locator('[data-testid="error-banner"]');
    await expect(errorBanner).toBeVisible();
    const bannerText = await errorBanner.innerText();
    expect(bannerText).toContain('404');
  });

  test('Banner vermelho de erro inesperado aparece', async ({ page }) => {
    // Simula exceção do servidor usando mock
    await page.route('**/api/*', async route => {
      if (route.request().url().includes('/home')) {
        await route.fulfill({
          status: 500,
          body: JSON.stringify({ error: 'internal error' }),
        });
      } else {
        await route.fallback();
      }
    });

    await page.goto('/');
    const banner = page.locator('[data-testid="server-error-banner"]');
    await expect(banner).toBeVisible();
    const text = await banner.innerText();
    expect(text).toBe('Erro inesperado. Tente novamente');
  });
});
```

---

## 📌 5. Dicas de Boas Práticas

| Prática | Por que é importante | Como implementamos |
|---------|---------------------|---------------------|
| **Page Objects** | Isolamento de lógica de UI; facilita manutenção | Cada página tem sua própria classe com métodos claros |
| **Selectors legíveis** | Reduz o risco de breakage quando a UI muda | Usamos `data-testid` (ou `aria-label`) – deve existir nos componentes |
| **Esperas explícitas** | Evita flakiness | `await expect(locator).toBeVisible()` antes de interagir |
| **Reutilização de código** | Menos duplicação | Funções auxiliares para login/registro, `generateRandomEmail()` |
| **Mock de API** | Teste em ambiente controlado | `page.route` para simular falhas de serviço |
| **Mensagens de erro verificadas** | Confirma comportamento de validação | `expect(errorMsg).toBe('...')` |
| **Testes isolados** | Facilita diagnóstico | Cada teste começa com um usuário limpo |

---

## 🚀 6. Execução

```bash
# 1. Instale as dependências
npm install --save-dev @playwright/test

# 2. Instale os browsers do Playwright
npx playwright install

# 3. Rode os testes
npx playwright test
```

Os resultados aparecerão no console e no relatório gerado automaticamente pelo Playwright.

--- 

> **Próximos passos**  
> - Adicionar fixtures para login/registro, evitando repetir código em todos os testes.  
> - Utilizar `test.describe.configure({ mode: 'serial' })` para testes que dependem de estado compartilhado.  
> - Gerar relatórios HTML avançados (`npx playwright show-report`).  

Boa sorte com seus testes automatizados! 🚀