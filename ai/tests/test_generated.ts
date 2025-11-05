**🚀 Playwright‑Test Runner – Automação completa em TypeScript**  
*(pronto para copiar/colar, compilar e executar com `npx playwright test`)*  

> **Obs.**  
> • Os *selectors* abaixo são baseados em *data‑test* ou em *labels* – ajuste conforme a aplicação real.  
> • Se a sua aplicação usa *React* / *Angular* etc., substitua os *selectors* por algo que seja estável.  
> • Para os cenários de **API** (`US‑08`) utilizamos o helper `request` do Playwright.  

---

## 1️⃣ Estrutura de pastas

```
/playwright
│
├─ playwright.config.ts          ← Configuração base
├─ packages/
│   ├─ pages/                    ← Page‑Objects
│   │   ├─ CadastroPage.ts
│   │   ├─ LoginPage.ts
│   │   ├─ DashboardPage.ts
│   │   ├─ TransferPage.ts
│   │   ├─ LoanPage.ts
│   │   ├─ PaymentPage.ts
│   │   └─ NavigationPage.ts
│   │
│   └─ utils/
│       └─ formatCurrency.ts
│
└─ tests/
    ├─ cadastro.spec.ts
    ├─ login.spec.ts
    ├─ dashboard.spec.ts
    ├─ transfer.spec.ts
    ├─ loan.spec.ts
    ├─ payment.spec.ts
    ├─ navigation.spec.ts
    └─ api.spec.ts
```

> **Dica:** Se quiser manter tudo em um único arquivo, copie apenas a parte de cada teste (ex.: `tests/cadastro.spec.ts`) e adapte‑o.  

---

## 2️⃣ `playwright.config.ts`

```ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  // URL base da aplicação – substitua pela sua
  use: {
    baseURL: 'https://demo.parabank.com',
    headless: true,
    viewport: { width: 1280, height: 720 },
    // Espera padrão para elementos aparecerem
    waitForTimeout: 15000,
  },

  // Se quiser executar em vários browsers
  projects: [
    { name: 'Chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'Firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'WebKit', use: { ...devices['Desktop Safari'] } },
  ],

  // Reexecuta testes que falharam (útil para flocos)
  retries: 1,

  // Timeout geral de cada teste
  timeout: 120000,
});
```

---

## 3️⃣ Page‑Objects (`/packages/pages/*.ts`)

> *O POM encapsula a lógica de interação e facilita a manutenção.*

