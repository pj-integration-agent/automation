## 1️⃣ Estrutura do Projeto

```
.
├── package.json
├── playwright.config.ts          ← config do Playwright Test Runner
├── tsconfig.json
├── tests
│   ├── cadastro.spec.ts
│   ├── login.spec.ts
│   ├── account-access.spec.ts
│   ├── transfer.spec.ts
│   ├── loan.spec.ts
│   ├── payment.spec.ts
│   └── navigation.spec.ts
├── pages
│   ├── CadastroPage.ts
│   ├── LoginPage.ts
│   ├── DashboardPage.ts
│   ├── TransferPage.ts
│   ├── LoanPage.ts
│   ├── PaymentPage.ts
│   └── NavigationPage.ts
└── utils
    ├── testData.ts
    └── helpers.ts
```

> ⚙️ **Obs.:**  
> • O projeto está em **TypeScript** – é necessário `ts-node` ou compilar antes de rodar.  
> • Os *selectors* são baseados em `data-testid` – adapte‑os se a aplicação usar outro padrão.  
> • Para email de confirmação, o teste usa um mock de API (`/api/mail/verify`) – substitua pelo endpoint real ou por um serviço de mock (e.g. MailHog).

---

## 2️⃣ `playwright.config.ts`

```ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: 'tests',
  timeout: 60 * 1000,
  retries: 0,
  use: {
    // Browser padrão
    baseURL: 'https://localhost:3000',
    headless: true,
    viewport: { width: 1280, height: 720 },
    // Espera padrão
    waitUntil: 'networkidle',
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
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
```

---

## 3️⃣ Page Objects (exemplo: `CadastroPage.ts`)

```ts
import { Page, Locator } from '@playwright/test';

/**
 * Page Object responsável pelo fluxo de cadastro
 */
export class CadastroPage {
  readonly page: Page;
  readonly inputNome: Locator;
  readonly inputCPF: Locator;
  readonly inputEndereco: Locator;
  readonly inputTelefone: Locator;
  readonly inputCEP: Locator;
  readonly inputEmail: Locator;
  readonly inputSenha: Locator;
  readonly inputConfirmacao: Locator;
  readonly btnCadastrar: Locator;
  readonly bannerSucesso: Locator;
  readonly msgErroCPF: Locator;
  readonly msgErroEmail: Locator;

  constructor(page: Page) {
    this.page = page;
    this.inputNome        = page.locator('[data-testid="input-nome"]');
    this.inputCPF         = page.locator('[data-testid="input-cpf"]');
    this.inputEndereco    = page.locator('[data-testid="input-endereco"]');
    this.inputTelefone    = page.locator('[data-testid="input-telefone"]');
    this.inputCEP         = page.locator('[data-testid="input-cep"]');
    this.inputEmail       = page.locator('[data-testid="input-email"]');
    this.inputSenha       = page.locator('[data-testid="input-senha"]');
    this.inputConfirmacao = page.locator('[data-testid="input-confirmacao"]');
    this.btnCadastrar     = page.locator('[data-testid="btn-cadastrar"]');
    this.bannerSucesso    = page.locator('[data-testid="banner-sucesso"]');
    this.msgErroCPF       = page.locator('[data-testid="erro-cpf"]');
    this.msgErroEmail     = page.locator('[data-testid="erro-email"]');
  }

  /** Navega até a página de cadastro */
  async open() {
    await this.page.goto('/cadastro');
    await this.page.waitForLoadState('networkidle');
  }

  /** Preenche os campos com os dados recebidos */
  async fillForm(data: { [key: string]: string }) {
    const mapping: { [key: string]: Locator } = {
      'Nome': this.inputNome,
      'CPF': this.inputCPF,
      'Endereço': this.inputEndereco,
      'Telefone': this.inputTelefone,
      'CEP': this.inputCEP,
      'E‑mail': this.inputEmail,
      'Senha': this.inputSenha,
      'Confirmação': this.inputConfirmacao,
    };

    for (const [field, value] of Object.entries(data)) {
      const locator = mapping[field];
      if (!locator) throw new Error(`Campo ${field} não mapeado`);
      await locator.fill(value);
    }
  }

  /** Clica no botão “Cadastrar” */
  async submit() {
    await this.btnCadastrar.click();
  }

  /** Valida a mensagem de sucesso */
  async expectSuccess() {
    await this.bannerSucesso.waitFor({ state: 'visible', timeout: 5000 });
    await expect(this.bannerSucesso).toHaveText(/Cadastro concluído com sucesso!/i);
  }

  /** Valida a mensagem de erro de CPF */
  async expectErroCPF(message: string) {
    await this.msgErroCPF.waitFor({ state: 'visible', timeout: 5000 });
    await expect(this.msgErroCPF).toHaveText(message);
  }

  /** Valida a mensagem de erro de E‑mail */
  async expectErroEmail(message: string) {
    await this.msgErroEmail.waitFor({ state: 'visible', timeout: 5000 });
    await expect(this.msgErroEmail).toHaveText(message);
  }
}
```

