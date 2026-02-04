import os
from google import genai


def generate_user_stories_from_criterios():
    api_key = os.getenv("GEMINI_API_KEY")

    if not api_key:
        raise RuntimeError("❌ GEMINI_API_KEY não definida")

    # Cliente Gemini (SDK novo e oficial)
    client = genai.Client(api_key=api_key)

    with open(
        "ai/requirements/criterios.md",
        "r",
        encoding="utf-8"
    ) as f:
        all_contents = f.read()

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

    response = client.models.generate_content(
        model="gemini-1.5-pro",
        contents=prompt
    )

    os.makedirs("ai/user_stories", exist_ok=True)
    with open(
        "ai/user_stories/generated_user_stories.txt",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(response.text)


if __name__ == "__main__":
    generate_user_stories_from_criterios()
