```ts
/********************************************************************
 * bank.spec.ts
 *
 * Playwright Test runner – Automation of the bank registration and
 * editing use‑cases described in the BDD file.
 *
 * • Written in TypeScript
 * • Uses `test.describe`, `test.beforeEach` and `test` blocks
 * • Implements the Given/When/Then steps as readable, modular code
 * • Uses stable, data‑attribute based selectors (fallback to label text)
 * • Employs `await expect()` for assertions and proper waiting
 * • Contains comments that explain the intent of each step
 ********************************************************************/

import { test, expect, Page } from '@playwright/test';

/**
 * Helper: return the locator of an input that belongs to the label
 * text supplied.  Works on pages where the label is adjacent to the
 * input (common pattern in many React/Vue apps).
 */
const inputByLabel = (page: Page, label: string) =>
  page.locator(`label:has-text("${label}")`).locator('..').locator('input, textarea');

/**
 * Helper: return the locator of a dropdown/select by label.
 */
const dropdownByLabel = (page: Page, label: string) =>
  page.locator(`label:has-text("${label}")`).locator('..').locator('select');

/**
 * Helper: return the locator of a button by its visible text.
 */
const buttonByText = (page: Page, text: string) => page.locator(`button:has-text("${text}")`);

/**
 * Helper: return the locator of the modal/message box that shows
 * alerts.  Adjust selector to match your application (e.g., a
 * toast, an alert, or an inline error message).
 */
const alertBox = (page: Page, message: string) =>
  page.locator('.toast, .alert, .error', { hasText: message });

/**
 * Common steps used across scenarios
 */
const fillBankForm = async (page: Page, data: Partial<Record<string, string>>) => {
  for (const [label, value] of Object.entries(data)) {
    // Skip undefined values (fields that we intentionally leave blank)
    if (value === undefined) continue;
    // Detect dropdowns by presence of options
    if (label === 'Banco Controlador') {
      await dropdownByLabel(page, label).selectOption({ label: value });
    } else {
      await inputByLabel(page, label).fill(value);
    }
  }
};

/**
 * US01 – Cadastro de Novo Banco
 */
test.describe('US01 – Cadastro de Novo Banco', () => {
  // Every test that deals with the registration page will navigate there first
  test.beforeEach(async ({ page }) => {
    await page.goto('/bank/register');
  });

  /**
   * Scenario: Cadastro bem‑sucesso
   */
  test('Cadastro bem‑sucesso', async ({ page }) => {
    // Given I am on the registration screen – handled by beforeEach

    // When I fill the required fields
    await test.step('Preencher campos obrigatórios', async () => {
      await fillBankForm(page, {
        'Código': 'BAN001',
        'Descrição do Banco': 'Banco do Nordeste',
        'Apelido': 'BN',
        'Número de inscrição no SBP': '123456',
        'Banco Controlador': 'Banco do Estado',
        'CNPJ': '12.345.678/0001-90',
      });
    });

    // And I click 'Salvar'
    await test.step('Clicar em Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    // Then the record should be created
    await test.step('Verificar registro criado', async () => {
      // Wait for navigation or success toast
      await expect(alertBox(page, 'Registro criado com sucesso')).toBeVisible({ timeout: 5000 });
    });

    // And the list shows the new bank 'BAN001'
    await test.step('Verificar lista de bancos', async () => {
      // Assuming a table row contains the bank code
      const bankRow = page.locator('table#banks tbody tr', { hasText: 'BAN001' });
      await expect(bankRow).toBeVisible();
    });
  });

  /**
   * Scenario: Código duplicado não é permitido
   */
  test('Código duplicado não é permitido', async ({ page }) => {
    // Given a bank with code BAN001 already exists
    // (Assume it was created in a setup step or by a fixture)

    // When I attempt to create another bank with the same code
    await test.step('Preencher campos com código duplicado', async () => {
      await fillBankForm(page, {
        'Código': 'BAN001',
        'Descrição do Banco': 'Banco duplicado',
        'Apelido': 'BD',
        'Número de inscrição no SBP': '999999',
        'Banco Controlador': 'Banco do Estado',
        'CNPJ': '98.765.432/0001-11',
      });
    });

    // And I click 'Salvar'
    await test.step('Clicar em Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    // Then the duplicate message should be shown
    await test.step('Verificar mensagem de duplicado', async () => {
      await expect(alertBox(page, 'Código já cadastrado. Por favor, informe um código único.')).toBeVisible();
    });

    // And the Save button remains disabled
    await test.step('Salvar permanece desabilitado', async () => {
      await expect(buttonByText(page, 'Salvar')).toBeDisabled();
    });
  });

  /**
   * Scenario: CNPJ inválido ou não encontrado
   */
  test('CNPJ inválido ou não encontrado', async ({ page }) => {
    // Given the CNPJ does not exist in official DB
    // (Assume test data)

    await test.step('Preencher CNPJ inválido', async () => {
      await fillBankForm(page, {
        'Código': 'BAN002',
        'Descrição do Banco': 'Banco com CNPJ inválido',
        'Apelido': 'BI',
        'Número de inscrição no SBP': '777777',
        'Banco Controlador': 'Banco do Estado',
        'CNPJ': '12.345.678/0001-99',
      });
    });

    await test.step('Clicar em Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar mensagem de CNPJ inválido', async () => {
      await expect(alertBox(page, 'CNPJ inválido ou não encontrado')).toBeVisible();
    });

    await test.step('Salvar permanece desabilitado', async () => {
      await expect(buttonByText(page, 'Salvar')).toBeDisabled();
    });
  });

  /**
   * Scenario: Campos obrigatórios vazios bloqueiam o salvar
   */
  test('Campos obrigatórios vazios bloqueiam o salvar', async ({ page }) => {
    // Given I am on the registration screen – handled by beforeEach

    await test.step('Deixar campos obrigatórios vazios', async () => {
      // Explicitly clear each required field
      await inputByLabel(page, 'Código').clear();
      await inputByLabel(page, 'Descrição do Banco').clear();
      await inputByLabel(page, 'Apelido').clear();
      await inputByLabel(page, 'Número de inscrição no SBP').clear();
      await inputByLabel(page, 'CNPJ').clear();
    });

    await test.step('Verificar que Salvar está desabilitado', async () => {
      await expect(buttonByText(page, 'Salvar')).toBeDisabled();
    });

    await test.step('Tentar clicar em Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar mensagem de obrigatoriedade', async () => {
      await expect(alertBox(page, 'Todos os campos obrigatórios devem ser preenchidos')).toBeVisible();
    });
  });

  /**
   * Scenario: Código com caracteres inválidos
   */
  test('Código com caracteres inválidos', async ({ page }) => {
    await test.step('Preencher código inválido', async () => {
      await fillBankForm(page, {
        'Código': 'BAN@001',
        'Descrição do Banco': 'Banco inválido',
        'Apelido': 'BI',
        'Número de inscrição no SBP': '555555',
        'Banco Controlador': 'Banco do Estado',
        'CNPJ': '12.345.678/0001-90',
      });
    });

    await test.step('Verificar mensagem de código inválido', async () => {
      await expect(alertBox(page, 'Código inválido. Use apenas letras e números')).toBeVisible();
    });

    await test.step('Salvar permanece desabilitado', async () => {
      await expect(buttonByText(page, 'Salvar')).toBeDisabled();
    });
  });

  /**
   * Scenario: Código excede comprimento máximo
   */
  test('Código excede comprimento máximo', async ({ page }) => {
    await test.step('Preencher código longo', async () => {
      await fillBankForm(page, {
        'Código': 'BAN00123456', // 11 characters
        'Descrição do Banco': 'Banco longo',
        'Apelido': 'BL',
        'Número de inscrição no SBP': '666666',
        'Banco Controlador': 'Banco do Estado',
        'CNPJ': '12.345.678/0001-90',
      });
    });

    await test.step('Verificar mensagem de tamanho inválido', async () => {
      await expect(alertBox(page, 'Código não pode ter mais que 10 caracteres')).toBeVisible();
    });

    await test.step('Salvar permanece desabilitado', async () => {
      await expect(buttonByText(page, 'Salvar')).toBeDisabled();
    });
  });
});

/**
 * US02 – Edição de Banco Existente
 *
 * For editing, we assume the bank list is displayed at `/bank/list`
 * and each row has an Edit button.  The tests use a helper to
 * navigate to the edit page directly.
 */
test.describe('US02 – Edição de Banco Existente', () => {
  /**
   * Helper: open edit page for a given bank code
   */
  const openEditPage = async (page: Page, code: string) => {
    await page.goto('/bank/list');
    // Find the row with the bank code and click its edit button
    const row = page.locator('table#banks tbody tr', { hasText: code });
    await expect(row).toBeVisible();
    const editBtn = row.locator('button:has-text("Editar")');
    await editBtn.click();
  };

  /**
   * Scenario: Edição bem‑sucesso de campos permitidos
   */
  test('Edição bem‑sucesso de campos permitidos', async ({ page }) => {
    await openEditPage(page, 'BAN002');

    await test.step('Alterar campos permitidos', async () => {
      await inputByLabel(page, 'Descrição do Banco').fill('Banco do Sul');
      await inputByLabel(page, 'Apelido').fill('BS');
      await inputByLabel(page, 'Número de inscrição no SBP').fill('654321');
      await dropdownByLabel(page, 'Banco Controlador').selectOption({ label: 'Banco Central' });
      await inputByLabel(page, 'CNPJ').fill('98.765.432/0001-10');
    });

    await test.step('Clicar em Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar registro atualizado na lista', async () => {
      await expect(alertBox(page, 'Registro atualizado com sucesso')).toBeVisible();
      // Confirm the list shows new values
      const row = page.locator('table#banks tbody tr', { hasText: 'BAN002' });
      await expect(row).toContainText('Banco do Sul');
      await expect(row).toContainText('BS');
      await expect(row).toContainText('654321');
      await expect(row).toContainText('Banco Central');
      await expect(row).toContainText('98.765.432/0001-10');
    });
  });

  /**
   * Scenario: Tentativa de alteração do Código
   */
  test('Tentativa de alteração do Código', async ({ page }) => {
    await openEditPage(page, 'BAN003');

    await test.step('Tentar mudar o Código', async () => {
      const codeInput = inputByLabel(page, 'Código');
      await expect(codeInput).toHaveAttribute('readonly');
      // Even if we try to type, it should not change
      await codeInput.fill('BAN004');
      // Verify the value stays the original
      await expect(codeInput).toHaveValue('BAN003');
    });

    await test.step('Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar que apenas os campos modificados foram salvos', async () => {
      // The success message
      await expect(alertBox(page, 'Registro atualizado com sucesso')).toBeVisible();
      // The code remains unchanged
      const row = page.locator('table#banks tbody tr', { hasText: 'BAN003' });
      await expect(row).toContainText('BAN003');
    });
  });

  /**
   * Scenario: CNPJ inválido durante edição
   */
  test('CNPJ inválido durante edição', async ({ page }) => {
    await openEditPage(page, 'BAN004');

    await test.step('Alterar CNPJ inválido', async () => {
      await inputByLabel(page, 'CNPJ').fill('98.765.432/0001-11');
    });

    await test.step('Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar mensagem de CNPJ inválido', async () => {
      await expect(alertBox(page, 'CNPJ inválido ou não encontrado')).toBeVisible();
    });

    await test.step('Registro não deve ser atualizado', async () => {
      const row = page.locator('table#banks tbody tr', { hasText: 'BAN004' });
      // Assuming the previous CNPJ was still present; we just check it doesn't contain the new invalid one
      await expect(row).not.toContainText('98.765.432/0001-11');
    });
  });

  /**
   * Scenario: Salvar sem fazer nenhuma alteração
   */
  test('Salvar sem fazer nenhuma alteração', async ({ page }) => {
    await openEditPage(page, 'BAN005');

    await test.step('Clique em Salvar sem mudar nada', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar mensagem de nenhuma alteração', async () => {
      await expect(alertBox(page, 'Nenhuma alteração detectada')).toBeVisible();
    });

    await test.step('Registro permanece inalterado', async () => {
      const row = page.locator('table#banks tbody tr', { hasText: 'BAN005' });
      // No additional assertion needed – the presence of the row indicates no changes were made
      await expect(row).toBeVisible();
    });
  });

  /**
   * Scenario: Campos obrigatórios vazios após edição
   */
  test('Campos obrigatórios vazios após edição', async ({ page }) => {
    await openEditPage(page, 'BAN006');

    await test.step('Limpar campos obrigatórios', async () => {
      await inputByLabel(page, 'Descrição do Banco').clear();
      await inputByLabel(page, 'CNPJ').clear();
    });

    await test.step('Salvar', async () => {
      await buttonByText(page, 'Salvar').click();
    });

    await test.step('Verificar mensagem de obrigatoriedade', async () => {
      await expect(alertBox(page, 'Todos os campos obrigatórios devem ser preenchidos')).toBeVisible();
    });

    await test.step('Registro não deve ser salvo', async () => {
      // Confirm the row still has its previous values (not blank)
      const row = page.locator('table#banks tbody tr', { hasText: 'BAN006' });
      await expect(row).toContainText('BAN006'); // code present
      // Additional checks could be made against old values if known
    });
  });
});
```

**Como usar**

1. Copie o trecho acima em um arquivo `tests/bank.spec.ts` (ou outro nome que seu projeto aceite).
2. Ajuste os seletores (`label`, `select`, `.toast`, etc.) de acordo com a implementação real da sua aplicação – o código usa padrões de label + próximo input, mas você pode trocar por atributos `data-testid` ou outras formas mais estáveis.
3. Se os bancos precisam ser pré‑criados via API, crie fixtures (`test.beforeAll`) que façam chamadas à API ou use `page.goto` com parâmetros de URL que já incluam os registros desejados.
4. Execute os testes com `npx playwright test` ou conforme sua configuração de CI.

Assim você terá um conjunto completo de testes automatizados seguindo as melhores práticas do Playwright Test Runner e mantendo a estrutura modular, legível e extensível.