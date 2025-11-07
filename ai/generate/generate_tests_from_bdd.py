import os
from groq import Groq
 
def generate_tests_from_bdd():
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))
 
    with open("ai/bdd/generated.feature", "r", encoding="utf-8") as f:
        bdd_content = f.read()
 
    prompt = f"""
Você é um engenheiro de automação de testes sênior, especialista em Robot framework.

Com base no seguinte arquivo BDD (formato Gherkin), converta-o em **código de teste automatizado funcional**, seguindo as **melhores práticas de automação**.

Diretrizes obrigatórias:
- Utilize a **estrutura do Robot frameworkr**.
- Implemente os **cenários Given/When/Then** como testes organizados e legíveis.
- Inclua:
  - Declaração de imports necessários.
  - Uso correto do `variables`, `keyWords`, e `test cases` para os cenários.
  - **Seletores claros e estáveis**, com boas práticas de localização de elementos.
  - **Tratamento de esperas e erros** com `sleep` adequados.
  - **Comentários explicativos** antes de cada passo descrevendo a intenção e a lógica.
- Mantenha a **estrutura modular e reutilizável**, facilitando manutenção futura.

Arquivo BDD fornecido:
{bdd_content}
"""

 
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )
 
    tests_code = response.choices[0].message.content
 
    os.makedirs("ai/tests", exist_ok=True)
    with open("ai/tests/test_generated.ts", "w", encoding="utf-8") as f:
        f.write(tests_code)
 
 
if __name__ == "__main__":
    generate_tests_from_bdd()
 
