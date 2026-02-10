import os
from anthropic import Anthropic


def generated_analysis():
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise RuntimeError("❌ CLAUDE_API_KEY não definida")

    model = os.getenv("CLAUDE_MODEL", "claude-3-haiku-20240307")

    # ==============================
    # Cliente Claude
    # ==============================
    client = Anthropic(api_key=api_key)

    # ==============================
    # Leitura do log de erros
    # ==============================
    with open("erros.txt", "r", encoding="utf-8") as f:
        erros = f.read()

    # ==============================
    # Prompt
    # ==============================
    prompt = f"""
Você é um especialista em testes automatizados com Playwright.

Analise o log abaixo e explique de forma clara e detalhada:

1. Quais testes falharam
2. O motivo de cada falha
3. Sugestões práticas de como corrigir os erros

Log do Playwright:
{erros}
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

    analise = response.content[0].text

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/analysis", exist_ok=True)
    with open(
        "ai/analysis/analise_ia.txt",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(analise)


if __name__ == "__main__":
    generated_analysis()
