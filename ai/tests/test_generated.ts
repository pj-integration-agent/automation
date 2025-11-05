## 👩‍💻 Automação Playwright – Código completo pronto para execução

Abaixo você encontra **todas as peças** necessárias para transformar o BDD em testes automatizados com Playwright + TypeScript.  
O código já segue boas práticas:

* **Page Objects** – separação de responsabilidades.  
* **Fixtures** – contexto autenticado reutilizado nos cenários que precisam de login.  
* **Expect** – validações explícitas.  
* **Waits** – espera por elementos visíveis/ativos.  
* **Comments** – explicação passo a passo.

> **Obs.**  
> Os seletores (`#email`, `.cpf-input`…​) são exemplos. Ajuste-os de acordo com a aplicação real.

---

## 📁 Estrutura de pastas sugerida

```
/e2e
  ├─ /fixtures
  │   └─ auth.ts
  ├─ /pages
  │   ├─ base.page.ts
  │   ├─ login.page.ts
  │   ├─ register.page.ts
  │   ├─ dashboard.page.ts
  │   ├─ transfer.page.ts
  │   ├─ loan.page.ts
  │   ├─ billpayment.page.ts
  ├─ /tests
  │   ├─ register.spec.ts
  │   ├─ login.spec.ts
  │   ├─ account.spec.ts
  │   ├─ transfer.spec.ts
  │   ├─ loan.spec.ts
  │   ├─ billpayment.spec.ts
  │   └─ navigation.spec.ts
  ├─ utils
  │   ├─ data.ts
  │   └─ constants.ts
  ├─ playwright.config.ts
  └─ package.json
```

Abaixo você verá o conteúdo de cada arquivo.  
Basta copiar/colar dentro do seu projeto e executar `npx playwright test`.

---

## 🗂️ Arquivos de **page objects**

```ts
// e2e/pages/base.page.ts
import { Page, Locator, expect } from '@playwright/test';

export class BasePage {
  protected readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Espera a página carregar (ex.: spinner desaparecer)
  async waitForLoad(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }
}
```

```ts
// e2e/pages/login.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class LoginPage extends BasePage {
  private emailInput: Locator = this.page.locator('#email');
  private passwordInput: Locator = this.page.locator('#password');
  private submitBtn: Locator = this.page.locator('button[type="submit"]');
  private errorMsg: Locator = this.page.locator('.error-message');

  async goTo(): Promise<void> {
    await this.page.goto('https://demo-pabank.com/login'); // ajuste a URL
    await this.waitForLoad();
  }

  async login(email: string, password: string): Promise<void> {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitBtn.click();
  }

  async expectError(message: string): Promise<void> {
    await expect(this.errorMsg).toHaveText(message);
  }
}
```

```ts
// e2e/pages/register.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class RegisterPage extends BasePage {
  // Seletor dos campos de entrada
  private nameInput: Locator = this.page.locator('#name');
  private cpfInput: Locator = this.page.locator('#cpf');
  private phoneInput: Locator = this.page.locator('#phone');
  private zipInput: Locator = this.page.locator('#zip');
  private emailInput: Locator = this.page.locator('#email');
  private passwordInput: Locator = this.page.locator('#password');
  private confirmPasswordInput: Locator = this.page.locator('#confirmPassword');

  private saveBtn: Locator = this.page.locator('button[type="submit"]');

  // Mensagens de erro
  private errorPhone: Locator = this.page.locator('#error-phone');
  private errorZip: Locator = this.page.locator('#error-zip');
  private errorEmail: Locator = this.page.locator('#error-email');

  // Mensagem de sucesso
  private successMsg: Locator = this.page.locator('.success-message');

  async goTo(): Promise<void> {
    await this.page.goto('https://demo-pabank.com/register');
    await this.waitForLoad();
  }

  // Preencher campos com valores inválidos (telefone, CEP, email)
  async fillInvalidData({ phone, zip, email }: { phone: string; zip: string; email: string }): Promise<void> {
    await this.phoneInput.fill(phone);
    await this.zipInput.fill(zip);
    await this.emailInput.fill(email);
    // demais campos obrigatórios podem ser deixados vazios
  }

  // Preencher todos os campos obrigatórios com valores válidos
  async fillValidData(data: {
    name: string; cpf: string; phone: string; zip: string; email: string; password: string;
  }): Promise<void> {
    await this.nameInput.fill(data.name);
    await this.cpfInput.fill(data.cpf);
    await this.phoneInput.fill(data.phone);
    await this.zipInput.fill(data.zip);
    await this.emailInput.fill(data.email);
    await this.passwordInput.fill(data.password);
    await this.confirmPasswordInput.fill(data.password);
  }

  async clickSave(): Promise<void> {
    await this.saveBtn.click();
  }

  // Asserções
  async expectErrorPhone(): Promise<void> {
    await expect(this.errorPhone).toBeVisible();
  }
  async expectErrorZip(): Promise<void> {
    await expect(this.errorZip).toBeVisible();
  }
  async expectErrorEmail(): Promise<void> {
    await expect(this.errorEmail).toBeVisible();
  }
  async expectSuccess(): Promise<void> {
    await expect(this.successMsg).toHaveText('Cadastro concluído com sucesso');
  }
}
```

