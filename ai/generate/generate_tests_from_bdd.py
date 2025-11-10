import os
from groq import Groq
 
def generate_tests_from_bdd():

     # Utilização do CICD usando secrets
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))

    # Geração utilizando front end usando .env
    # client = Groq(api_key=("API_GROQ"))

  # GROQ
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))

    prompt_tipo = os.getenv("PROMPT_TIPO", "default").lower()
    prompt_path = f"ai/prompts/{prompt_tipo}.txt"

    if not os.path.exists(prompt_path):
        raise FileNotFoundError(f"❌ Arquivo de prompt não encontrado: {prompt_path}")

    with open(prompt_path, "r", encoding="utf-8") as f:
        prompt_base = f.read()
 
    with open("ai/bdd/generated.txt", "r", encoding="utf-8") as f:
        bdd_content = f.read()
 
 
    prompt = f"{prompt_base}\n\nArquivo BDD fornecido:\n{bdd_content}"


# GROQ
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )

# GEMINI
   # model = genai.GenerativeModel("gemini-1.5-pro")
   #  response = model.generate_content(prompt)
 
    tests_code = response.choices[0].message.content
 
    os.makedirs("ai/tests", exist_ok=True)
    with open(f"ai/tests/test_generated_{prompt_tipo}.ts", "w", encoding="utf-8") as f:
        f.write(tests_code)
 
 
if __name__ == "__main__":
    generate_tests_from_bdd()
 