> 🔁 **Repetição**: Os demais *Page Objects* seguem a mesma lógica – mapeiam os *selectors* e encapsulam ações comuns (login, navegação, etc.).

---

## 4️⃣ Fixtures – login já realizado (`utils/helpers.ts`)

```ts
import { Page, test as base } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { CadastroPage } from '../pages/CadastroPage';
import { DashboardPage } from '../pages/DashboardPage';

export const test = base.extend<{
  loginPage: LoginPage;
  cadastroPage: CadastroPage;
  dashboardPage: DashboardPage;
}>({
  loginPage: async ({ page }, use) => {
    const pageObj = new LoginPage(page);
    await use(pageObj);
  },
  cadastroPage: async ({ page }, use) => {
    await use(new CadastroPage(page));
  },
  dashboardPage: async ({ page }, use) => {
    await use(new DashboardPage(page));
  },
});

/**
 * Função auxiliar que faz login automaticamente
 * @param page
 * @param cpf
 * @param senha
 */
export async function login(page: Page, cpf: string, senha: string) {
  const login = new LoginPage(page);
  await login.open();
  await login.enterCPF(cpf);
  await login.enterSenha(senha);
  await login.submit();
  // Aguardamos a tela de dashboard para garantir que o login foi concluído
  await page.waitForURL('/dashboard', { timeout: 5000 });
}
```

---

## 5️⃣ Testes – Gherkin convertido

### 5.1 `cadastro.spec.ts`