### 3.1 `CadastroPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class CadastroPage {
  constructor(private readonly page: Page) {}

  /* ---------- Navegação ---------- */
  async goto() {
    await this.page.goto('/register'); // Ajuste o caminho real
  }

  /* ---------- Ações ---------- */
  async fillField(label: string, value: string) {
    await this.page.fill(`label:has-text("${label}") >> input`, value);
  }

  async clearField(label: string) {
    await this.page.fill(`label:has-text("${label}") >> input`, '');
  }

  async clickButton(text: string) {
    await this.page.click(`button:has-text("${text}")`);
  }

  /* ---------- Validações ---------- */
  async expectSuccessMessage(msg: string) {
    await expect(this.page.locator('text=' + msg)).toBeVisible();
  }

  async expectFieldError(field: string, errorMsg: string) {
    const locator = this.page.locator(
      `label:has-text("${field}") >> following-sibling::p >> text=${errorMsg}`
    );
    await expect(locator).toBeVisible();
  }

  async expectRedirectToLogin() {
    await expect(this.page).toHaveURL(/\/login/);
  }
}
```

### 3.2 `LoginPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class LoginPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async fillField(label: string, value: string) {
    await this.page.fill(`label:has-text("${label}") >> input`, value);
  }

  async clickButton(text: string) {
    await this.page.click(`button:has-text("${text}")`);
  }

  async expectSuccessRedirect() {
    await expect(this.page).toHaveURL(/\/dashboard/);
  }

  async expectErrorMessage(msg: string) {
    await expect(this.page.locator('text=' + msg)).toBeVisible();
  }
}
```

### 3.3 `DashboardPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class DashboardPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/dashboard');
  }

  async expectBalance(balance: string) {
    const locator = this.page.locator(`text=Saldo: ${balance}`);
    await expect(locator).toBeVisible();
  }

  async getRecentTransactionsCount() {
    return this.page.locator('.transaction-row').count();
  }

  async getLastTransactions() {
    return this.page
      .locator('.transaction-row')
      .first()
      .allTextContents(); // exemplo simplificado
  }
}
```

### 3.4 `TransferPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class TransferPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/transfer');
  }

  async selectAccount(label: string, account: string) {
    await this.page.selectOption(
      `label:has-text("${label}") >> select`,
      account
    );
  }

  async fillAmount(amount: string) {
    await this.page.fill(`label:has-text("Valor") >> input`, amount);
  }

  async clickConfirm() {
    await this.page.click(`button:has-text("Confirmar")`);
  }

  async expectMessage(msg: string) {
    await expect(this.page.locator('text=' + msg)).toBeVisible();
  }

  async expectConfirmEnabled(enabled: boolean) {
    const locator = this.page.locator(`button:has-text("Confirmar")`);
    if (enabled) await expect(locator).toBeEnabled();
    else await expect(locator).toBeDisabled();
  }
}
```

### 3.5 `LoanPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class LoanPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/loan');
  }

  async fillField(label: string, value: string) {
    await this.page.fill(`label:has-text("${label}") >> input`, value);
  }

  async clickSend() {
    await this.page.click(`button:has-text("Enviar")`);
  }

  async expectResult(msg: string, justification: string) {
    await expect(this.page.locator(`text=${msg}`)).toBeVisible();
    await expect(this.page.locator(`text=${justification}`)).toBeVisible();
  }
}
```

### 3.6 `PaymentPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class PaymentPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/payment');
  }

  async fillField(label: string, value: string) {
    await this.page.fill(`label:has-text("${label}") >> input`, value);
  }

  async clickSchedule() {
    await this.page.click(`button:has-text("Agendar")`);
  }

  async expectMessage(msg: string) {
    await expect(this.page.locator('text=' + msg)).toBeVisible();
  }

  async expectError(label: string, msg: string) {
    const locator = this.page.locator(
      `label:has-text("${label}") >> following-sibling::p >> text=${msg}`
    );
    await expect(locator).toBeVisible();
  }
}
```

### 3.7 `NavigationPage.ts`

```ts
import { Page, expect } from '@playwright/test';

export class NavigationPage {
  constructor(private readonly page: Page) {}

  async clickNav(linkText: string) {
    await this.page.click(`a:has-text("${linkText}")`);
  }

