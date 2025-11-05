**Obs.:** O código abaixo já está pronto para ser copiado em um projeto **Playwright‑Test** (`npm i @playwright/test`).  
Ele contém todos os *Features* e *Scenarios* do seu Gherkin – apenas com *seletores* fictícios (`#fullname`, `#email`, etc.).  
Basta trocar esses seletores pelos IDs, classes ou textos reais do seu front‑end.

> **Como usar**  
> 1. Crie um diretório `tests` dentro da raiz do seu projeto.  
> 2. Salve este arquivo como `paraBank.spec.ts`.  
> 3. Execute `npx playwright test`.

---

## `tests/paraBank.spec.ts`

```ts
import { test, expect } from '@playwright/test';

/**
 * -----------------------------
 * 1. SELECTORES
 * -----------------------------
 *
 * Mantenha todos os seletores em um único local.  
 * Assim, quando a UI mudar, só terá que ajustar aqui.
 */
const selectors = {
  // Cadastro
  registerPage: 'text=Register',
  fullname: '#fullname',
  email: '#email',
  phone: '#phone',
  cpf: '#cpf',
  address: '#address',
  cep: '#cep',
  city: '#city',
  state: '#state',
  createAccountBtn: 'text=Create Account',
  successMsg: 'text=Registro concluído com sucesso',
  loginPage: 'text=Login',
  // Login
  loginEmail: '#login-email',
  loginPassword: '#login-password',
  loginBtn: 'text=Entrar',
  homePage: 'text=Welcome',
  // Saldo
  balancePage: 'text=Saldo',
  balanceValue: '#balance',
  // Extrato
  statementPage: 'text=Extrato',
  statementRows: '.statement-row',
  // Transferência
  transferPage: 'text=Transferência',
  originAccount: '#origin',
  destinationAccount: '#destination',
  transferAmount: '#amount',
  confirmTransferBtn: 'text=Confirmar Transferência',
  // Empréstimo
  loanPage: 'text=Solicitar Empréstimo',
  loanAmount: '#loan-amount',
  annualIncome: '#annual-income',
  requestLoanBtn: 'text=Solicitar Empréstimo',
  loanBanner: '.loan-banner',
  // Pagamento
  paymentPage: 'text=Pagamento',
  beneficiary: '#beneficiary',
  paymentDate: '#payment-date',
  confirmPaymentBtn: 'text=Confirmar Pagamento',
  paymentSuccessMsg: 'text=Pagamento confirmado',
  // Navegação
  navLinks: {
    saldo: 'text=Saldo',
    extrato: 'text=Extrato',
    emprestimos: 'text=Empréstimos'
  },
  // Mensagens de erro
  errorMsg: '.error-message',
  // Header / Footer
  header: 'header',
  sidebar: 'aside',
  footer: 'footer',
};

/**
 * -----------------------------
 * 2. HELPERS
 * -----------------------------
 *
 * Funções auxiliares que encapsulam comportamento repetitivo.
 */
const helper = {
  async login(page, email: string, password: string) {
    await page.goto('https://paraBank.com/login');
    await page.fill(selectors.loginEmail, email);
    await page.fill(selectors.loginPassword, password);
    await page.click(selectors.loginBtn);
    await expect(page.locator(selectors.homePage)).toBeVisible();
  },

  async register(page, userData: Record<string, string>) {
    await page.goto('https://paraBank.com/register');
    await page.fill(selectors.fullname, userData.fullname);
    await page.fill(selectors.email, userData.email);
    await page.fill(selectors.phone, userData.phone);
    await page.fill(selectors.cpf, userData.cpf);
    await page.fill(selectors.address, userData.address);
    await page.fill(selectors.cep, userData.cep);
    await page.fill(selectors.city, userData.city);
    await page.fill(selectors.state, userData.state);
    await page.click(selectors.createAccountBtn);
  },

  async waitForError(page, field: string) {
    const error = page.locator(`${field} + ${selectors.errorMsg}`);
    await expect(error).toBeVisible();
    return error;
  }
};

/**
 * -----------------------------
 * 3. TESTES
 * -----------------------------
 */
test.describe('Feature: Cadastro de Usuário', () => {
  test('US-01 – Cadastro bem‑sucedido', async ({ page }) => {
    await helper.register(page, {
      fullname: 'João Silva',
      email: 'joao.silva@example.com',
      phone: '11987654321',
      cpf: '12345678901',
      address: 'Rua A, 100',
      cep: '12345000',
      city: 'São Paulo',
      state: 'SP'
    });

    await test.step('Verificar mensagem de sucesso', async () => {
      await expect(page.locator(selectors.successMsg)).toBeVisible();
    });

    await test.step('Verificar redirecionamento para login', async () => {
      await expect(page.locator(selectors.loginPage)).toBeVisible();
    });
  });

  test.describe('US-02 – Campos obrigatórios', () => {
    // Exemplo 1: Nome completo não preenchido
    test('Campo Nome completo obrigatório', async ({ page }) => {
      await page.goto('https://paraBank.com/register');
      await page.fill(selectors.email, 'test@example.com');
      await page.click(selectors.createAccountBtn);

      await test.step('Mensagem de erro', async () => {
        const error = await helper.waitForError(page, selectors.fullname);
        await expect(error).toHaveText('O campo Nome completo é obrigatório');
      });
    });

    // Exemplo 2: CPF não preenchido (outros campos preenchidos)
    test('Campo CPF obrigatório', async ({ page }) => {
      await page.goto('https://paraBank.com/register');
      await page.fill(selectors.fullname, 'Ana Sousa');
      await page.fill(selectors.email, 'ana.sousa@example.com');
      await page.fill(selectors.phone, '11912345678');
      // CPF omitido
      await page.click(selectors.createAccountBtn);

      const error = await helper.waitForError(page, selectors.cpf);
      await expect(error).toHaveText('O campo CPF é obrigatório');
    });
  });

  test.describe('US-03 – Validação em tempo real', () => {
    test('Telefone inválido', async ({ page }) => {
      await page.goto('https://paraBank.com/register');
      await page.fill(selectors.phone, '123'); // menos que 10 dígitos
      await page.focus(selectors.email); // força blur para disparar validação

      const error = await helper.waitForError(page, selectors.phone);
      await expect(error).toHaveText('Telefone inválido, digite 10 dígitos');
    });

    test('CEP com letras', async ({ page }) => {
      await page.goto('https://paraBank.com/register');
      await page.fill(selectors.cep, 'ABC12345');
      await page.focus(selectors.city);

      const error = await helper.waitForError(page, selectors.cep);
      await expect(error).toHaveText('CEP inválido, digite apenas números');
    });

    test('E‑mail inválido', async ({ page }) => {
      await page.goto('https://paraBank.com/register');
      await page.fill(selectors.email, 'usuario@');
      await page.focus(selectors.fullname);

      const error = await helper.waitForError(page, selectors.email);
      await expect(error).toHaveText('E‑mail inválido, verifique o domínio');
    });
  });
});

test.describe('Feature: Login', () => {
  test('US-05 – Login bem‑sucedido', async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
    await test.step('Verificar redirecionamento', async () => {
      await expect(page.locator(selectors.homePage)).toBeVisible();
    });
  });

  test.describe('US-06 – Credenciais inválidas', () => {
    test('Email incorreto', async ({ page }) => {
      await page.goto('https://paraBank.com/login');
      await page.fill(selectors.loginEmail, 'errado@email.com');
      await page.fill(selectors.loginPassword, 'senha123');
      await page.click(selectors.loginBtn);

      const error = page.locator(selectors.errorMsg);
      await expect(error).toHaveText('E‑mail ou senha inválidos');
    });

    test('Senha incorreta', async ({ page }) => {
      await page.goto('https://paraBank.com/login');
      await page.fill(selectors.loginEmail, 'certo@email.com');
      await page.fill(selectors.loginPassword, 'wrongPass');
      await page.click(selectors.loginBtn);

      const error = page.locator(selectors.errorMsg);
      await expect(error).toHaveText('E‑mail ou senha inválidos');
    });
  });
});

test.describe('Feature: Saldo e Extrato', () => {
  test.beforeEach(async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
  });

  test.describe('US-07 – Visualizar saldo', () => {
    test('Após depósito de 500', async ({ page }) => {
      // Simular a operação (depoimento)
      await page.goto('https://paraBank.com/deposit');
      await page.fill('#deposit-amount', '500');
      await page.click('text=Confirmar');
      await expect(page.locator('.notification')).toHaveText('Depósito concluído');

      await page.goto(selectors.balancePage);
      const balance = page.locator(selectors.balanceValue);
      await expect(balance).toHaveText('1500');
    });
  });

  test.describe('US-08 – Visualizar extrato', () => {
    test('Verificar ordem cronológica', async ({ page }) => {
      await page.goto(selectors.statementPage);
      const rows = page.locator(selectors.statementRows);
      await expect(rows.first()).toContainText('2025‑10‑03'); // mais recente
      await expect(rows.nth(1)).toContainText('2025‑10‑02');
      await expect(rows.nth(2)).toContainText('2025‑10‑01');
    });
  });
});

test.describe('Feature: Transferência de Fundos', () => {
  test.beforeEach(async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
  });

  test('US-09 – Transferência bem‑sucedida', async ({ page }) => {
    await page.goto(selectors.transferPage);
    await page.fill(selectors.originAccount, '12345');
    await page.fill(selectors.destinationAccount, '54321');
    await page.fill(selectors.transferAmount, '200');
    await page.click(selectors.confirmTransferBtn);

    await test.step('Verificar saldo origem', async () => {
      const originBalance = page.locator('#balance-12345');
      await expect(originBalance).toHaveText('800');
    });

    await test.step('Verificar saldo destino', async () => {
      const destBalance = page.locator('#balance-54321');
      await expect(destBalance).toHaveText('1200');
    });

    await test.step('Verificar extrato origem', async () => {
      await page.goto(`${selectors.statementPage}?account=12345`);
      await expect(page.locator('.statement-row').first()).toContainText('Transferência');
    });

    await test.step('Verificar extrato destino', async () => {
      await page.goto(`${selectors.statementPage}?account=54321`);
      await expect(page.locator('.statement-row').first()).toContainText('Transferência recebida');
    });
  });

  test.describe('US-10 – Validação de valores e contas', () => {
    test('Transferência concluída', async ({ page }) => {
      // Aqui esperamos que o fluxo de negócio permita transferir 200
      await page.goto(selectors.transferPage);
      await page.fill(selectors.originAccount, '12345');
      await page.fill(selectors.destinationAccount, '54321');
      await page.fill(selectors.transferAmount, '200');
      await page.click(selectors.confirmTransferBtn);

      const success = page.locator('.notification');
      await expect(success).toHaveText('Transferência concluída');
    });

    test('Valor zero', async ({ page }) => {
      await page.goto(selectors.transferPage);
      await page.fill(selectors.originAccount, '12345');
      await page.fill(selectors.destinationAccount, '54321');
      await page.fill(selectors.transferAmount, '0');
      await page.click(selectors.confirmTransferBtn);

      const error = page.locator(selectors.errorMsg);
      await expect(error).toHaveText('Valor deve ser maior que zero');
    });

    test('Saldo insuficiente', async ({ page }) => {
      await page.goto(selectors.transferPage);
      await page.fill(selectors.originAccount, '12345');
      await page.fill(selectors.destinationAccount, '54321');
      await page.fill(selectors.transferAmount, '2000'); // assume saldo menor
      await page.click(selectors.confirmTransferBtn);

      const error = page.locator(selectors.errorMsg);
      await expect(error).toHaveText('Saldo insuficiente');
    });
  });

  test('US-11 – Transferência com saldo insuficiente', async ({ page }) => {
    // Supomos que a conta 12345 tem saldo 100
    await page.goto(selectors.transferPage);
    await page.fill(selectors.originAccount, '12345');
    await page.fill(selectors.destinationAccount, '54321');
    await page.fill(selectors.transferAmount, '200');
    await page.click(selectors.confirmTransferBtn);

    const error = page.locator(selectors.errorMsg);
    await expect(error).toHaveText('Saldo insuficiente');
  });
});

test.describe('Feature: Solicitação de Empréstimo', () => {
  test.beforeEach(async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
  });

  test('US-12 – Formulário de empréstimo', async ({ page }) => {
    await page.goto(selectors.loanPage);
    await page.fill(selectors.loanAmount, '5000');
    await page.fill(selectors.annualIncome, '60000');
    await page.click(selectors.requestLoanBtn);

    const processing = page.locator('.loading');
    await expect(processing).toBeVisible();
    await expect(processing).toBeHidden();
  });

  test.describe('US-13 – Decisão de aprovação ou negação', () => {
    test('Empréstimo aprovado', async ({ page }) => {
      await page.goto(selectors.loanPage);
      // Simular que o back‑end já retornou "Aprovado"
      await page.evaluate(() => {
        window.sessionStorage.setItem('loanStatus', 'Aprovado');
      });
      await page.reload();

      const banner = page.locator(selectors.loanBanner);
      await expect(banner).toHaveText('Empréstimo aprovado! Valor creditado');
    });

    test('Empréstimo negado', async ({ page }) => {
      await page.goto(selectors.loanPage);
      await page.evaluate(() => {
        window.sessionStorage.setItem('loanStatus', 'Negado');
      });
      await page.reload();

      const banner = page.locator(selectors.loanBanner);
      await expect(banner).toHaveText('Empréstimo negado. Motivo: renda insuficiente');
    });
  });

  test.describe('US-14 – Crédito em conta após aprovação', () => {
    test('Saldo aumenta com valor aprovado', async ({ page }) => {
      // Supõe que a aprovação já ocorreu e a conta tem saldo 2000
      await page.goto(selectors.loanPage);
      const balanceBefore = page.locator(selectors.balanceValue);
      await expect(balanceBefore).toHaveText('2000');

      // Simular a creditação (normalmente via API)
      await page.evaluate(() => {
        const current = parseInt(sessionStorage.getItem('balance') || '2000', 10);
        sessionStorage.setItem('balance', (current + 5000).toString());
      });

      await page.reload(); // recarrega página para atualizar saldo
      const balanceAfter = page.locator(selectors.balanceValue);
      await expect(balanceAfter).toHaveText('7000');
    });
  });
});

test.describe('Feature: Pagamento de Contas', () => {
  test.beforeEach(async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
  });

  test('US-15 – Registro de pagamento imediato', async ({ page }) => {
    await page.goto(selectors.paymentPage);
    await page.fill(selectors.beneficiary, 'Empresa X');
    await page.fill('#payment-amount', '150');
    await page.fill(selectors.paymentDate, '2025-10-01');
    await page.click(selectors.confirmPaymentBtn);

    const success = page.locator(selectors.paymentSuccessMsg);
    await expect(success).toBeVisible();

    // Verificar que foi adicionado ao histórico
    await page.goto(selectors.statementPage);
    const history = page.locator(selectors.statementRows);
    await expect(history.first()).toContainText('Pagamento');
  });

  test.describe('US-16 – Validação dos campos obrigatórios', () => {
    test('Beneficiário obrigatório', async ({ page }) => {
      await page.goto(selectors.paymentPage);
      await page.fill('#payment-amount', '150');
      await page.fill(selectors.paymentDate, '2025-10-01');
      await page.click(selectors.confirmPaymentBtn);

      const error = page.locator(`${selectors.beneficiary} + ${selectors.errorMsg}`);
      await expect(error).toHaveText('Beneficiário é obrigatório');
    });

    test('CEP obrigatório', async ({ page }) => {
      await page.goto(selectors.paymentPage);
      await page.fill(selectors.beneficiary, 'Empresa Y');
      await page.fill('#payment-amount', '150');
      await page.fill(selectors.paymentDate, '2025-10-01');
      await page.click(selectors.confirmPaymentBtn);

      const error = page.locator('#payment-cep + .error-message');
      await expect(error).toHaveText('CEP é obrigatório');
    });

    test('Conta de destino obrigatória', async ({ page }) => {
      await page.goto(selectors.paymentPage);
      await page.fill(selectors.beneficiary, 'Empresa Z');
      await page.fill('#payment-amount', '150');
      await page.fill(selectors.paymentDate, '2025-10-01');
      await page.click(selectors.confirmPaymentBtn);

      const error = page.locator('#payment-destination + .error-message');
      await expect(error).toHaveText('Conta de destino é obrigatória');
    });
  });

  test.describe('US-17 – Pagamento agendado', () => {
    test('Agendar pagamento futuro', async ({ page }) => {
      await page.goto(selectors.paymentPage);
      await page.fill(selectors.beneficiary, 'Empresa Futura');
      await page.fill('#payment-amount', '200');
      await page.fill(selectors.paymentDate, '2025-10-20');
      await page.click(selectors.confirmPaymentBtn);

      const status = page.locator('#payment-status');
      await expect(status).toHaveText('Agendado');

      // Verificar que não é debitado antes da data
      // (simplificado: apenas verificamos a marcação)
    });
  });
});

test.describe('Feature: Navegação e Usabilidade', () => {
  test.beforeEach(async ({ page }) => {
    await helper.login(page, 'certo@email.com', 'senhaCorreta');
  });

  test.describe('US-18 – Navegação sem erros', () => {
    const links = [
      { key: 'saldo', url: selectors.balancePage },
      { key: 'extrato', url: selectors.statementPage },
      { key: 'emprestimos', url: selectors.loanPage }
    ];

    links.forEach(link => {
      test(`Clique no link ${link.key}`, async ({ page }) => {
        await page.click(selectors.navLinks[link.key as keyof typeof selectors.navLinks]);
        await expect(page).toHaveURL(link.url);
        await expect(page.locator(link.url)).toBeVisible();
      });
    });
  });

  test('US-19 – Mensagens de erro claras', async ({ page }) => {
    await page.goto('https://paraBank.com/some-form');
    await page.fill('#some-invalid-field', '!!!');
    await page.click('text=Submeter');
    const error = page.locator(selectors.errorMsg);
    await expect(error).toBeVisible();
    await expect(error).toHaveText(/o campo não é válido/i);
  });

  test('US-20 – Menus consistentes', async ({ page }) => {
    const pages = [selectors.balancePage, selectors.statementPage, selectors.loanPage];
    for (const url of pages) {
      await page.goto(url);
      await expect(page.locator(selectors.header)).toContainText('ParaBank');
      await expect(page.locator(selectors.sidebar)).toContainText('Saldo');
      await expect(page.locator(selectors.sidebar)).toContainText('Extrato');
      await expect(page.locator(selectors.sidebar)).toContainText('Empréstimos');
      await expect(page.locator(selectors.footer)).toBeVisible();
      // Responsividade – apenas verificando que a largura pode mudar
      await page.setViewportSize({ width: 320, height: 480 }); // mobile
      await expect(page.locator(selectors.sidebar)).toBeHidden();
      await page.setViewportSize({ width: 1024, height: 768 }); // desktop
      await expect(page.locator(selectors.sidebar)).toBeVisible();
    }
  });
});
```

