import os
from groq import Groq
 
def generated_analysis():

# Geração utilizando front end usando .env
    # client = Groq(api_key=("API_GROQ"))
    
    # Utilização do CICD usando secrets
    client = Groq(api_key=os.getenv("GEMINI_API_KEY"))
 
    with open("erros.txt", "r", encoding="utf-8") as f:
        erros = f.read()
 
    prompt = f"""
    Você é um especialista em testes automatizados com Playwright.
            Analise o log abaixo e explique de forma clara e detalhada:
            1. Quais testes falharam.
            2. O motivo de cada falha.
            3. Sugestões de como corrigir os erros.

            Log do Playwright:
            {erros}
    """
 
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[{"role": "user", "content": prompt}]
    )
 
    analise = response.choices[0].message.content
 
    os.makedirs("ai/analysis", exist_ok=True)
    with open("ai/analysis/analise_ia.txt", "w", encoding="utf-8") as f:
        f.write(analise)
 
if __name__ == "__main__":
    generated_analysis()