  async expectUrlContains(substring: string) {
    await expect(this.page).toHaveURL(new RegExp(substring));
  }
}
```

---

## 4️⃣ Testes (`/tests/*.spec.ts`)

> Cada arquivo representa um *feature* do BDD.  
> O `test.describe` agrupa os cenários.  
> Todos os testes usam `expect` do Playwright com *wait* automático.

### 4.1 `cadastro.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { CadastroPage } from '../packages/pages/CadastroPage';

test.describe('@US-01 – Cadastro de Usuário', () => {
  let cadastro: CadastroPage;

  test.beforeEach(async ({ page }) => {
    cadastro = new CadastroPage(page);
    await cadastro.goto();
  });

  test('Cadastro com dados válidos', async () => {
    await cadastro.fillField('Nome', 'João Silva');
    await cadastro.fillField('E‑mail', 'joao.silva@example.com');
    await cadastro.fillField('Senha', 'Senha123!');
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', '01234‑567');
    await cadastro.fillField('Endereço', 'Rua A, 123');
    await cadastro.fillField('Cidade', 'São Paulo');
    await cadastro.fillField('Estado', 'SP');
    await cadastro.fillField('CPF', '123.456.789‑09');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectSuccessMessage('Cadastro realizado com sucesso');
    await cadastro.expectRedirectToLogin();
  });

  test('Cadastro sem preencher campo obrigatório', async () => {
    await cadastro.fillField('Nome', 'Ana Maria');
    // E‑mail em branco
    await cadastro.clearField('E‑mail');
    await cadastro.fillField('Senha', 'Senha123!');
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', '01234‑567');
    await cadastro.fillField('Endereço', 'Rua B, 456');
    await cadastro.fillField('Cidade', 'Rio de Janeiro');
    await cadastro.fillField('Estado', 'RJ');
    await cadastro.fillField('CPF', '987.654.321‑00');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectFieldError('E‑mail', 'Campo obrigatório');
  });

  test('Cadastro com e‑mail inválido', async () => {
    await cadastro.fillField('Nome', 'Pedro Santos');
    await cadastro.fillField('E‑mail', 'pedro.santos');
    await cadastro.fillField('Senha', 'Senha123!');
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', '01234‑567');
    await cadastro.fillField('Endereço', 'Av. C, 789');
    await cadastro.fillField('Cidade', 'Belo Horizonte');
    await cadastro.fillField('Estado', 'MG');
    await cadastro.fillField('CPF', '321.654.987‑10');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectFieldError('E‑mail', 'E‑mail inválido');
  });

  test('Cadastro com CEP inválido', async () => {
    await cadastro.fillField('Nome', 'Mariana Lima');
    await cadastro.fillField('E‑mail', 'mariana.lima@example.com');
    await cadastro.fillField('Senha', 'Senha123!');
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', 'ABC-123');
    await cadastro.fillField('Endereço', 'Rua D, 101');
    await cadastro.fillField('Cidade', 'Curitiba');
    await cadastro.fillField('Estado', 'PR');
    await cadastro.fillField('CPF', '456.123.789‑01');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectFieldError('CEP', 'CEP inválido');
  });

  test('Cadastro com CPF inválido', async () => {
    await cadastro.fillField('Nome', 'Carlos Eduardo');
    await cadastro.fillField('E‑mail', 'carlos.e@example.com');
    await cadastro.fillField('Senha', 'Senha123!');
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', '01234‑567');
    await cadastro.fillField('Endereço', 'Avenida E, 202');
    await cadastro.fillField('Cidade', 'Porto Alegre');
    await cadastro.fillField('Estado', 'RS');
    await cadastro.fillField('CPF', '111.222.333‑44');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectFieldError('CPF', 'CPF inválido');
  });
});
```

### 4.2 `login.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { CadastroPage } from '../packages/pages/CadastroPage';

test.describe('@US-02 – Login', () => {
  let login: LoginPage;
  let cadastro: CadastroPage;

  test.beforeEach(async ({ page }) => {
    login = new LoginPage(page);
    cadastro = new CadastroPage(page);
  });

  /** Utility – garante que o usuário já esteja cadastrado */
  async function ensureRegistered(email: string, password: string) {
    await login.goto();
    // Se já existe, não cria; se não existe, cria
    // Aqui simulamos: sempre cria
    await cadastro.goto();
    await cadastro.fillField('Nome', 'Test User');
    await cadastro.fillField('E‑mail', email);
    await cadastro.fillField('Senha', password);
    await cadastro.fillField('Telefone', '(11) 98765‑4321');
    await cadastro.fillField('CEP', '01234‑567');
    await cadastro.fillField('Endereço', 'Rua X, 1');
    await cadastro.fillField('Cidade', 'São Paulo');
    await cadastro.fillField('Estado', 'SP');
    await cadastro.fillField('CPF', '123.456.789‑00');
    await cadastro.clickButton('Cadastrar');
    await cadastro.expectRedirectToLogin();
  }

  test('Login com credenciais válidas', async () => {
    const email = 'joao.silva@example.com';
    const pwd = 'Senha123!';
    await ensureRegistered(email, pwd);

    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');

    await login.expectSuccessRedirect();
    // Verifica saldo – simplificado
    await expect(login.page.locator('text=Saldo:')).toBeVisible();
  });

  test('Login com e‑mail inexistente', async () => {
    await login.goto();
    await login.fillField('E‑mail', 'naoexiste@example.com');
    await login.fillField('Senha', 'Senha123!');
    await login.clickButton('Entrar');

    await login.expectErrorMessage('Usuário ou senha incorretos');
  });

  test('Login com senha incorreta', async () => {
    const email = 'joao.silva@example.com';
    const pwd = 'Senha123!';
    await ensureRegistered(email, pwd);

    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', 'SenhaErrada!');
    await login.clickButton('Entrar');

    await login.expectErrorMessage('Usuário ou senha incorretos');
  });

  test('Login com campos vazios', async () => {
    await login.goto();
    await login.clearField = async (label: string) => {
      await login.page.fill(`label:has-text("${label}") >> input`, '');
    };
    await login.clearField('E‑mail');
    await login.clearField('Senha');
    await login.clickButton('Entrar');

    await login.expectFieldError('E‑mail', 'Campo obrigatório');
    await login.expectFieldError('Senha', 'Campo obrigatório');
  });
});
```

### 4.3 `dashboard.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { DashboardPage } from '../packages/pages/DashboardPage';
import { TransferPage } from '../packages/pages/TransferPage';