```ts
import { test, expect } from '../utils/helpers';
import { CadastroPage } from '../pages/CadastroPage';
import { testData } from '../utils/testData';

test.describe('Cadastro de Usuário', () => {
  // =====  Positive: Cadastro completo =====
  test('Usuário preenche cadastro completo com dados válidos', async ({ cadastroPage }) => {
    await cadastroPage.open();
    await cadastroPage.fillForm({
      'Nome': 'João da Silva',
      'CPF': '12345678901',
      'Endereço': 'Rua das Flores, 123',
      'Telefone': '(11)98765-4321',
      'CEP': '12345678',
      'E‑mail': 'joao.silva@email.com',
      'Senha': 'MinhaSenha!123',
      'Confirmação': 'MinhaSenha!123',
    });
    await cadastroPage.submit();
    await cadastroPage.expectSuccess();
  });

  // =====  Negative: CPF vazio =====
  test('Usuário deixa um campo obrigatório vazio – CPF', async ({ cadastroPage }) => {
    await cadastroPage.open();
    await cadastroPage.fillForm({
      'Nome': 'Maria Oliveira',
      'CPF': '', // vazio intencional
      'Endereço': 'Av. Central, 456',
      'Telefone': '(11)98765-4321',
      'CEP': '12345678',
      'E‑mail': 'maria.oliveira@email.com',
      'Senha': 'Segura123!',
      'Confirmação': 'Segura123!',
    });
    await cadastroPage.submit();
    await cadastroPage.expectErroCPF('O campo CPF é obrigatório');
  });

  // =====  Negative: Formato inválido – Scenario Outline =====
  const invalidData = [
    {
      cpf: '123',
      telefone: '11-987654321',
      cep: '1234',
      email: 'joao.silva',
      mensagem: 'O campo CPF deve conter 11 dígitos',
    },
    {
      cpf: '12345678901',
      telefone: '(11)987654321',
      cep: '1234567',
      email: 'joao.silva@email',
      mensagem: 'O campo Telefone deve ter o formato (xx)xxxxx‑xxxx',
    },
    {
      cpf: '12345678901',
      telefone: '(11)987654321',
      cep: '1234567',
      email: 'joao.silva@email.com',
      mensagem: 'O campo CEP deve conter 8 dígitos',
    },
    {
      cpf: '12345678901',
      telefone: '(11)987654321',
      cep: '12345678',
      email: 'joao.silva',
      mensagem: 'O campo E‑mail deve ter um endereço válido',
    },
  ];

  test.each(invalidData)(
    'Validação de formatos de campos inválidos – $mensagem',
    async ({ cadastroPage, cpf, telefone, cep, email, mensagem }) => {
      await cadastroPage.open();
      await cadastroPage.fillForm({
        'Nome': 'Maria Oliveira',
        'CPF': cpf,
        'Endereço': 'Av. Central, 456',
        'Telefone': telefone,
        'CEP': cep,
        'E‑mail': email,
        'Senha': 'Segura123!',
        'Confirmação': 'Segura123!',
      });
      await cadastroPage.submit();

      // Dependendo do campo inválido, a mensagem aparece em um local específico
      if (mensagem.includes('CPF')) await cadastroPage.expectErroCPF(mensagem);
      else if (mensagem.includes('E‑mail')) await cadastroPage.expectErroEmail(mensagem);
      else await expect(page.locator('[data-testid="erro-geral"]').innerText()).resolves.toContain(mensagem);
    }
  );

  // =====  Positive: Email de confirmação =====
  test('Usuário recebe e‑mail de confirmação após cadastro', async ({ page }) => {
    await page.goto('/cadastro');
    await page.fill('[data-testid="input-email"]', 'joao.silva@email.com');
    // ...preencher demais campos com dados válidos
    await page.click('[data-testid="btn-cadastrar"]');
    // Mock de endpoint de email
    await page.waitForResponse('**/api/mail/verify', { timeout: 7000 });
    // Aguardamos a presença do link de validação no corpo do email
    const mailBody = await page.textContent('[data-testid="mail-body"]');
    expect(mailBody).toContain('link de validação');
  });
});
```

> ⚠️ **Observação:**  
> • O teste de email de confirmação assume um mock de endpoint. Se a aplicação enviar um e‑mail real, use um serviço de mock (ex.: MailHog) e adapte o seletor do corpo do e‑mail.  
> • A validação do banner de sucesso usa `expect(page.locator(...)).toHaveText()` – garante que a mensagem aparece e está visível.

---

### 5.2 `login.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';

test.describe('Login', () => {
  test('Usuário entra com CPF e senha corretos', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await expect(page).toHaveURL('/dashboard');
  });

  test('Usuário entra com senha inválida', async ({ page }) => {
    await login(page, '12345678901', 'SenhaErrada');
    await expect(page.locator('[data-testid="msg-erro-login"]')).toHaveText('CPF ou senha inválidos.');
  });

  test('Usuário entra com CPF inválido', async ({ page }) => {
    await login(page, '11111111111', 'MinhaSenha!123');
    await expect(page.locator('[data-testid="msg-erro-login"]')).toHaveText('CPF ou senha inválidos.');
  });

  test('Usuário excede tentativas de login', async ({ page }) => {
    for (let i = 0; i < 5; i++) {
      await login(page, '12345678901', 'SenhaErrada');
    }
    await expect(page.locator('[data-testid="msg-erro-login"]')).toHaveText('Tentativas excedidas. Aguarde 5 min.');
  });
});
```

---

### 5.3 `account-access.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';
import { DashboardPage } from '../pages/DashboardPage';
import { testData } from '../utils/testData';