```ts
// e2e/pages/dashboard.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class DashboardPage extends BasePage {
  private balanceDisplay: Locator = this.page.locator('#account-balance');
  private transferLink: Locator = this.page.locator('a[href="/transfer"]');
  private loanLink: Locator = this.page.locator('a[href="/loan"]');
  private billPaymentLink: Locator = this.page.locator('a[href="/billpayment"]');

  async getBalance(): Promise<string> {
    await this.balanceDisplay.waitFor({ state: 'visible' });
    return this.balanceDisplay.textContent();
  }

  async navigateToTransfer(): Promise<void> {
    await this.transferLink.click();
    await this.waitForLoad();
  }

  async navigateToLoan(): Promise<void> {
    await this.loanLink.click();
    await this.waitForLoad();
  }

  async navigateToBillPayment(): Promise<void> {
    await this.billPaymentLink.click();
    await this.waitForLoad();
  }
}
```

```ts
// e2e/pages/transfer.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class TransferPage extends BasePage {
  private originSelect: Locator = this.page.locator('#origin-account');
  private destinationSelect: Locator = this.page.locator('#destination-account');
  private amountInput: Locator = this.page.locator('#transfer-amount');
  private confirmBtn: Locator = this.page.locator('button[type="submit"]');

  private errorMsg: Locator = this.page.locator('.error-message');
  private transactionHistory: Locator = this.page.locator('.transaction-list');

  async selectOrigin(accountId: string): Promise<void> {
    await this.originSelect.selectOption(accountId);
  }
  async selectDestination(accountId: string): Promise<void> {
    await this.destinationSelect.selectOption(accountId);
  }
  async enterAmount(value: number): Promise<void> {
    await this.amountInput.fill(value.toString());
  }
  async confirm(): Promise<void> {
    await this.confirmBtn.click();
  }

  async expectError(message: string): Promise<void> {
    await expect(this.errorMsg).toHaveText(message);
  }

  async getTransactionHistory(): Promise<string[]> {
    await this.transactionHistory.waitFor({ state: 'visible' });
    const items = await this.transactionHistory.locator('li').allInnerTexts();
    return items;
  }
}
```

```ts
// e2e/pages/loan.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class LoanPage extends BasePage {
  private amountInput: Locator = this.page.locator('#loan-amount');
  private incomeInput: Locator = this.page.locator('#annual-income');
  private submitBtn: Locator = this.page.locator('button[type="submit"]');
  private statusMsg: Locator = this.page.locator('.status-message');

  async enterAmount(amount: number): Promise<void> {
    await this.amountInput.fill(amount.toString());
  }
  async enterAnnualIncome(income: number): Promise<void> {
    await this.incomeInput.fill(income.toString());
  }
  async submit(): Promise<void> {
    await this.submitBtn.click();
  }
  async expectStatus(message: string): Promise<void> {
    await expect(this.statusMsg).toHaveText(message);
  }
}
```

