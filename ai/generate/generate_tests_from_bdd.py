import os
from anthropic import Anthropic


def generate_tests_from_bdd():
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise RuntimeError("❌ CLAUDE_API_KEY não definida")

    model = os.getenv("CLAUDE_MODEL", "claude-3-haiku-20240307")

    # ==============================
    # Cliente Claude
    # ==============================
    client = Anthropic(api_key=api_key)

    # ==============================
    # Tipo de prompt
    # ==============================
    prompt_tipo = os.getenv("PROMPT_TIPO", "default").lower()
    prompt_path = f"ai/prompts/{prompt_tipo}.txt"

    if not os.path.exists(prompt_path):
        raise FileNotFoundError(f"❌ Arquivo de prompt não encontrado: {prompt_path}")

    with open(prompt_path, "r", encoding="utf-8") as f:
        prompt_base = f.read()

    # ==============================
    # Leitura do BDD
    # ==============================
    with open(
        "ai/bdd/generated.feature",
        "r",
        encoding="utf-8"
    ) as f:
        bdd_content = f.read()

    # ==============================
    # Prompt final
    # ==============================
    prompt = f"""
{prompt_base}

Arquivo BDD fornecido:
{bdd_content}
"""

    # ==============================
    # Chamada à API Claude
    # ==============================
    response = client.messages.create(
        model=model,
        max_tokens=1800,
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    tests_code = response.content[0].text

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/tests", exist_ok=True)
    with open(
        f"ai/tests/test_generated_{prompt_tipo}.ts",
        "w",
        encoding="utf-8"
    ) as f:
        f.write(tests_code)


if __name__ == "__main__":
    generate_tests_from_bdd()
