Certamente, vou criar o código de teste automatizado funcional utilizando a estrutura do Robot Framework, seguindo as melhores práticas de automação. Aqui está o código:

```python
# Declaração de imports necessários
import os
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Biblioteca personalizada
@library
class LoginPageKeywords:
    """Keywords relacionadas à página de login"""

    def __init__(self):
        self.driver = BuiltIn().get_library_instance("SeleniumLibrary").driver

    # Cenário: Realizar login com credenciais válidas
    @keyword
    def que_o_cliente_acessa_a_pagina_de_login(self):
        """Abre a página de login do sistema"""
        self.driver.get("https://www.example.com/login")

    @keyword
    def o_cliente_preenche_o_username_e_a_senha(self, username, password):
        """Preenche os campos de username e senha"""
        self.driver.find_element(By.ID, "username").send_keys(username)
        self.driver.find_element(By.ID, "password").send_keys(password)

    @keyword
    def clica_no_botao_de_login(self):
        """Clica no botão de login"""
        self.driver.find_element(By.ID, "login-button").click()

    @keyword
    def o_sistema_autentica_as_credenciais(self):
        """Verifica se as credenciais foram autenticadas com sucesso"""
        wait = WebDriverWait(self.driver, 10)
        home_page = wait.until(EC.presence_of_element_located((By.ID, "home-page")))
        assert home_page.is_displayed()

    @keyword
    def concede_acesso_ao_sistema(self):
        """Verifica se o acesso foi concedido ao sistema"""
        assert "Bem-vindo" in self.driver.title

    @keyword
    def exibe_a_pagina_inicial_do_sistema(self):
        """Verifica se a página inicial do sistema é exibida"""
        assert "Página Inicial" in self.driver.page_source

    # Cenário: Realizar login com credenciais inválidas
    @keyword
    def o_cliente_preenche_o_username_e_a_senha_invalidos(self, username, password):
        """Preenche os campos de username e senha com valores inválidos"""
        self.driver.find_element(By.ID, "username").send_keys(username)
        self.driver.find_element(By.ID, "password").send_keys(password)

    @keyword
    def o_sistema_nao_autentica_as_credenciais(self):
        """Verifica se as credenciais não foram autenticadas"""
        wait = WebDriverWait(self.driver, 10)
        error_message = wait.until(EC.presence_of_element_located((By.ID, "login-error")))
        assert error_message.is_displayed()

    @keyword
    def exibe_uma_mensagem_de_erro_informando_que_as_credenciais_sao_invalidas(self):
        """Verifica se a mensagem de erro sobre credenciais inválidas é exibida"""
        assert "Credenciais inválidas" in self.driver.page_source

    # Cenário: Realizar login com campos vazios
    @keyword
    def o_cliente_nao_preenche_o_username_e_a_senha(self):
        """Deixa os campos de username e senha vazios"""
        pass

    @keyword
    def exibe_uma_mensagem_de_erro_informando_que_os_campos_sao_obrigatorios(self):
        """Verifica se a mensagem de erro sobre campos obrigatórios é exibida"""
        wait = WebDriverWait(self.driver, 10)
        error_message = wait.until(EC.presence_of_element_located((By.ID, "required-fields-error")))
        assert error_message.is_displayed()

@library
class ATMKeywords:
    """Keywords relacionadas ao serviço de ATM"""

    def __init__(self):
        self.driver = BuiltIn().get_library_instance("SeleniumLibrary").driver

    # Cenário: Sacar dinheiro com saldo suficiente
    @keyword
    def que_o_cliente_acessa_o_servico_de_atm(self):
        """Abre a página do serviço de ATM"""
        self.driver.get("https://www.example.com/atm")

    @keyword
    def o_cliente_possui_saldo_de_r_em_sua_conta(self, saldo):
        """Simula o saldo da conta do cliente"""
        self.saldo = float(saldo)

    @keyword
    def o_cliente_seleciona_a_opcao_de_saque(self):
        """Seleciona a opção de saque no serviço de ATM"""
        self.driver.find_element(By.ID, "withdraw-button").click()

    @keyword
    def o_cliente_informa_o_valor_de_r_para_saque(self, valor):
        """Informa o valor de saque"""
        self.driver.find_element(By.ID, "withdraw-amount").send_keys(valor)

    @keyword
    def o_sistema_valida_o_saldo(self):
        """Verifica se o saldo é suficiente para o saque"""
        assert self.saldo >= float(self.driver.find_element(By.ID, "withdraw-amount").get_attribute("value"))

    @keyword
    def realiza_o_saque_da_conta(self):
        """Realiza o saque da conta"""
        self.saldo -= float(self.driver.find_element(By.ID, "withdraw-amount").get_attribute("value"))

    @keyword
    def atualiza_o_saldo_da_conta_para_r(self, novo_saldo):
        """Atualiza o saldo da conta"""
        assert abs(self.saldo - float(novo_saldo)) < 0.01

    @keyword
    def exibe_uma_mensagem_de_sucesso_informando_o_valor_sacado(self):
        """Verifica se a mensagem de sucesso é exibida"""
        assert f"Saque de R$ {self.driver.find_element(By.ID, 'withdraw-amount').get_attribute('value')} realizado com sucesso" in self.driver.page_source

    # Cenário: Sacar dinheiro com saldo insuficiente
    @keyword
    def o_sistema_exibe_uma_mensagem_de_erro_informando_que_o_saldo_e_insuficiente(self):
        