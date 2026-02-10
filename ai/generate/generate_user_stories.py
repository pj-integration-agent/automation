import os
from anthropic import Anthropic


def generate_user_stories_from_criterios():
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise RuntimeError("❌ CLAUDE_API_KEY não definida")

    model = os.getenv("CLAUDE_MODEL", "claude-3-haiku-20240307")

    # ==============================
    # Cliente Claude
    # ==============================
    client = Anthropic(api_key=api_key)

    # ==============================
    # Leitura dos critérios
    # ==============================
    with open(
        "ai/requirements/criterios.md",
        "r",
        encoding="utf-8"
    ) as f:
        all_contents = f.read()

    # ==============================
    # Prompt
    # ==============================
    prompt = f"""
Você é um especialista em análise de requisitos e criação de User Stories ágeis.

Com base nos critérios abaixo, gere User Stories completas.

Regras:
- Formato: "Como [tipo de usuário], eu quero [objetivo] para [benefício]"
- Descrição detalhada
- Critérios de aceite objetivos
- Rastreabilidade (US01, US02...)

Critérios:
{all_contents}
"""

    # ==============================
    # Chamada à API Claude
    # ==============================
    response = client.messages.create(
        model=model,
        max_tokens=1200,
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    user_stories_text = response.content[0].text

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/user_stories", exist_ok=True)
    with open(
        "ai/user_stories/generated_user_stories.txt",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(user_stories_text)


if __name__ == "__main__":
    generate_user_stories_from_criterios()