test.describe('Acesso à Conta – Saldo e Extrato', () => {
  test('Usuário visualiza saldo após operação de depósito', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    const dashboard = new DashboardPage(page);

    // Simular depósito via API (mock)
    await page.request.post('/api/conta/depositar', {
      data: { valor: 1000.0 },
    });

    await dashboard.navigateToSaldo();
    await expect(dashboard.balanço).toHaveText('R$ 1.000,00');
  });

  test('Usuário visualiza extrato em ordem cronológica', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    const dashboard = new DashboardPage(page);

    // Inserir 12 transações via API (mock)
    for (let i = 0; i < 12; i++) {
      await page.request.post('/api/conta/transferir', {
        data: {
          destino: '987654321',
          valor: 50.0,
          data: new Date(Date.now() - i * 86400000).toISOString(),
        },
      });
    }

    await dashboard.navigateToExtrato();
    const linhas = await dashboard.getExtratoRows();
    expect(linhas.length).toBeGreaterThanOrEqual(10);

    // Verifica ordem descendente
    for (let i = 0; i < linhas.length - 1; i++) {
      const dataAtual = new Date(await linhas[i].data.innerText());
      const dataProx = new Date(await linhas[i + 1].data.innerText());
      expect(dataAtual.getTime()).toBeGreaterThanOrEqual(dataProx.getTime());
    }

    // Verifica que cada linha contém todos os campos
    for (const row of linhas) {
      await expect(row.data).toBeVisible();
      await expect(row.descricao).toBeVisible();
      await expect(row.tipo).toBeVisible();
      await expect(row.valor).toBeVisible();
      await expect(row.saldo).toBeVisible();
    }
  });
});
```

---

### 5.4 `transfer.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';
import { TransferPage } from '../pages/TransferPage';

test.describe('Transferência de Fundos', () => {
  test('Usuário transfere dinheiro com saldo suficiente', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    const transfer = new TransferPage(page);

    // Define saldo via API (mock)
    await page.request.post('/api/conta/definirSaldo', { data: { saldo: 5000.0 } });

    await transfer.navigateToTransferir();
    await transfer.enterTransferDetails('987654321', '1500.00');
    await transfer.confirmar();
    await expect(page.locator('[data-testid="msg-sucesso-transferencia"]')).toHaveText('Transferência concluída com sucesso');

    // Verifica saldo atualizado
    await expect(page.locator('[data-testid="saldo-atual"]')).toHaveText('R$ 3.500,00');
  });

  test('Usuário tenta transferir valor maior que o saldo', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    const transfer = new TransferPage(page);

    await page.request.post('/api/conta/definirSaldo', { data: { saldo: 2000.0 } });

    await transfer.navigateToTransferir();
    await transfer.enterTransferDetails('987654321', '3000.00');
    await transfer.confirmar();
    await expect(page.locator('[data-testid="msg-erro-saldo"]')).toHaveText('Saldo insuficiente');
  });

  test('Registro de transferência no histórico de ambas as contas', async ({ page }) => {
    const cpfOrigem = '12345678901';
    const cpfDestino = '10987654321';

    // Login como origem
    await login(page, cpfOrigem, 'MinhaSenha!123');

    // Definir saldo de origem (5.000,00)
    await page.request.post('/api/conta/definirSaldo', { data: { saldo: 5000.0 } });

    // Realizar transferência de 500,00
    const transfer = new TransferPage(page);
    await transfer.navigateToTransferir();
    await transfer.enterTransferDetails(cpfDestino, '500.00');
    await transfer.confirmar();
    await expect(page.locator('[data-testid="msg-sucesso-transferencia"]')).toHaveText('Transferência concluída com sucesso');

    // Logout e login na conta destino
    await page.click('[data-testid="btn-logout"]');
    await login(page, cpfDestino, 'MinhaSenha!123');

    // Verificar histórico do destino
    await page.click('[data-testid="link-historico"]');
    const rows = await page.locator('[data-testid="linha-historico"]').all();
    const mensagens = await Promise.all(rows.map(row => row.textContent()));
    const temEntradaOrigem = mensagens.some(text => text.includes(`Transferência de ${cpfOrigem}`));
    const temEntradaDestino = mensagens.some(text => text.includes(`Transferência de ${cpfDestino}`));
    expect(temEntradaOrigem).toBeTruthy();
    expect(temEntradaDestino).toBeTruthy();
  });
});
```

---

### 5.5 `loan.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';

