import os
import base64
from groq import Groq

def generate_user_stories_from_criterios():
    client = Groq(api_key=("SUA_API_KEY_AQUI"))

    with open("ai/requirements/criterios.md", "r", encoding="utf-8") as f:
        all_contents = f.read()

    # for filename in os.listdir(requirements_dir):
    #     filepath = os.path.join(requirements_dir, filename)
        
    #     if os.path.isfile(filepath):
    #         try:
    #             with open(filepath, "r", encoding="utf-8") as f:
    #                 content = f.read()
    #                 all_contents += f"\n---\nArquivo: {filename}\n{content}\n"
    #         except UnicodeDecodeError:
    #             with open(filepath, "rb") as f:
    #                 content = base64.b64encode(f.read()).decode("utf-8")
    #                 all_contents += f"\n---\nArquivo binário: {filename}\n(Base64 codificado)\n{content}\n"

    prompt = f"""
Você é um especialista em análise de requisitos e criação de User Stories ágeis.

Com base nos seguintes critérios de aceite (em texto ou base64), gere um conjunto de User Stories completas, claras e consistentes.  
Cada User Story deve:
- Ser escrita no formato: “Como [tipo de usuário], eu quero [objetivo] para [benefício/valor de negócio]”.
- Conter uma **descrição detalhada** da funcionalidade ou necessidade.
- Incluir **critérios de aceite objetivos**.
- Ser **realista**, **testável** e **relacionada às features** descritas nos critérios de aceite.
- Garantir **coerência entre as histórias** e **não sobreposição** de escopo.
- Priorizar clareza e valor para o usuário final.
- Coloque uma rastreabilidade de user stories, exemplo: (US01)

Critérios fornecidos:
{all_contents}
"""


    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )

    tests_code = response.choices[0].message.content

    os.makedirs("ai/user_stories", exist_ok=True)
    with open("ai/user_stories/generated_user_stories.txt", "w", encoding="utf-8") as f:
        f.write(tests_code)

if __name__ == "__main__":
    generate_user_stories_from_criterios()
