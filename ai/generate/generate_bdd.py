import os
from groq import Groq
 
def generate_bdd_from_user_stories():
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))
 
    with open("ai/user_stories/generated_user_stories.feature", "r", encoding="utf-8") as f:
        stories = f.read()
 
    prompt = f"""
    Você é um especialista em BDD.
    Com base nos seguintes histórias de usuários, gere cenários no formato Gherkin (Given, When, Then), 
    foque em criar cenários tanto em casos positivos, quanto em casos negativos.
 
    Critérios:
    {stories}
    """
 
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )
 
    bdd = response.choices[0].message.content
 
    os.makedirs("ai/bdd", exist_ok=True)
    with open("ai/bdd/generated.feature", "w", encoding="utf-8") as f:
        f.write(bdd)
 
if __name__ == "__main__":
    generate_bdd_from_user_stories()