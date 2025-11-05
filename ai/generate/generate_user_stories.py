import os
from groq import Groq
 
def generate_user_stories_from_criterios():
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))
 
    with open("ai/requirements/criterios.md", "r", encoding="utf-8") as f:
        criterio_content = f.read()
 
    prompt = f"""
    Você é um especialista em criação de user stories.
    Com base nos seguintes critérios de aceite, gere histórias de usuários 
    consistentes que ajude a identificar as necessidades do usuário e tratar todas as Features da melhor forma.

    Critérios:
 
    {criterio_content}
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
 