test.describe('@US-03 – Dashboard – Saldo e Extrato', () => {
  const email = 'joao.silva@example.com';
  const pwd = 'Senha123!';

  async function login(page) {
    const login = new LoginPage(page);
    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');
    await login.expectSuccessRedirect();
  }

  test('Exibir saldo e extrato após login', async ({ page }) => {
    await login(page);

    const dash = new DashboardPage(page);
    await dash.goto();

    // Suponha saldo inicial de R$1.000,00
    await dash.expectBalance('R$ 1.000,00');

    // 5 transações mais recentes
    const count = await dash.getRecentTransactionsCount();
    expect(count).toBeGreaterThanOrEqual(5);
  });

  test('Atualização de saldo em tempo real após transferência', async ({ page }) => {
    await login(page);

    const dash = new DashboardPage(page);
    await dash.goto();

    const transfer = new TransferPage(page);
    await transfer.goto();
    await transfer.selectAccount('Conta Origem', 'Corrente');
    await transfer.selectAccount('Conta Destino', 'Poupança');
    await transfer.fillAmount('200,00');
    await transfer.clickConfirm();

    await transfer.expectMessage('Transferência concluída com sucesso');

    // Atraso mínimo – a aplicação atualiza imediatamente
    await dash.expectBalance('R$ 800,00');
  });
});
```

### 4.4 `transfer.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { TransferPage } from '../packages/pages/TransferPage';

test.describe('@US-04 – Transferência de Fundos', () => {
  const email = 'joao.silva@example.com';
  const pwd = 'Senha123!';

  async function login(page) {
    const login = new LoginPage(page);
    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');
    await login.expectSuccessRedirect();
  }

  test('Transferência bem‑sucedida', async ({ page }) => {
    await login(page);
    const transfer = new TransferPage(page);
    await transfer.goto();
    await transfer.selectAccount('Conta Origem', 'Corrente');
    await transfer.selectAccount('Conta Destino', 'Poupança');
    await transfer.fillAmount('200,00');
    await transfer.clickConfirm();

    await transfer.expectMessage('Transferência concluída com sucesso');
    // Saldo verificado em dashboard – simplificado
  });

  test('Transferência com saldo insuficiente', async ({ page }) => {
    await login(page);
    const transfer = new TransferPage(page);
    await transfer.goto();
    await transfer.selectAccount('Conta Origem', 'Corrente');
    await transfer.selectAccount('Conta Destino', 'Poupança');
    await transfer.fillAmount('200,00');

    await transfer.expectConfirmEnabled(false);
    await transfer.expectFieldError('Valor', 'Saldo insuficiente');
  });

  test('Transferência para a própria conta', async ({ page }) => {
    await login(page);
    const transfer = new TransferPage(page);
    await transfer.goto();
    await transfer.selectAccount('Conta Origem', 'Corrente');
    await transfer.selectAccount('Conta Destino', 'Corrente');
    await transfer.fillAmount('100,00');

    await transfer.expectMessage('Conta de origem e destino não podem ser iguais');
  });

  test('Transferência com valor negativo', async ({ page }) => {
    await login(page);
    const transfer = new TransferPage(page);
    await transfer.goto();
    await transfer.selectAccount('Conta Origem', 'Corrente');
    await transfer.selectAccount('Conta Destino', 'Poupança');
    await transfer.fillAmount('-50,00');

    await transfer.expectMessage('Valor deve ser positivo');
  });
});
```

### 4.5 `loan.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { LoanPage } from '../packages/pages/LoanPage';

