import os
import google.generativeai as genai


def generate_bdd_from_user_stories():
    # Configuração da API do Gemini via Secret
    genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

    model = genai.GenerativeModel("gemini-1.5-pro")

    with open(
        "ai/user_stories/generated_user_stories.txt",
        "r",
        encoding="utf-8"
    ) as f:
        stories = f.read()

    prompt = f"""
Você é um especialista em BDD (Behavior Driven Development) e qualidade de software.

Com base nas seguintes User Stories, gere **cenários de teste completos**
utilizando a **sintaxe Gherkin (Given, When, Then)**.

Siga estas diretrizes:
- Crie **cenários positivos** (fluxos esperados) e **cenários negativos**
  (erros, validações e exceções).
- Cada cenário deve ser **claro, conciso e testável**.
- Evite redundâncias entre cenários.
- Utilize linguagem natural e objetiva.
- Cada User Story deve conter **vários cenários relevantes**, quando aplicável.
- Cubra as principais regras de negócio.

Retorne EXATAMENTE no seguinte padrão:

titulo: Título da User Story
cenario_bdd:
  nome: Nome descritivo do cenário
  tipo: positivo ou negativo
  gherkin: |
    Feature: ...
    Scenario: ...
      Given ...
      When ...
      Then ...

User Stories fornecidas:
{stories}
"""

    response = model.generate_content(prompt)

    bdd = response.text

    os.makedirs("ai/bdd", exist_ok=True)
    with open("ai/bdd/generated.txt", "w", encoding="utf-8") as f:
        f.write(bdd)


if __name__ == "__main__":
    generate_bdd_from_user_stories()
