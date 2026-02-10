import os
from anthropic import Anthropic


def generate_bdd_from_user_stories():
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise RuntimeError("❌ CLAUDE_API_KEY não definida")

    model = os.getenv("CLAUDE_MODEL", "claude-3-haiku-20240307")

    # ==============================
    # Cliente Claude
    # ==============================
    client = Anthropic(api_key=api_key)

    # ==============================
    # Leitura das User Stories
    # ==============================
    with open(
        "ai/user_stories/generated_user_stories.txt",
        "r",
        encoding="utf-8"
    ) as f:
        stories = f.read()

    # ==============================
    # Prompt
    # ==============================
    prompt = f"""
Você é um especialista em BDD (Behavior Driven Development) e qualidade de software.

Com base nas seguintes User Stories, gere **cenários de teste completos**
utilizando a **sintaxe Gherkin (Given, When, Then)**.

Diretrizes obrigatórias:
- Criar **cenários positivos** (fluxos esperados)
- Criar **cenários negativos** (erros, validações, exceções)
- Cada cenário deve ser **claro, conciso e testável**
- Evitar redundância entre cenários
- Linguagem objetiva e natural
- Cada User Story pode gerar **vários cenários**
- Cobrir regras de negócio principais

Formato EXATO de saída:

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

User Stories:
{stories}
"""

    # ==============================
    # Chamada à API Claude
    # ==============================
    response = client.messages.create(
        model=model,
        max_tokens=1500,
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    bdd_text = response.content[0].text

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/bdd", exist_ok=True)
    with open(
        "ai/bdd/generated.feature",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(bdd_text)


if __name__ == "__main__":
    generate_bdd_from_user_stories()