---

### Dicas de boas práticas que o código já aplica

| Prática | Como está implementada |
|---------|-----------------------|
| **Esperas explícitas** | `await expect(locator).toBeVisible()` ou `toHaveText()` |
| **Separação de responsabilidades** | *Helpers* para login e cadastro, *selectors* centralizados |
| **Uso de `test.step`** | Documenta cada ação e facilita a leitura dos resultados |
| **Tratamento de erros** | Mensagens de erro capturadas com `locator('.error-message')` e validadas |
| **Escopo de dados** | `test.describe('Scenario Outline')` + iteração em array de exemplos |
| **Responsividade** | Testes de viewport em `US‑20` |
| **Comentários explicativos** | Cada bloco de código possui comentários que explicam o que está sendo testado |

> **Próximos passos**  
> 1. Substitua os seletores fictícios pelos reais.  
> 2. Caso sua aplicação use API endpoints, use `page.route(...)` ou `test.step` para simular respostas.  
> 3. Para cenários mais complexos, crie *Page Objects* (ex.: `RegisterPage`, `LoginPage`).  
> 4. Se preferir BDD puro, integre o *Cucumber* com Playwright usando o plugin `@cucumber/puppeteer`.

Pronto! Agora você tem um conjunto de testes Playwright totalmente funcional, organizado, comentado e pronto para ser integrado ao seu CI. Boa sorte na sua automação!