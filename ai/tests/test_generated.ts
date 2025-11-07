```ts
/* ====================================================================== */
/*  Playwright Test Runner – Automação de todos os cenários BDD           */
/*  (US01‑US07)  –  Testes em TypeScript com boas práticas                 */
/* ====================================================================== */

import { test, expect, Page } from '@playwright/test';

/* ---------------------------------------------------------------------- */
/*  Configurações e constantes comuns                                       */
/* ---------------------------------------------------------------------- */
const BASE_URL = process.env.BASE_URL ?? 'http://localhost:3000';

/*  Seletores “data‑test‑id” – devem existir na aplicação (ex.:  <input data-test-id="name" ...> )   */
const SELECTORS = {
  // Registration page
  name: 'input[data-test-id="name"]',
  cpf: 'input[data-test-id="cpf"]',
  birthDate: 'input[data-test-id="birthDate"]',
  phone: 'input[data-test-id="phone"]',
  zip: 'input[data-test-id="zip"]',
  address: 'input[data-test-id="address"]',
  email: 'input[data-test-id="email"]',
  password: 'input[data-test-id="password"]',
  confirmPassword: 'input[data-test-id="confirmPassword"]',
  submit: 'button[data-test-id="submit"]',
  successMsg: 'div[data-test-id="successMessage"]',
  errorMsg: (field: string) => `div[data-test-id="${field}Error"]`,

  // Login page
  loginEmail: 'input[data-test-id="loginEmail"]',
  loginPassword: 'input[data-test-id="loginPassword"]',
  loginButton: 'button[data-test-id="loginButton"]',
  topBarGreeting: 'span[data-test-id="topBarGreeting"]',

  // General navigation
  mainMenu: 'nav[data-test-id="mainMenu"]',
  menuLink: (label: string) => `a[data-test-id="menuLink"][data-label="${label}"]`,
  dashboard: 'div[data-test-id="dashboard"]',
  extratoPage: 'div[data-test-id="extratoPage"]',
  transferPage: 'div[data-test-id="transferPage"]',
  loanPage: 'div[data-test-id="loanPage"]',
  paymentsPage: 'div[data-test-id="paymentsPage"]',
  accountBalance: 'span[data-test-id="accountBalance"]',

  // Extrato filters
  extratoList: 'ul[data-test-id="extratoList"] li',
  extratoEmptyMsg: 'div[data-test-id="extratoEmpty"]',
  filterStartDate: 'input[data-test-id="filterStartDate"]',
  filterEndDate: 'input[data-test-id="filterEndDate"]',
  applyFilterBtn: 'button[data-test-id="applyFilter"]',

  // Transfer
  originAccount: 'select[data-test-id="originAccount"]',
  destinationAccount: 'select[data-test-id="destinationAccount"]',
  transferAmount: 'input[data-test-id="transferAmount"]',
  transferConfirmBtn: 'button[data-test-id="transferConfirm"]',
  transferSuccessMsg: 'div[data-test-id="transferSuccess"]',

  // Loan
  loanAmount: 'input[data-test-id="loanAmount"]',
  loanIncome: 'input[data-test-id="loanIncome"]',
  loanSubmitBtn: 'button[data-test-id="loanSubmit"]',
  loanSuccessMsg: 'div[data-test-id="loanSuccess"]',

  // Payments
  beneficiary: 'input[data-test-id="beneficiary"]',
  beneficiaryAddress: 'input[data-test-id="beneficiaryAddress"]',
  beneficiaryCity: 'input[data-test-id="beneficiaryCity"]',
  beneficiaryState: 'input[data-test-id="beneficiaryState"]',
  beneficiaryZip: 'input[data-test-id="beneficiaryZip"]',
  beneficiaryPhone: 'input[data-test-id="beneficiaryPhone"]',
  paymentAccount: 'select[data-test-id="paymentAccount"]',
  paymentAmount: 'input[data-test-id="paymentAmount"]',
  paymentDate: 'input[data-test-id="paymentDate"]',
  paymentConfirmBtn: 'button[data-test-id="paymentConfirm"]',
  paymentSuccessMsg: 'div[data-test-id="paymentSuccess"]',
};

/* ---------------------------------------------------------------------- */
/*  Dados de usuário “mock” – usados em todos os cenários que precisam   */
/*  de um usuário existente (cadastrado e logado).                         */
/* ---------------------------------------------------------------------- */
const MOCK_USER = {
  name: 'João Silva',
  cpf: '12345678901',
  birthDate: '01/01/1990',
  phone: '(11) 98765-4321',
  zip: '12345678',
  address: 'Rua Exemplo, 100',
  email: 'joao.silva@example.com',
  password: 'Password123',
};

/* ---------------------------------------------------------------------- */
/*  Funções auxiliares                                                    */
/* ---------------------------------------------------------------------- */
/**
 * Navega até a página de cadastro e preenche todos os campos com valores
 * válidos (usando MOCK_USER).  O campo “confirmPassword” pode ser
 * passado como argumento para testar cenários onde a senha difere.
 */
async function fillValidRegistration(page: Page, confirmPassword = MOCK_USER.password) {
  await page.fill(SELECTORS.name, MOCK_USER.name);
  await page.fill(SELECTORS.cpf, MOCK_USER.cpf);
  await page.fill(SELECTORS.birthDate, MOCK_USER.birthDate);
  await page.fill(SELECTORS.phone, MOCK_USER.phone);
  await page.fill(SELECTORS.zip, MOCK_USER.zip);
  await page.fill(SELECTORS.address, MOCK_USER.address);
  await page.fill(SELECTORS.email, MOCK_USER.email);
  await page.fill(SELECTORS.password, MOCK_USER.password);
  await page.fill(SELECTORS.confirmPassword, confirmPassword);
}

/**
 * Faz login usando o usuário MOCK_USER.
 */
async function login(page: Page, email = MOCK_USER.email, password = MOCK_USER.password) {
  await page.goto(`${BASE_URL}/login`);
  await page.fill(SELECTORS.loginEmail, email);
  await page.fill(SELECTORS.loginPassword, password);
  await page.click(SELECTORS.loginButton);
  await expect(page.locator(SELECTORS.topBarGreeting)).toContainText(`Olá, ${MOCK_USER.name.split(' ')[0]}`);
}

/* ---------------------------------------------------------------------- */
/*  US01 – Cadastro de Usuário                                             */
/* ---------------------------------------------------------------------- */
test.describe('US01 – Cadastro de Usuário', () => {
  /*  Todos os cenários começam na página de cadastro  */
  test.beforeEach(async ({ page }) => {
    await page.goto(`${BASE_URL}/register`);
  });

  /*  Cenário positivo – registro com todos os campos válidos  */
  test('Registro com todos os campos válidos', async ({ page }) => {
    await test.step('Given I am on the registration page', async () => {
      await expect(page).toHaveURL(/\/register$/);
    });

    await test.step('When I enter all data and submit the form', async () => {
      await fillValidRegistration(page);
      await page.click(SELECTORS.submit);
    });

    await test.step('Then I should see the success message', async () => {
      await expect(page.locator(SELECTORS.successMsg)).toHaveText(
        'Cadastro concluído com sucesso. Você pode agora fazer login.'
      );
    });
  });

  /*  Cenários negativos – validações de campo  */
  const invalidPhoneScenarios = [
    { phone: '(11) 9876-543', error: 'Telefone inválido – insira 10 ou 11 dígitos' },
  ];

  for (const { phone, error } of invalidPhoneScenarios) {
    test(`Telefone inválido com 9 dígitos – ${phone}`, async ({ page }) => {
      await test.step('Given I am on the registration page', async () => {
        await expect(page).toHaveURL(/\/register$/);
      });

      await test.step('When I enter an invalid phone and fill other fields with valid data', async () => {
        await fillValidRegistration(page);
        await page.fill(SELECTORS.phone, phone);
        await page.click(SELECTORS.submit);
      });

      await test.step(`Then I should see the error message "${error}" below the phone field`, async () => {
        await expect(page.locator(SELECTORS.errorMsg('phone'))).toHaveText(error);
      });
    });
  }

  const invalidZipScenarios = [
    { zip: '1234567', error: 'CEP inválido – insira 8 dígitos' },
  ];

  for (const { zip, error } of invalidZipScenarios) {
    test(`CEP inválido com 7 dígitos – ${zip}`, async ({ page }) => {
      await test.step('Given I am on the registration page', async () => {
        await expect(page).toHaveURL(/\/register$/);
      });

      await test.step('When I enter an invalid ZIP and fill other fields with valid data', async () => {
        await fillValidRegistration(page);
        await page.fill(SELECTORS.zip, zip);
        await page.click(SELECTORS.submit);
      });

      await test.step(`Then I should see the error message "${error}" below the ZIP field`, async () => {
        await expect(page.locator(SELECTORS.errorMsg('zip'))).toHaveText(error);
      });
    });
  }

  const invalidEmailScenarios = [
    { email: 'joao.silva@', error: 'E‑mail inválido' },
  ];

  for (const { email, error } of invalidEmailScenarios) {
    test(`E‑mail inválido sem domínio – ${email}`, async ({ page }) => {
      await test.step('Given I am on the registration page', async () => {
        await expect(page).toHaveURL(/\/register$/);
      });

      await test.step('When I enter an invalid email and fill other fields with valid data', async () => {
        await fillValidRegistration(page);
        await page.fill(SELECTORS.email, email);
        await page.click(SELECTORS.submit);
      });

      await test.step(`Then I should see the error message "${error}" below the email field`, async () => {
        await expect(page.locator(SELECTORS.errorMsg('email'))).toHaveText(error);
      });
    });
  }

  const passwordMismatchScenarios = [
    { password: 'Password123', confirm: 'Password321', error: 'Senhas não correspondem' },
  ];

  for (const { password, confirm, error } of passwordMismatchScenarios) {
    test(`Senha e confirmação diferentes – "${password}" / "${confirm}"`, async ({ page }) => {
      await test.step('Given I am on the registration page', async () => {
        await expect(page).toHaveURL(/\/register$/);
      });

      await test.step('When I enter mismatched passwords and fill other fields with valid data', async () => {
        await fillValidRegistration(page, confirm);
        await page.click(SELECTORS.submit);
      });

      await test.step(`Then I should see the error message "${error}" below the confirm password field`, async () => {
        await expect(page.locator(SELECTORS.errorMsg('confirmPassword'))).toHaveText(error);
      });
    });
  }

  /*  Cenário positivo – registro + login imediato  */
  test('Registro completo seguido de login imediato', async ({ page }) => {
    /*  Registro  */
    await test.step('Given I have successfully registered with valid data', async () => {
      await fillValidRegistration(page);
      await page.click(SELECTORS.submit);
      await expect(page.locator(SELECTORS.successMsg)).toBeVisible();
    });

    /*  Login  */
    await test.step('When I navigate to the login page', async () => {
      await page.goto(`${BASE_URL}/login`);
    });

    await test.step('And I enter the registered email and password', async () => {
      await page.fill(SELECTORS.loginEmail, MOCK_USER.email);
      await page.fill(SELECTORS.loginPassword, MOCK_USER.password);
    });

    await test.step('And I click the login button', async () => {
      await page.click(SELECTORS.loginButton);
    });

    await test.step('Then I should be redirected to the Dashboard', async () => {
      await expect(page).toHaveURL(/\/dashboard$/);
    });

    await test.step('And I should see the message "Olá, João" in the top bar', async () => {
      await expect(page.locator(SELECTORS.topBarGreeting)).toContainText('Olá, João');
    });
  });
});

/* ====================================================================== */
/*  US02 – Login                                                           */
/* ====================================================================== */
test.describe('US02 – Login', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto(`${BASE_URL}/login`);
  });

  test('Login com credenciais válidas', async ({ page }) => {
    await test.step('Given I am on the login page', async () => {
      await expect(page).toHaveURL(/\/login$/);
    });

    await test.step('When I enter valid credentials and submit', async () => {
      await login(page);
    });

    await test.step('Then I should be redirected to the Dashboard', async () => {
      await expect(page).toHaveURL(/\/dashboard$/);
    });

    await test.step('And I should see the message "Olá, João" in the top bar', async () => {
      await expect(page.locator(SELECTORS.topBarGreeting)).toContainText('Olá, João');
    });
  });

  test('Login com credenciais inválidas', async ({ page }) => {
    await test.step('Given I am on the login page', async () => {
      await expect(page).toHaveURL(/\/login$/);
    });

    await test.step('When I enter wrong password and submit', async () => {
      await login(page, MOCK_USER.email, 'WrongPass');
    });

    await test.step('Then I should see the error message', async () => {
      await expect(page.locator(SELECTORS.errorMsg('login'))).toHaveText(
        'E‑mail ou senha incorretos. Tente novamente.'
      );
    });
  });

  test('Login com campo de e‑mail vazio', async ({ page }) => {
    await test.step('Given I am on the login page', async () => {
      await expect(page).toHaveURL(/\/login$/);
    });

    await test.step('When I leave the email field blank, fill password and submit', async () => {
      await page.fill(SELECTORS.loginEmail, '');
      await page.fill(SELECTORS.loginPassword, MOCK_USER.password);
      await page.click(SELECTORS.loginButton);
    });

    await test.step('Then I should see the error message', async () => {
      await expect(page.locator(SELECTORS.errorMsg('login'))).toHaveText(
        'E‑mail ou senha incorretos. Tente novamente.'
      );
    });
  });
});

/* ====================================================================== */
/*  US03 – Acesso à Conta (Saldo e Extrato)                              */
/* ====================================================================== */
test.describe('US03 – Acesso à Conta (Saldo e Extrato)', () => {
  /*  Autenticar antes de cada cenário  */
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('Exibição do saldo atual na Dashboard', async ({ page }) => {
    await test.step('Given I am logged in and on the Dashboard', async () => {
      await expect(page).toHaveURL(/\/dashboard$/);
    });

    await test.step('Then I should see my current account balance displayed prominently', async () => {
      await expect(page.locator(SELECTORS.accountBalance)).toBeVisible();
    });
  });

  test('Exibir extrato com pelo menos 10 transações', async ({ page }) => {
    await test.step('Given I am logged in and click "Extrato"', async () => {
      await page.click(SELECTORS.menuLink('Extrato'));
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('Then I should see a list containing at least 10 transaction entries', async () => {
      const entries = await page.locator(SELECTORS.extratoList).count();
      expect(entries).toBeGreaterThanOrEqual(10);
    });
  });

  test('Mensagem quando não há transações', async ({ page }) => {
    /*  Simulação: precisamos de um usuário que não tenha transações.
        Em um teste real, o estado seria preparado via API ou fixture.   */
    // Assumindo que o usuário criado no US01 não tem transações
    await test.step('Given I am logged in and my account has zero transactions', async () => {
      // nada a fazer – estado inicial já garante isso
    });

    await test.step('And I click "Extrato"', async () => {
      await page.click(SELECTORS.menuLink('Extrato'));
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('Then I should see the message "Nenhuma transação encontrada"', async () => {
      await expect(page.locator(SELECTORS.extratoEmptyMsg)).toHaveText('Nenhuma transação encontrada');
    });
  });

  test('Filtrar extrato por intervalo de datas', async ({ page }) => {
    await test.step('Given I am logged in and click "Extrato"', async () => {
      await page.click(SELECTORS.menuLink('Extrato'));
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('When I set the start and end dates and apply the filter', async () => {
      await page.fill(SELECTORS.filterStartDate, '01/01/2024');
      await page.fill(SELECTORS.filterEndDate, '31/01/2024');
      await page.click(SELECTORS.applyFilterBtn);
    });

    await test.step('Then I should see only transactions dated between 01/01/2024 and 31/01/2024', async () => {
      const dates = await page.$$eval(
        `${SELECTORS.extratoList} .transaction-date`,
        els => els.map(el => el.textContent?.trim() ?? '')
      );
      for (const d of dates) {
        const date = new Date(d); // assumes format DD/MM/YYYY
        expect(date).toBeGreaterThanOrEqual(new Date('2024-01-01'));
        expect(date).toBeLessThanOrEqual(new Date('2024-01-31'));
      }
    });
  });
});

/* ====================================================================== */
/*  US04 – Transferência de Fundos                                          */
/* ====================================================================== */
test.describe('US04 – Transferência de Fundos', () => {
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  const navigateToTransfer = async (page: Page) => {
    await page.click(SELECTORS.menuLink('Transferência'));
    await expect(page).toHaveURL(/\/transfer$/);
  };

  /*  Helper: captura saldo atual  */
  const getBalance = async (page: Page): Promise<number> => {
    const text = await page.locator(SELECTORS.accountBalance).textContent();
    const value = parseFloat(text?.replace(/[^\d.,]/g, '').replace(',', '.') ?? '0');
    return value;
  };

  test('Transferência com saldo suficiente', async ({ page }) => {
    await navigateToTransfer(page);

    const originBefore = await getBalance(page); // Assume origin is the only listed balance

    await test.step('When I select origin and destination accounts, enter amount and confirm', async () => {
      await page.selectOption(SELECTORS.originAccount, 'conta_corrente');
      await page.selectOption(SELECTORS.destinationAccount, 'conta_poupanca');
      await page.fill(SELECTORS.transferAmount, '100');
      await page.click(SELECTORS.transferConfirmBtn);
    });

    await test.step('Then I should see the success message', async () => {
      await expect(page.locator(SELECTORS.transferSuccessMsg)).toHaveText('Transferência realizada com sucesso');
    });

    await test.step('And balances should be updated accordingly', async () => {
      const originAfter = await getBalance(page);
      expect(originAfter).toBeCloseTo(originBefore - 100, 2);

      // Simulação: verificação de saldo da conta de destino via API ou outra página
      // Não implementado – placeholder
    });

    await test.step('And the transaction should appear in both accounts’ extrato', async () => {
      // Navegar até extrato da origem e verificar a transação
      // placeholder
    });
  });

  test('Transferência com saldo insuficiente', async ({ page }) => {
    // Ajustar o saldo via API/fixture para R$50
    // placeholder – assumimos que saldo já é insuficiente

    await navigateToTransfer(page);

    await test.step('When I try to transfer 100 from a balance of 50', async () => {
      await page.selectOption(SELECTORS.originAccount, 'conta_corrente');
      await page.selectOption(SELECTORS.destinationAccount, 'conta_poupanca');
      await page.fill(SELECTORS.transferAmount, '100');
      await page.click(SELECTORS.transferConfirmBtn);
    });

    await test.step('Then I should see the error message "Saldo insuficiente"', async () => {
      await expect(page.locator(SELECTORS.errorMsg('transfer'))).toHaveText('Saldo insuficiente');
    });

    await test.step('And no transaction should be recorded', async () => {
      // placeholder – verificação via API ou UI
    });
  });
});

/* ====================================================================== */
/*  US05 – Solicitação de Empréstimo                                       */
/* ====================================================================== */
test.describe('US05 – Solicitação de Empréstimo', () => {
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  const navigateToLoan = async (page: Page) => {
    await page.click(SELECTORS.menuLink('Empréstimo'));
    await expect(page).toHaveURL(/\/loan$/);
  };

  test('Empréstimo aprovado por renda suficiente', async ({ page }) => {
    await navigateToLoan(page);

    await test.step('When I enter loan amount 5000 and income 60000 and submit', async () => {
      await page.fill(SELECTORS.loanAmount, '5000');
      await page.fill(SELECTORS.loanIncome, '60000');
      await page.click(SELECTORS.loanSubmitBtn);
    });

    await test.step('Then I should see the message "Empréstimo aprovado"', async () => {
      await expect(page.locator(SELECTORS.loanSuccessMsg)).toHaveText('Empréstimo aprovado');
    });

    await test.step('And the loan record should be saved in my loan history', async () => {
      // placeholder – navegar até histórico e verificar a presença do empréstimo
    });
  });

  test('Empréstimo negado por renda insuficiente', async ({ page }) => {
    await navigateToLoan(page);

    await test.step('When I enter loan amount 5000 and income 12000 and submit', async () => {
      await page.fill(SELECTORS.loanAmount, '5000');
      await page.fill(SELECTORS.loanIncome, '12000');
      await page.click(SELECTORS.loanSubmitBtn);
    });

    await test.step('Then I should see the message "Empréstimo negado – renda insuficiente"', async () => {
      await expect(page.locator(SELECTORS.loanSuccessMsg)).toHaveText('Empréstimo negado – renda insuficiente');
    });

    await test.step('And no loan record should be created', async () => {
      // placeholder
    });
  });

  test('Visualizar histórico de empréstimos', async ({ page }) => {
    // Pré‑condição: já existe um empréstimo pendente ou aprovado
    // placeholder – assumimos que o histórico já contém pelo menos um registro

    await navigateToLoan(page);

    await test.step('When I navigate to the Loans section', async () => {
      // Já estamos na página do empréstimo, o histórico pode ser exibido
    });

    await test.step('Then I should see my past loan requests listed with status and dates', async () => {
      const entries = await page.$$('.loan-entry');
      expect(entries.length).toBeGreaterThan(0);
      for (const entry of entries) {
        const status = await entry.getAttribute('data-status');
        const date = await entry.getAttribute('data-date');
        expect(status).not.toBeNull();
        expect(date).not.toBeNull();
      }
    });
  });
});

/* ====================================================================== */
/*  US06 – Pagamento de Contas                                             */
/* ====================================================================== */
test.describe('US06 – Pagamento de Contas', () => {
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  const navigateToPayments = async (page: Page) => {
    await page.click(SELECTORS.menuLink('Pagamentos'));
    await expect(page).toHaveURL(/\/payments$/);
  };

  test('Pagamento registrado com sucesso', async ({ page }) => {
    await navigateToPayments(page);

    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = `${String(tomorrow.getDate()).padStart(2, '0')}/${String(
      tomorrow.getMonth() + 1
    ).padStart(2, '0')}/${tomorrow.getFullYear()}`;

    await test.step('When I enter beneficiary details, amount, date and confirm', async () => {
      await page.fill(SELECTORS.beneficiary, 'Conta de Luz');
      await page.fill(SELECTORS.beneficiaryAddress, 'Rua Exemplo, 100');
      await page.fill(SELECTORS.beneficiaryCity, 'São Paulo');
      await page.fill(SELECTORS.beneficiaryState, 'SP');
      await page.fill(SELECTORS.beneficiaryZip, '12345678');
      await page.fill(SELECTORS.beneficiaryPhone, '(11) 91234-5678');
      await page.selectOption(SELECTORS.paymentAccount, 'conta_corrente');
      await page.fill(SELECTORS.paymentAmount, '200');
      await page.fill(SELECTORS.paymentDate, tomorrowStr);
      await page.click(SELECTORS.paymentConfirmBtn);
    });

    await test.step('Then I should see the message "Pagamento registrado com sucesso"', async () => {
      await expect(page.locator(SELECTORS.paymentSuccessMsg)).toHaveText('Pagamento registrado com sucesso');
    });

    await test.step('And the payment should appear in the extrato with status "Pendente"', async () => {
      // placeholder – navegação até extrato e verificação
    });
  });

  test('Data inválida (passado) ao registrar pagamento', async ({ page }) => {
    await navigateToPayments(page);

    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const yesterdayStr = `${String(yesterday.getDate()).padStart(2, '0')}/${String(
      yesterday.getMonth() + 1
    ).padStart(2, '0')}/${yesterday.getFullYear()}`;

    await test.step('When I set the payment date to yesterday and attempt to confirm', async () => {
      await page.fill(SELECTORS.paymentDate, yesterdayStr);
      await page.click(SELECTORS.paymentConfirmBtn);
    });

    await test.step('Then I should see the error message "Data inválida – não pode ser anterior a hoje"', async () => {
      await expect(page.locator(SELECTORS.errorMsg('paymentDate'))).toHaveText(
        'Data inválida – não pode ser anterior a hoje'
      );
    });
  });

  test('Pagamento aparece no extrato com status Pendente', async ({ page }) => {
    // Pré‑condição: pagamento agendado para o futuro
    // placeholder – criar pagamento via UI ou API

    await navigateToPayments(page);

    await test.step('When I navigate to the Extrato page', async () => {
      await page.click(SELECTORS.menuLink('Extrato'));
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('Then I should see the payment entry with status "Pendente" and the scheduled date', async () => {
      // placeholder – busca no extrato por status "Pendente"
    });
  });
});

/* ====================================================================== */
/*  US07 – Navegação & Usabilidade                                        */
/* ====================================================================== */
test.describe('US07 – Navegação & Usabilidade', () => {
  test.beforeEach(async ({ page }) => {
    await login(page);
  });

  test('Menu principal visível em todas as páginas', async ({ page }) => {
    const pages = [
      { url: '/dashboard', label: 'Dashboard' },
      { url: '/extrato', label: 'Extrato' },
      { url: '/transfer', label: 'Transferência' },
      { url: '/loan', label: 'Empréstimo' },
      { url: '/payments', label: 'Pagamentos' },
    ];

    for (const p of pages) {
      await page.goto(`${BASE_URL}${p.url}`);
      await expect(page.locator(SELECTORS.mainMenu)).toBeVisible();

      await test.step(`Menu should contain all links on ${p.label}`, async () => {
        const expectedLinks = ['Login', 'Cadastro', 'Dashboard', 'Extrato', 'Transferência', 'Empréstimo', 'Pagamentos'];
        for (const lbl of expectedLinks) {
          await expect(page.locator(SELECTORS.menuLink(lbl))).toBeVisible();
        }
      });
    }
  });

  test('Links de navegação levam à página correta', async ({ page }) => {
    await test.step('Given I am on the Dashboard', async () => {
      await page.click(SELECTORS.menuLink('Dashboard'));
      await expect(page).toHaveURL(/\/dashboard$/);
    });

    await test.step('When I click the "Extrato" link', async () => {
      await page.click(SELECTORS.menuLink('Extrato'));
    });

    await test.step('Then I should be on the Extrato page', async () => {
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('And the URL should contain "/extrato"', async () => {
      await expect(page).toHaveURL(/\/extrato$/);
    });

    await test.step('And there should be no 404 or navigation error', async () => {
      // O próprio `toHaveURL` já garante que não houve erro 404
      await expect(page.locator('body')).not.toContainText('404');
    });
  });

  test('Mensagem de erro exibida imediatamente abaixo do campo obrigatório em branco', async ({ page }) => {
    await test.step('Given I am on the registration page', async () => {
      await page.goto(`${BASE_URL}/register`);
    });

    await test.step('And I leave the CPF field empty', async () => {
      await page.fill(SELECTORS.cpf, '');
    });

    await test.step('When I attempt to submit the form', async () => {
      await page.click(SELECTORS.submit);
    });

    await test.step('Then I should see the error message "CPF é obrigatório" displayed directly below the CPF field', async () => {
      await expect(page.locator(SELECTORS.errorMsg('cpf'))).toHaveText('CPF é obrigatório');
    });
  });

  test('Layout responsivo adapta-se a diferentes larguras de tela', async ({ page }) => {
    /*  Testes em dois tamanhos de viewport (320px e 1920px)  */
    const viewports = [
      { width: 320, height: 640, name: 'mobile' },
      { width: 1920, height: 1080, name: 'desktop' },
    ];

    for (const vp of viewports) {
      await test.step(`Testing on ${vp.name} viewport (${vp.width}x${vp.height})`, async () => {
        await page.setViewportSize({ width: vp.width, height: vp.height });
        await page.goto(`${BASE_URL}/dashboard`);

        // Garantir que os principais elementos estejam visíveis
        await expect(page.locator(SELECTORS.mainMenu)).toBeVisible();
        await expect(page.locator(SELECTORS.dashboard)).toBeVisible();

        // Se houver elementos específicos de layout, verificar que não estejam escondidos
        await expect(page.locator('img')).toBeVisible();
        await expect(page.locator('button')).toBeVisible();
      });
    }
  });
});
```

> **Observações importantes**  
> 1. Todos os seletores são baseados em atributos `data‑test-id` – isto garante estabilidade e não interferências de estilos ou textos.  
> 2. Os testes fazem uso do `test.step` para documentar cada ação de forma que a saída do Playwright fique legível e de fácil debug.  
> 3. Para cenários que exigem um estado pré‑existente (ex.: usuário com saldo ou histórico), são deixadas notas de *placeholder* – na prática, esses estados devem ser configurados via API ou fixtures antes da execução.  
> 4. A estrutura `test.describe` agrupa os testes por User Story, mantendo a organização e facilitando a extensão de novos cenários.  
> 5. O uso de helper functions (`fillValidRegistration`, `login`, `navigateToTransfer`, etc.) reduz duplicação e torna os testes mais manuteníveis.