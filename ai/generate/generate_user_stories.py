import os
import base64
from groq import Groq

def generate_user_stories_from_criterios():
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))

    requirements_dir = "ai/requirements"
    all_contents = ""

    for filename in os.listdir(requirements_dir):
        filepath = os.path.join(requirements_dir, filename)
        
        if os.path.isfile(filepath):
            try:
                with open(filepath, "r", encoding="utf-8") as f:
                    content = f.read()
                    all_contents += f"\n---\nArquivo: {filename}\n{content}\n"
            except UnicodeDecodeError:
                with open(filepath, "rb") as f:
                    content = base64.b64encode(f.read()).decode("utf-8")
                    all_contents += f"\n---\nArquivo binário: {filename}\n(Base64 codificado)\n{content}\n"

    prompt = f"""
    Você é um especialista em criação de user stories.
    Com base nos seguintes critérios de aceite (em texto ou base64), gere histórias de usuários
    consistentes que ajudem a identificar as necessidades do usuário e tratar todas as Features da melhor forma.

    Critérios:

    {all_contents}
    """

    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )

    tests_code = response.choices[0].message.content

    os.makedirs("ai/user_stories", exist_ok=True)
    with open("ai/user_stories/generated_user_stories.feature", "w", encoding="utf-8") as f:
        f.write(tests_code)

if __name__ == "__main__":
    generate_user_stories_from_criterios()