test.describe('Solicitação de Empréstimo', () => {
  test('Usuário solicita empréstimo aprovado', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await page.click('[data-testid="link-emprestimo"]');

    await page.fill('[data-testid="input-valor"]', '20000.00');
    await page.fill('[data-testid="input-renda"]', '120000.00');
    await page.click('[data-testid="btn-solicitar"]');

    await expect(page.locator('[data-testid="status-emprestimo"]')).toHaveText('Aprovado', { timeout: 2000 });
    await expect(page.locator('[data-testid="termos"]')).toBeVisible();
  });

  test('Usuário solicita empréstimo negado por renda insuficiente', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await page.click('[data-testid="link-emprestimo"]');

    await page.fill('[data-testid="input-valor"]', '50000.00');
    await page.fill('[data-testid="input-renda"]', '30000.00');
    await page.click('[data-testid="btn-solicitar"]');

    await expect(page.locator('[data-testid="status-emprestimo"]')).toHaveText('Negado', { timeout: 2000 });
    await expect(page.locator('[data-testid="motivo-rejeicao"]')).toHaveText('Renda insuficiente');
  });
});
```

---

### 5.6 `payment.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';

test.describe('Pagamento de Contas', () => {
  test('Usuário agenda pagamento futuro', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await page.click('[data-testid="link-pagamentos"]');

    const dia = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).getDate(); // 25º dia do próximo mês
    const mes = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).getMonth() + 1;

    await page.fill('[data-testid="input-conta"]', 'Conta X');
    await page.fill('[data-testid="input-valor"]', '200.00');
    await page.fill('[data-testid="input-data"]', `${dia}/${mes}/${new Date().getFullYear() + 1}`);
    await page.click('[data-testid="btn-agendar"]');

    await expect(page.locator('[data-testid="list-pagamentos"]').locator(`text=Conta X 200,00 ${dia}/${mes}`)).toBeVisible();
  });

  test('Usuário tenta agendar pagamento em dia passado', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await page.click('[data-testid="link-pagamentos"]');

    const diaPassado = new Date(Date.now() - 24 * 60 * 60 * 1000).getDate();
    const mesPassado = new Date(Date.now() - 24 * 60 * 60 * 1000).getMonth() + 1;

    await page.fill('[data-testid="input-conta"]', 'Conta Y');
    await page.fill('[data-testid="input-valor"]', '150.00');
    await page.fill('[data-testid="input-data"]', `${diaPassado}/${mesPassado}/${new Date().getFullYear()}`);
    await page.click('[data-testid="btn-agendar"]');

    await expect(page.locator('[data-testid="msg-erro-pagamento"]')).toHaveText('A data de pagamento deve ser futura');
  });
});
```

---

### 5.7 `navigation.spec.ts`

```ts
import { test, expect, login } from '../utils/helpers';

