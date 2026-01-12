```ts
/* ----------------------------------------------------------
 *  Automated tests – Playwright Test Runner (v1.30+)
 *  User Stories:
 *     US01 – Cadastro de Novo Banco
 *     US02 – Edição de Banco Existente
 * ---------------------------------------------------------- */

import { test, expect, Page } from '@playwright/test';

/* ------------------------------------------------------------------
 *  Utility helpers
 * ------------------------------------------------------------------ */

/**
 * Navigates to the bank list page (assumed URL).
 * The `baseURL` must be configured in playwright.config.ts.
 */
async function goToBankList(page: Page) {
  await page.goto('/bancos'); // Adjust if the route differs
  await expect(page.getByRole('heading', { name: 'Lista de Bancos' })).toBeVisible();
}

/**
 * Fills the bank form using the given data map.
 * The keys correspond to the labels used in the UI.
 */
async function fillBankForm(page: Page, data: Record<string, string>) {
  for (const [label, value] of Object.entries(data)) {
    // Using label text to locate the input
    const input = page.getByLabel(label);
    if (value !== undefined) {
      await input.fill(value);
    }
  }
}

/**
 * Creates a bank via UI.  Used when the test pre‑condition
 * requires an existing bank.
 */
async function createBankViaUI(page: Page, data: Record<string, string>) {
  await goToBankList(page);
  await page.getByRole('button', { name: 'Novo' }).click();
  await fillBankForm(page, data);
  await page.getByRole('button', { name: 'Salvar' }).click();

  // Verify success
  await expect(page.getByText('Cadastro concluído com sucesso')).toBeVisible();
  // Wait until the list reloads and the new record appears
  await expect(page.getByText(data['Código']!)).toBeVisible();
}

/* ------------------------------------------------------------------
 *  US01 – Cadastro de Novo Banco
 * ------------------------------------------------------------------ */
test.describe('US01 – Cadastro de Novo Banco', () => {
  const bankData = {
    'Código': 'BAN001',
    'Descrição do Banco': 'Banco Teste Nacional',
    'Apelido': 'BTN',
    'Número de inscrição no SBP': '123456',
    'Banco Controlador': 'Banco Central',
    'CNPJ': '12.345.678/0001-90',
  };

  /* Positive scenario – full valid registration */
  test('Cadastro completo e válido', async ({ page }) => {
    // Given I am on the bank list screen
    await goToBankList(page);

    // When I click "Novo" and fill the form
    await page.getByRole('button', { name: 'Novo' }).click();
    await fillBankForm(page, bankData);

    // Then I click "Salvar" and verify the record appears
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText(bankData['Código']!)).toBeVisible();

    // And the success message is shown
    await expect(page.getByText('Cadastro concluído com sucesso')).toBeVisible();
  });

  /* Negative scenario – empty "Código" field */
  test('Código em branco', async ({ page }) => {
    await goToBankList(page);

    // When I click "Novo" and leave "Código" blank
    await page.getByRole('button', { name: 'Novo' }).click();
    await page.getByLabel('Código').fill(''); // Explicitly empty
    await fillBankForm(page, {
      ...bankData,
      'Código': undefined, // Skip filling
    });

    // Then I click "Salvar" and expect validation
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('Código é obrigatório')).toBeVisible();
  });

  /* Negative scenario – duplicate code */
  test('Código duplicado', async ({ page }) => {
    // Ensure a bank with BAN001 exists first
    await createBankViaUI(page, bankData);

    // When I attempt to create another bank with the same code
    await page.getByRole('button', { name: 'Novo' }).click();
    await page.getByLabel('Código').fill('BAN001');
    await fillBankForm(page, {
      ...bankData,
      'Código': undefined, // keep duplicate value
    });

    // Then I click "Salvar" and expect duplicate error
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('Código já cadastrado')).toBeVisible();
  });

  /* Negative scenario – invalid CNPJ format */
  test('CNPJ inválido (formato)', async ({ page }) => {
    await goToBankList(page);
    await page.getByRole('button', { name: 'Novo' }).click();

    // Fill all except CNPJ
    await fillBankForm(page, {
      ...bankData,
      'CNPJ': '123', // invalid format
    });

    // Attempt to save
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('CNPJ inválido')).toBeVisible();
  });

  /* Negative scenario – CNPJ not in official registry */
  test('CNPJ não existente no cadastro oficial', async ({ page }) => {
    await goToBankList(page);
    await page.getByRole('button', { name: 'Novo' }).click();

    // Fill all except CNPJ
    await fillBankForm(page, {
      ...bankData,
      'CNPJ': '99.999.999/9999-99', // fake number
    });

    // Attempt to save
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('CNPJ não encontrado no cadastro oficial')).toBeVisible();
  });

  /* Negative scenario – Banco Controlador not selected */
  test('Banco Controlador não selecionado', async ({ page }) => {
    await goToBankList(page);
    await page.getByRole('button', { name: 'Novo' }).click();

    // Leave Banco Controlador empty
    await page.getByLabel('Banco Controlador').selectOption(''); // deselect
    await fillBankForm(page, bankData);

    // Attempt to save
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('Banco Controlador é obrigatório')).toBeVisible();
  });
});

/* ------------------------------------------------------------------
 *  US02 – Edição de Banco Existente
 * ------------------------------------------------------------------ */
test.describe('US02 – Edição de Banco Existente', () => {
  const existingBank = {
    'Código': 'BAN001',
    'Descrição do Banco': 'Banco Teste Nacional',
    'Apelido': 'BTN',
    'Número de inscrição no SBP': '123456',
    'Banco Controlador': 'Banco Central',
    'CNPJ': '12.345.678/0001-90',
  };

  // Helper: open edit form for a given code
  async function openEditForm(page: Page, code: string) {
    await goToBankList(page);
    // Locate the row and click Edit (assuming a button with name "Editar")
    const row = page.getByText(code);
    await row.waitFor({ state: 'visible' });
    await row.getByRole('button', { name: 'Editar' }).click();
  }

  /* Positive scenario – edit description and CNPJ */
  test('Editar descrição e CNPJ de forma válida', async ({ page }) => {
    // Ensure bank exists
    await createBankViaUI(page, existingBank);

    // When I open the record and edit fields
    await openEditForm(page, existingBank['Código']!);
    await page.getByLabel('Descrição do Banco').fill('Banco Teste Editado');
    await page.getByLabel('CNPJ').fill('12.345.678/0001-91');

    // Then I click "Salvar" and verify the changes
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('Alterações salvas com sucesso')).toBeVisible();
    // Verify updated data appears in the list
    await expect(page.getByText('Banco Teste Editado')).toBeVisible();
    await expect(page.getByText('12.345.678/0001-91')).toBeVisible();
  });

  /* Negative scenario – attempt to change Código (disabled) */
  test('Tentar alterar Código (não permitido)', async ({ page }) => {
    await createBankViaUI(page, existingBank);
    await openEditForm(page, existingBank['Código']!);

    // Verify that Código field is visible but disabled
    const codigoInput = page.getByLabel('Código');
    await expect(codigoInput).toBeVisible();
    await expect(codigoInput).toBeDisabled();
  });

  /* Negative scenario – leave mandatory field empty */
  test('Deixar campo obrigatório vazio na edição', async ({ page }) => {
    await createBankViaUI(page, existingBank);
    await openEditForm(page, existingBank['Código']!);

    // Clear the "Apelido" field
    await page.getByLabel('Apelido').fill('');
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('Apelido é obrigatório')).toBeVisible();
  });

  /* Negative scenario – insert invalid CNPJ in edit */
  test('Inserir CNPJ inválido na edição', async ({ page }) => {
    await createBankViaUI(page, existingBank);
    await openEditForm(page, existingBank['Código']!);

    await page.getByLabel('CNPJ').fill('111');
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('CNPJ inválido')).toBeVisible();
  });

  /* Negative scenario – CNPJ not in official registry during edit */
  test('Inserir CNPJ que não existe no cadastro oficial', async ({ page }) => {
    await createBankViaUI(page, existingBank);
    await openEditForm(page, existingBank['Código']!);

    await page.getByLabel('CNPJ').fill('99.999.999/9999-99');
    await page.getByRole('button', { name: 'Salvar' }).click();
    await expect(page.getByText('CNPJ não encontrado no cadastro oficial')).toBeVisible();
  });
});
```

