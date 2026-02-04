import os
import google.generativeai as genai


def generate_user_stories_from_criterios():
    # Configuração da API Gemini via Secrets (CI/CD)
    genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

    model = genai.GenerativeModel("gemini-1.5-pro")

    with open(
        "ai/requirements/criterios.md",
        "r",
        encoding="utf-8"
    ) as f:
        all_contents = f.read()

    prompt = f"""
Você é um especialista em análise de requisitos e criação de User Stories ágeis.

Com base nos seguintes critérios de aceite, gere um conjunto de User Stories
**completas, claras e consistentes**.

Cada User Story deve:
- Seguir o formato:
  "Como [tipo de usuário], eu quero [objetivo] para [benefício/valor de negócio]"
- Conter uma **descrição detalhada**
- Incluir **critérios de aceite objetivos**
- Ser **realista, testável e coerente**
- Evitar sobreposição de escopo
- Conter **rastreabilidade**, exemplo: (US01, US02...)

Retorne no formato abaixo:

US01
Título:
Descrição:
Critérios de Aceite:
- ...

Critérios fornecidos:
{all_contents}
"""

    response = model.generate_content(prompt)

    user_stories = response.text

    os.makedirs("ai/user_stories", exist_ok=True)
    with open(
        "ai/user_stories/generated_user_stories.txt",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(user_stories)


if __name__ == "__main__":
    generate_user_stories_from_criterios()