test.describe('Navegação e Usabilidade', () => {
  test('Usuário acessa rota inexistente e recebe página 404', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');
    await page.goto('/caminho/invalido');
    await expect(page.locator('[data-testid="404-title"]')).toHaveText('Erro 404 – Página não encontrada');
  });

  test('Mensagens de erro aparecem localizadas e claras – Cadastro com e‑mail inválido', async ({ page }) => {
    await page.goto('/cadastro');
    await page.fill('[data-testid="input-email"]', 'email-sem-domínio');
    await page.click('[data-testid="btn-cadastrar"]');
    await expect(page.locator('[data-testid="erro-email"]').nth(0)).toHaveText('O campo E‑mail deve ter um endereço válido');
  });

  test('Menus e links são consistentes em todas as páginas', async ({ page }) => {
    await login(page, '12345678901', 'MinhaSenha!123');

    const pages = ['dashboard', 'transferir', 'emprestimo', 'pagamentos', 'logout'];
    const menuItems = ['Dashboard', 'Transferir', 'Empréstimo', 'Pagamentos', 'Logout'];

    for (const [index, p] of pages.entries()) {
      await page.click(`[data-testid="nav-${p}"]`);
      await expect(page.locator('[data-testid="top-menu"]').locator(`text=${menuItems[index]}`)).toBeVisible();
    }

    // Verificar responsividade – viewport mobile
    await page.setViewportSize({ width: 375, height: 812 }); // iPhone X
    await expect(page.locator('[data-testid="top-menu"]')).toHaveClass(/mobile/);
  });
});
```

---

## 6️⃣ Dados de Teste – `utils/testData.ts`

```ts
export const userValid = {
  nome: 'João da Silva',
  cpf: '12345678901',
  endereco: 'Rua das Flores, 123',
  telefone: '(11)98765-4321',
  cep: '12345678',
  email: 'joao.silva@email.com',
  senha: 'MinhaSenha!123',
};

export const userInvalidEmail = {
  ...userValid,
  email: 'invalid-email',
};

export const userMissingCPF = {
  ...userValid,
  cpf: '',
};
```

---

## 7️⃣ Dependências (package.json)

```json
{
  "name": "parabank-automation",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test": "playwright test",
    "test:headed": "playwright test --headed",
    "test:debug": "playwright test --debug"
  },
  "devDependencies": {
    "@playwright/test": "^1.48.0",
    "typescript": "^5.4.5",
    "ts-node": "^10.9.1"
  }
}
```

> 🚀 **Para rodar:**  
> 1. Instale as dependências: `npm install`  
> 2. Execute os testes: `npm test`  
> 3. Para debug: `npm run test:debug` – abre o navegador com visualização.

---

## 8️⃣ Boas Práticas Evidenciadas

| Prática | Por que é importante? | Onde foi aplicada |
|---------|------------------------|-------------------|
| **Page Objects** | Isolamento de locators → manutenção mais simples | Todos os testes |
| **Selectors `data-testid`** | Evita que alterações visuais quebrem os testes | Todos os locators |
| **`waitFor`** | Garantia de que elementos estão visíveis antes de interagir | `.waitFor({ state: 'visible', timeout: 5000 })` |
| **`test.each`** (ou `it.each`) | Reduz repetição de código em cenários similares | Validações de formato inválido |
| **Timeouts explícitos** | Evita flakiness quando o servidor demora | `.expect(..., { timeout: 2000 })` |
| **Mocking de API** | Testes isolados de backend | `page.request.post('/api/...')` |
| **Comentários detalhados** | Facilita leitura e manutenção | Comentários em cada passo |
| **Config de viewport e dispositivos** | Garante responsividade | `devices` no Playwright config |

---

## 9️⃣ Próximos Passos

1. **Mapear os `data-testid` reais** – substituir pelos atributos corretos.  
2. **Implementar mocks** (ex.: MailHog) para e‑mail e endpoints de saldo/transferência.  
3. **Adicionar testes de performance** (por exemplo, tempo de carregamento de dashboard).  
4. **CI/CD** – integrar os testes na pipeline (GitHub Actions, GitLab CI, etc.).  

Com essa base, você já tem uma suite de testes robusta, organizada e alinhada às práticas recomendadas do Playwright. Boa sorte na automação! 🚀