**Observações importantes**

1. **Seletores** – Os testes utilizam o poder do Playwright de localizar elementos por *role* e *label*. Isso garante estabilidade mesmo que o HTML seja refatorado, desde que os textos ou labels permaneçam iguais.

2. **Fluxo de navegação** – Cada cenário começa com `goToBankList(page)` para garantir que a página está no estado inicial. Em cenários que requerem um banco já cadastrado, a função `createBankViaUI` cria o registro antes de prosseguir.

3. **Validações** – A verificação de mensagens de erro ou sucesso usa `expect(...).toBeVisible()`, que já aguarda o elemento aparecer (no máximo o *timeout* configurado pelo Playwright).

4. **Modularidade** – Funções auxiliares (`goToBankList`, `fillBankForm`, `createBankViaUI`, `openEditForm`) evitam repetição de código e tornam os cenários mais legíveis.

5. **Comentários** – Cada bloco de ação tem um comentário explicando a intenção, facilitando a manutenção e a leitura por novos membros da equipe.

6. **Timeouts** – Se o seu ambiente precisar de tempos de espera específicos, basta passar o segundo argumento em `await expect(...).toBeVisible({ timeout: 5000 })`.

7. **Fixtures** – Caso haja necessidade de dados persistentes (ex.: banco já cadastrado via API), você pode substituir `createBankViaUI` por uma chamada de API no fixture `test.beforeEach`.

Com essa estrutura, você tem testes automatizados claros, reutilizáveis e alinhados às melhores práticas do Playwright Test Runner.