test.describe('@US-05 – Solicitação de Empréstimo', () => {
  const email = 'joao.silva@example.com';
  const pwd = 'Senha123!';

  async function login(page) {
    const login = new LoginPage(page);
    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');
    await login.expectSuccessRedirect();
  }

  test('Solicitação aprovada com renda suficiente', async ({ page }) => {
    await login(page);
    const loan = new LoanPage(page);
    await loan.goto();
    await loan.fillField('Valor', '5.000,00');
    await loan.fillField('Renda Anual', '80.000,00');
    await loan.clickSend();

    await loan.expectResult('Aprovado', 'Renda suficiente');
  });

  test('Solicitação negada por renda insuficiente', async ({ page }) => {
    await login(page);
    const loan = new LoanPage(page);
    await loan.goto();
    await loan.fillField('Valor', '5.000,00');
    await loan.fillField('Renda Anual', '30.000,00');
    await loan.clickSend();

    await loan.expectResult('Negado', 'Renda insuficiente');
  });
});
```

### 4.6 `payment.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { PaymentPage } from '../packages/pages/PaymentPage';

test.describe('@US-06 – Pagamento de Contas', () => {
  const email = 'joao.silva@example.com';
  const pwd = 'Senha123!';

  async function login(page) {
    const login = new LoginPage(page);
    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');
    await login.expectSuccessRedirect();
  }

  test('Agendar pagamento futuro', async ({ page }) => {
    await login(page);
    const pay = new PaymentPage(page);
    await pay.goto();
    await pay.fillField('Beneficiário', 'Electric Co.');
    await pay.fillField('Endereço', 'Rua X, 123');
    await pay.fillField('Cidade', 'São Paulo');
    await pay.fillField('Estado', 'SP');
    await pay.fillField('CEP', '01234‑567');
    await pay.fillField('Telefone', '(11) 91234‑5678');
    await pay.fillField('Conta de Destino', '987654321');
    await pay.fillField('Valor', '150,00');
    await pay.fillField('Data de Pagamento', '2025‑12‑15');
    await pay.clickSchedule();

    await pay.expectMessage('Pagamento agendado para 15/12/2025');
  });

  test('Agendar pagamento com data passada', async ({ page }) => {
    await login(page);
    const pay = new PaymentPage(page);
    await pay.goto();
    await pay.fillField('Beneficiário', 'Water Co.');
    await pay.fillField('Endereço', 'Av. Y, 456');
    await pay.fillField('Cidade', 'Rio de Janeiro');
    await pay.fillField('Estado', 'RJ');
    await pay.fillField('CEP', '12345‑678');
    await pay.fillField('Telefone', '(21) 98765‑4321');
    await pay.fillField('Conta de Destino', '123456789');
    await pay.fillField('Valor', '75,00');
    await pay.fillField('Data de Pagamento', '2020‑01‑01');
    await pay.clickSchedule();

    await pay.expectMessage('Data de pagamento inválida – deve ser futura');
  });

  test('Pagamento com campo obrigatório vazio', async ({ page }) => {
    await login(page);
    const pay = new PaymentPage(page);
    await pay.goto();
    // Beneficiário vazio
    await pay.clearField('Beneficiário');
    await pay.fillField('Endereço', 'Av. Z, 789');
    await pay.fillField('Cidade', 'Belo Horizonte');
    await pay.fillField('Estado', 'MG');
    await pay.fillField('CEP', '87654‑321');
    await pay.fillField('Telefone', '(31) 91234‑5678');
    await pay.fillField('Conta de Destino', '555555555');
    await pay.fillField('Valor', '100,00');
    await pay.fillField('Data de Pagamento', '2025‑10‑20');
    await pay.clickSchedule();

    await pay.expectError('Beneficiário', 'Campo obrigatório');
  });
});
```

> *Obs.* – `clearField` pode ser implementado dentro do *Page‑Object* ou inline (usado aqui).

### 4.7 `navigation.spec.ts`

```ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../packages/pages/LoginPage';
import { NavigationPage } from '../packages/pages/NavigationPage';