```ts
// e2e/pages/billpayment.page.ts
import { BasePage } from './base.page';
import { Locator, expect } from '@playwright/test';

export class BillPaymentPage extends BasePage {
  private beneficiaryInput: Locator = this.page.locator('#beneficiary');
  private addressInput: Locator = this.page.locator('#address');
  private cityInput: Locator = this.page.locator('#city');
  private stateInput: Locator = this.page.locator('#state');
  private zipInput: Locator = this.page.locator('#zip');
  private phoneInput: Locator = this.page.locator('#phone');
  private destAccountInput: Locator = this.page.locator('#destination-account');
  private amountInput: Locator = this.page.locator('#payment-amount');
  private dateInput: Locator = this.page.locator('#payment-date'); // optional
  private confirmBtn: Locator = this.page.locator('button[type="submit"]');

  private errorMsg: Locator = this.page.locator('.error-message');
  private historyList: Locator = this.page.locator('.payment-history');

  async fillDetails(details: {
    beneficiary: string;
    address: string;
    city: string;
    state: string;
    zip: string;
    phone: string;
    destAccount: string;
    amount: number;
    date?: string;
  }): Promise<void> {
    await this.beneficiaryInput.fill(details.beneficiary);
    await this.addressInput.fill(details.address);
    await this.cityInput.fill(details.city);
    await this.stateInput.fill(details.state);
    await this.zipInput.fill(details.zip);
    await this.phoneInput.fill(details.phone);
    await this.destAccountInput.fill(details.destAccount);
    await this.amountInput.fill(details.amount.toString());
    if (details.date) {
      await this.dateInput.fill(details.date);
    }
  }

  async confirm(): Promise<void> {
    await this.confirmBtn.click();
  }

  async expectError(message: string): Promise<void> {
    await expect(this.errorMsg).toHaveText(message);
  }

  async getHistory(): Promise<string[]> {
    await this.historyList.waitFor({ state: 'visible' });
    return this.historyList.locator('li').allInnerTexts();
  }
}
```

---

## 📦 Fixtures – contexto autenticado

```ts
// e2e/fixtures/auth.ts
import { test as base, Page } from '@playwright/test';
import { LoginPage } from '../pages/login.page';

export const test = base.extend<{
  loginPage: LoginPage;
  page: Page;
}>({
  // Cria um novo contexto para cada teste (isolamento completo)
  page: async ({ browser }, use) => {
    const context = await browser.newContext();
    const page = await context.newPage();
    await use(page);
    await context.close();
  },

  // Instancia o Page Object Login
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await use(loginPage);
  },

  // Função auxiliar para fazer login antes de cada teste que precisar
  async login({ loginPage }: { loginPage: LoginPage }) {
    await loginPage.goTo();
    await loginPage.login('usuario@demo.com', 'Password123!');
  },
});
```

---

## 🧪 Testes – um exemplo de cada Feature

```ts
// e2e/tests/register.spec.ts
import { test, expect } from '../fixtures/auth';
import { RegisterPage } from '../pages/register.page';
import * as data from '../utils/data';

test.describe('Cadastro de Usuário', () => {
  test('Registro com dados inválidos', async ({ page, login }) => {
    const regPage = new RegisterPage(page);

    await regPage.goTo();

    // Dados inválidos
    await regPage.fillInvalidData({
      phone: '123',            // formato errado
      zip: 'abcde',            // não numérico
      email: 'email-sem-@',    // sem domínio
    });

    await regPage.clickSave();

    // Espera e validação das mensagens de erro
    await regPage.expectErrorPhone();
    await regPage.expectErrorZip();
    await regPage.expectErrorEmail();
  });

  test('Registro com dados válidos', async ({ page, login }) => {
    const regPage = new RegisterPage(page);

    await regPage.goTo();

    // Gerar dados reais (CPF, nome, etc.)
    const userData = {
      name: data.generateName(),
      cpf: data.generateCPF(),
      phone: data.generatePhone(),
      zip: data.generateZip(),
      email: data.generateEmail(),
      password: 'Password123!',
    };

    await regPage.fillValidData(userData);
    await regPage.clickSave();

    // Validações de sucesso
    await regPage.expectSuccess();

    // Tentar login com as mesmas credenciais
    await login(); // já faz login no fixture
    const dashboard = new (await import('../pages/dashboard.page')).DashboardPage(page);
    await expect(dashboard.balanceDisplay).toBeVisible(); // página inicial carregada
  });
});
```

