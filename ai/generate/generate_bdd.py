import os
from groq import Groq
 
def generate_bdd_from_user_stories():
    
 # Utilização do CICD usando secrets
    # client = Groq(api_key=os.getenv("GROQ_API_KEY"))

    # Geração utilizando front end usando .env
    client = Groq(api_key=("API_GROQ"))
 
    with open("ai/user_stories/generated_user_stories.txt", "r", encoding="utf-8") as f:
        stories = f.read()
 
    prompt = f"""
Você é um especialista em BDD (Behavior Driven Development) e qualidade de software.

Com base nas seguintes User Stories, gere **cenários de teste completos** utilizando a **sintaxe Gherkin (Given, When, Then)**.

Siga estas diretrizes:
- Crie **cenários positivos** (fluxos esperados) e **cenários negativos** (erros, validações e exceções).
- Cada cenário deve ser **claro, conciso e testável**, refletindo fielmente os critérios de aceite da história.
- Evite redundâncias entre cenários.
- Utilize uma linguagem natural e objetiva, mantendo a estrutura formal do Gherkin.
- Cada User Story deve conter **vários cenários relevantes**, se aplicável.
- Assegure-se de que os cenários cubram as principais variações e regras de negócio descritas.

Retorne o resultado no seguinte padrão:
    titulo: Título da User Story,
    cenario_bdd:
        nome: Nome descritivo do cenário,
        tipo: positivo ou negativo,
        gherkin: "Feature: ...\\nScenario: ...\\nGiven ...\\nWhen ...\\nThen ..."

User Stories fornecidas:
{stories}
"""

 
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )
 
    bdd = response.choices[0].message.content
 
    os.makedirs("ai/bdd", exist_ok=True)
    with open("ai/bdd/generated.txt", "w", encoding="utf-8") as f:
        f.write(bdd)
 
if __name__ == "__main__":
    generate_bdd_from_user_stories()