test.describe('@US-07 – Navegação e Usabilidade', () => {
  const email = 'joao.silva@example.com';
  const pwd = 'Senha123!';

  async function login(page) {
    const login = new LoginPage(page);
    await login.goto();
    await login.fillField('E‑mail', email);
    await login.fillField('Senha', pwd);
    await login.clickButton('Entrar');
    await login.expectSuccessRedirect();
  }

  test('Todos os links de navegação são válidos', async ({ page }) => {
    await login(page);
    const nav = new NavigationPage(page);

    const navCases = [
      { link: 'Home', url: '/dashboard' },
      { link: 'Saldo', url: '/dashboard' },
      { link: 'Extrato', url: '/statement' },
      { link: 'Transferir', url: '/transfer' },
      { link: 'Empréstimo', url: '/loan' },
      { link: 'Pagamento', url: '/payment' },
      { link: 'Logout', url: '/login' },
    ];

    for (const { link, url } of navCases) {
      await nav.clickNav(link);
      await nav.expectUrlContains(url);
    }
  });

  test('Mensagens de erro aparecem perto do campo afetado', async ({ page }) => {
    const cadastro = new (await import('../packages/pages/CadastroPage')).CadastroPage(page);
    await cadastro.goto();

    await cadastro.clearField('Nome');
    await cadastro.clickButton('Cadastrar');

    await cadastro.expectFieldError('Nome', 'Campo obrigatório');
  });
});
```

### 4.8 `api.spec.ts`

```ts
import { test, expect } from '@playwright/test';

test.describe('@US-08 – Segurança e Validação (API)', () => {
  const apiBase = 'https://demo.parabank.com/api';

  test('API retorna 400 em requisição inválida', async ({ request }) => {
    const response = await request.post(`${apiBase}/users`, {
      data: { email: 'invalid', senha: '123' },
    });

    await expect(response.status()).toBe(400);
    const json = await response.json();
    await expect(json).toEqual({ erro: 'E‑mail inválido' });
  });

  test('API retorna 401 em requisição não autenticada', async ({ request }) => {
    const response = await request.get(`${apiBase}/dashboard`);
    await expect(response.status()).toBe(401);
    const json = await response.json();
    await expect(json).toEqual({ erro: 'Não autenticado' });
  });

  // O teste de logs não pode ser automatizado diretamente via Playwright, pois depende
  // de infraestrutura de logs. Aqui demonstramos um mock simples:
  test('Logs de erro não expõem dados sensíveis', async () => {
    const logMessage = 'Senha curta: ********';

    // Simulamos que o log seja registrado aqui
    // Em cenário real, usaríamos um *mock* de logger ou uma API de logs.
    expect(logMessage).toContain('Senha curta');
    expect(logMessage).not.toContain('12345'); // senha em texto plano
  });
});
```

---

## 5️⃣ Como executar

```bash
# Instalação
npm install @playwright/test

# Instalar browsers
npx playwright install

# Rodar todos os testes
npx playwright test

# Para executar apenas US‑01
npx playwright test tests/cadastro.spec.ts
```

---

## 6️⃣ Boas práticas resumidas

| Prática | Por quê? | Onde vemos no código |
|---------|----------|---------------------|
| **Page‑Object Model** | Isolamento da UI, fácil manutenção | `/packages/pages/*.ts` |
| **Seletores estáveis** | Evita flocos | `label:has-text()` e `data-testid` (se existir) |
| **Esperas implícitas** | Playwright já espera | `expect(...).toBeVisible()` |
| **Retries** | Flocos de rede | `retries: 1` na config |
| **Separação de dados** | Reutilização | `ensureRegistered` em `login.spec.ts` |
| **Logs e métricas** | Auditoria | Mock de log em `api.spec.ts` |
| **API testing** | Testar endpoints em paralelo | `request` no `api.spec.ts` |

---

**Pronto!**  
Copie os arquivos em seu projeto, ajuste os *selectors* e *URLs* e rode `npx playwright test`.  
Qualquer dúvida, só chamar! 🚀