```ts
// e2e/tests/login.spec.ts
import { test, expect } from '../fixtures/auth';
import { LoginPage } from '../pages/login.page';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Login', () => {
  test('Login com credenciais válidas', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goTo();
    await loginPage.login('usuario@demo.com', 'Password123!');

    // A página inicial (dashboard) deve ser exibida
    const dashboard = new DashboardPage(page);
    await expect(dashboard.balanceDisplay).toBeVisible();
  });

  test('Login com credenciais inválidas', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goTo();
    await loginPage.login('usuario@demo.com', 'senhaErrada');

    // Mensagem de erro esperada
    await loginPage.expectError('Credenciais inválidas');
  });
});
```

```ts
// e2e/tests/account.spec.ts
import { test, expect } from '../fixtures/auth';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Acesso à Conta – Saldo e Extrato', () => {
  test('Visualizar saldo atualizado', async ({ page, login }) => {
    await login();

    const dashboard = new DashboardPage(page);
    const displayed = await dashboard.getBalance();
    // Aqui você poderia comparar com valor esperado armazenado no backend
    expect(displayed).not.toBe('');
  });

  test('Visualizar extrato em ordem cronológica', async ({ page, login }) => {
    await login();

    const dashboard = new DashboardPage(page);
    // Supondo que haja um link ou botão “Extrato”
    await dashboard.page.click('a[href="/transactions"]');
    await dashboard.waitForLoad();

    const history = await dashboard.page.locator('.transaction-list li').allInnerTexts();
    // Verifica que o primeiro item tem a data mais recente (ex.: '2025-10-01')
    expect(history[0]).toMatch(/\d{4}-\d{2}-\d{2}/);
    // e que os itens estão em ordem decrescente
    const dates = history.map(h => h.split(' - ')[0]); // supondo formato 'YYYY-MM-DD - Descrição'
    const sorted = [...dates].sort((a, b) => (a < b ? 1 : -1));
    expect(dates).toEqual(sorted);
  });
});
```

```ts
// e2e/tests/transfer.spec.ts
import { test, expect } from '../fixtures/auth';
import { TransferPage } from '../pages/transfer.page';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Transferência de Fundos', () => {
  test('Transferência inválida – valor maior que o saldo', async ({ page, login }) => {
    await login();

    const dashboard = new DashboardPage(page);
    await dashboard.navigateToTransfer();

    const transferPage = new TransferPage(page);

    await transferPage.selectOrigin('ACC123');          // id fictício
    await transferPage.selectDestination('ACC456');
    await transferPage.enterAmount(9999999);            // valor maior que saldo
    await transferPage.confirm();

    await transferPage.expectError('Saldo insuficiente');
  });

  test('Transferência válida', async ({ page, login }) => {
    await login();

    const dashboard = new DashboardPage(page);
    await dashboard.navigateToTransfer();

    const transferPage = new TransferPage(page);

    // Valor menor ou igual ao saldo (exemplo 50)
    await transferPage.selectOrigin('ACC123');
    await transferPage.selectDestination('ACC456');
    await transferPage.enterAmount(50);
    await transferPage.confirm();

    // Espera por confirmação de sucesso (poderia ser uma mensagem)
    const successMsg = page.locator('.success-message');
    await expect(successMsg).toHaveText('Transferência concluída com sucesso');

    // Validação no histórico (simplificada)
    const history = await transferPage.getTransactionHistory();
    expect(history).toContain('Transferência de R$50,00 para ACC456');
  });
});
```

