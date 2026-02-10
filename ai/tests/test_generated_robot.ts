Certamente, vou criar o código de teste automatizado funcional para os cenários BDD fornecidos, seguindo as melhores práticas de automação e utilizando a estrutura do Robot Framework.

```python
# Declaração de imports necessários
import os
from robot.api.deco import keyword, library
from robot.api import logger
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Variáveis globais
BROWSER = os.environ.get("BROWSER", "chrome")
URL = "https://example.com/cadastro-banco-nacional"

# Definição da Keyword Library
@library
class CadastroBancoNacional:
    """
    Biblioteca de Keywords para os testes de Cadastro de Banco Nacional.
    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self):
        self.driver = webdriver.Chrome()
        self.driver.get(URL)

    @keyword
    def que_o_especialista_do_banco_esta_na_tela_de_cadastro_de_banco_nacional(self):
        """
        Verifica se o Especialista do Banco está na tela de cadastro de Banco Nacional.
        """
        assert "Cadastro de Banco Nacional" in self.driver.title

    @keyword
    def o_especialista_preencher_todos_os_campos_obrigatorios_corretamente(self, dados_banco):
        """
        Preenche todos os campos obrigatórios corretamente no formulário de cadastro.
        """
        self.driver.find_element(By.ID, "codigo").send_keys(dados_banco["Código"])
        self.driver.find_element(By.ID, "descricao").send_keys(dados_banco["Descrição do Banco"])
        self.driver.find_element(By.ID, "apelido").send_keys(dados_banco["Apelido"])
        self.driver.find_element(By.ID, "numero_sbp").send_keys(dados_banco["Número de inscrição no SBP"])
        self.driver.find_element(By.ID, "banco_controlador").send_keys(dados_banco["Banco controlador"])
        self.driver.find_element(By.ID, "cnpj").send_keys(dados_banco["CNPJ"])

    @keyword
    def clicar_no_botao_salvar(self):
        """
        Clica no botão "Salvar" no formulário de cadastro.
        """
        self.driver.find_element(By.ID, "btn-salvar").click()

    @keyword
    def o_novo_registro_de_banco_nacional_deve_ser_exibido_na_listagem(self):
        """
        Verifica se o novo registro de Banco Nacional foi exibido na listagem.
        """
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, "banco-123"))
        )
        assert self.driver.find_element(By.ID, "banco-123").is_displayed()

    @keyword
    def deve_ser_exibida_uma_mensagem_de_erro_informando_que_o_codigo_ja_esta_cadastrado(self):
        """
        Verifica se uma mensagem de erro é exibida informando que o código já está cadastrado.
        """
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, "error-message"))
        )
        assert "Código já cadastrado" in self.driver.find_element(By.ID, "error-message").text

    @keyword
    def deve_ser_exibida_uma_mensagem_de_erro_informando_que_o_campo_obrigatorio_nao_foi_preenchido(self):
        """
        Verifica se uma mensagem de erro é exibida informando que um campo obrigatório não foi preenchido.
        """
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, "error-message"))
        )
        assert "Campo obrigatório não preenchido" in self.driver.find_element(By.ID, "error-message").text

    @keyword
    def deve_ser_exibida_uma_mensagem_de_erro_informando_que_o_cnpj_e_invalido(self):
        """
        Verifica se uma mensagem de erro é exibida informando que o CNPJ é inválido.
        """
        WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.ID, "error-message"))
        )
        assert "CNPJ inválido" in self.driver.find_element(By.ID, "error-message").text

    @keyword
    def que_o_especialista_do_banco_esta_na_tela_de_edicao_de_um_banco_nacional(self):
        """
        Verifica se o Especialista do Banco está na tela de edição de um Banco Nacional.
        """
        assert "Edição de Banco Nacional" in self.driver.title

    @keyword
    def o_especialista_alterar_os_campos_permitidos(self, dados_banco):
        """
        Altera os campos permitidos no formulário de edição de Banco Nacional.
        """
        self.driver.find_element(By.ID, "descricao").clear()
        self.driver.find_element(By.ID, "descricao").send_keys(dados_banco["Descrição do Banco"])
        self.driver.find_element(By.ID, "apelido").clear()
        self.driver.find_element(By.ID, "apelido").send_keys(dados_banco["Apelido"])
        self.driver.find_element(By.ID, "numero_sbp").clear()
        self.driver.find_element(By.ID, "numero_sbp").send_keys(dados_banco["Número de inscrição no SBP"])
        self.driver.find_element(By.ID, "banco_controlador").clear()
        self.driver.find_element(By.ID, "banco_controlador").send_keys(dados_banco["Banco controlador"])
        self.driver.find_element(By.ID, "cnpj").clear()
        self.driver.find_element(By.ID, "cnpj").send_keys(dados_banco["CNPJ"])

    @keyword
    def o_campo_codigo_deve_estar_desabilitado_e_nao_permitir_a_edicao(self):
        """
        Verifica se o campo "Código" está desabilitado e não permite a edição.
        """
        codigo_campo = self.driver.find_element(By.ID, "codigo")
        assert codigo_campo.get_attribute("disabled") == "true"

    @keyword
    def o_registro_de_banco_nacional_deve