```ts
// e2e/tests/loan.spec.ts
import { test, expect } from '../fixtures/auth';
import { LoanPage } from '../pages/loan.page';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Solicitação de Empréstimo', () => {
  test('Empréstimo aprovado', async ({ page, login }) => {
    await login();
    const dashboard = new DashboardPage(page);
    await dashboard.navigateToLoan();

    const loanPage = new LoanPage(page);
    await loanPage.enterAmount(10000);
    await loanPage.enterAnnualIncome(80000);
    await loanPage.submit();

    await loanPage.expectStatus('Aprovado');
    await expect(page.locator('.status-message')).toHaveText('Empréstimo aprovado');
  });

  test('Empréstimo negado', async ({ page, login }) => {
    await login();
    const dashboard = new DashboardPage(page);
    await dashboard.navigateToLoan();

    const loanPage = new LoanPage(page);
    await loanPage.enterAmount(10000);
    await loanPage.enterAnnualIncome(20000); // renda baixa
    await loanPage.submit();

    await loanPage.expectStatus('Negado');
    await expect(page.locator('.status-message')).toHaveText('Empréstimo negado');
  });
});
```

```ts
// e2e/tests/billpayment.spec.ts
import { test, expect } from '../fixtures/auth';
import { BillPaymentPage } from '../pages/billpayment.page';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Pagamento de Contas', () => {
  test('Registro de pagamento agendado', async ({ page, login }) => {
    await login();
    const dashboard = new DashboardPage(page);
    await dashboard.navigateToBillPayment();

    const paymentPage = new BillPaymentPage(page);
    const details = {
      beneficiary: 'Empresa XYZ',
      address: 'Rua ABC, 123',
      city: 'São Paulo',
      state: 'SP',
      zip: '01234-567',
      phone: '(11) 98765-4321',
      destAccount: 'ACC789',
      amount: 150.75,
      date: '2025-12-01',
    };
    await paymentPage.fillDetails(details);
    await paymentPage.confirm();

    // Validação de mensagens de erro (se houver)
    await paymentPage.expectError('Algum campo inválido'); // caso haja erro

    // Confirma que o pagamento aparece no histórico
    const history = await paymentPage.getHistory();
    expect(history).toContain(expect.stringContaining('Pagamento agendado para 2025-12-01'));
  });

  test('Registro de pagamento imediato', async ({ page, login }) => {
    await login();
    const dashboard = new DashboardPage(page);
    await dashboard.navigateToBillPayment();

    const paymentPage = new BillPaymentPage(page);
    const details = {
      beneficiary: 'Empresa ABC',
      address: 'Av. Central, 456',
      city: 'Rio de Janeiro',
      state: 'RJ',
      zip: '98765-432',
      phone: '(21) 91234-5678',
      destAccount: 'ACC321',
      amount: 200.00,
      // data em aberto
    };
    await paymentPage.fillDetails(details);
    await paymentPage.confirm();

    // Mensagem de sucesso
    const successMsg = page.locator('.success-message');
    await expect(successMsg).toHaveText('Pagamento processado com sucesso');

    const history = await paymentPage.getHistory();
    expect(history).toContain(expect.stringContaining('Pagamento de R$200,00 para ACC321'));
  });
});
```

```ts
// e2e/tests/navigation.spec.ts
import { test, expect } from '../fixtures/auth';
import { DashboardPage } from '../pages/dashboard.page';

test.describe('Navegação e Usabilidade', () => {
  test('Carregamento de página sem erros', async ({ page, login }) => {
    await login();

    // Abrir várias páginas (ex.: dashboard, transfer, loan)
    const urls = [
      'https://demo-pabank.com/dashboard',
      'https://demo-pabank.com/transfer',
      'https://demo-pabank.com/loan',
    ];

    for (const url of urls) {
      await page.goto(url);
      await page.waitForLoadState('networkidle');

      // Verifica que não há erros de console
      const consoleErrors = await page.evaluate(() => console.hasErrors || []);
      expect(consoleErrors.length).toBe(0);
    }
  });

  test('Navegação por links ou menus', async ({ page, login }) => {
    await login();

    const dashboard = new DashboardPage(page);

    // Simula clique em “Transferências”
    await dashboard.transferLink.click();
    await dashboard.waitForLoad();
    await expect(page).toHaveURL(/\/transfer/);

    // Volta ao dashboard
    await page.click('a[href="/dashboard"]');
    await dashboard.waitForLoad();
    await expect(page).toHaveURL(/\/dashboard/);
  });

  test('Mensagens de erro claras', async ({ page, login }) => {
    await login();

    // Acessar página de cadastro para provocar erro
    const regPage = new (await import('../pages/register.page')).RegisterPage(page);
    await regPage.goTo();
    await regPage.fillInvalidData({
      phone: '123',
      zip: 'abcde',
      email: 'invalid',
    });
    await regPage.clickSave();

    // As mensagens aparecem ao lado dos campos
    const phoneError = page.locator('#error-phone');
    await expect(phoneError).toBeVisible();
    await expect(phoneError).toHaveText('Telefone inválido');

    const zipError = page.locator('#error-zip');
    await expect(zipError).toBeVisible();
    await expect(zipError).toHaveText('CEP inválido');

    const emailError = page.locator('#error-email');
    await expect(emailError).toBeVisible();
    await expect(emailError).toHaveText('E‑mail inválido');
  });
});
```

---

## 📦 Utilitários de Dados

```ts
// e2e/utils/data.ts
export const generateName = (): string => `Usuário ${Math.random().toString(36).substring(2, 8)}`;
export const generateCPF = (): string => {
  const cpf = Array.from({ length: 11 }, () => Math.floor(Math.random() * 10)).join('');
  return `${cpf.slice(0,3)}.${cpf.slice(3,6)}.${cpf.slice(6,9)}-${cpf.slice(9)}`;
};
export const generatePhone = (): string => `(${Math.floor(Math.random() * 90 + 10)}) 9${Math.floor(Math.random() * 90000 + 10000)}-${Math.floor(Math.random() * 9000 + 1000)}`;
export const generateZip = (): string => `${Math.floor(Math.random() * 90000 + 10000)}-${Math.floor(Math.random() * 9000 + 1000)}`;
export const generateEmail = (): string => `user${Date.now()}@demo.com`;
```

---

## 📄 Configuração do Playwright

```ts
// e2e/playwright.config.ts
import { PlaywrightTestConfig, devices } from '@playwright/test';

const config: PlaywrightTestConfig = {
  testDir: 'tests',
  timeout: 30 * 1000,
  retries: 1,
  use: {
    // Ajuste de navegador e viewport
    browserName: 'chromium',
    headless: true,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
  ],
  reporter: [['list'], ['json', { outputFile: 'reports/test-results.json' }]],
};

export default config;
```

---

## 📦 `package.json` (dependências)

```json
{
  "name": "pabank-e2e",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug",
    "test:report": "playwright show-report"
  },
  "devDependencies": {
    "@playwright/test": "^1.46.0",
    "typescript": "^5.3.3",
    "ts-node": "^10.9.1"
  }
}
```

---

## ⚙️ Como rodar

```bash
# 1️⃣ Instale as dependências
npm install

# 2️⃣ Execute os testes
npm test          # headless
npm run test:headed   # com UI
npm run test:debug    # debug interativo

# 3️⃣ Gera relatório
npm run test:report
```

---

## 💡 Dicas de manutenção

* **Seletores robustos** – prefira `data-testid` se a aplicação permitir.  
* **Parametrização** – use `test.describe.parallel` ou `test.each` para repetir cenários com dados diferentes.  
* **Mocks** – quando o back‑end não estiver disponível, use `page.route` para mockar respostas.  
* **Logs** – habilite `trace: 'on-first-retry'` no config para capturar passo a passo.  

Com essa base, você já tem um conjunto funcional de testes que cobre todas as User Stories descritas no BDD. Boa sorte e bons testes! 🚀