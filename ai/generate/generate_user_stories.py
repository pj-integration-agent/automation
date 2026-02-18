import os
import base64
from anthropic import Anthropic


def generate_user_stories_from_image():
    # ==============================
    # API Key
    # ==============================
    api_key = os.getenv("CLAUDE_API_KEY")

    if not api_key:
        raise RuntimeError("❌ CLAUDE_API_KEY não definida")

    model = os.getenv("CLAUDE_MODEL", "claude-3-haiku-20240307")

    client = Anthropic(api_key=api_key)

    # ==============================
    # Caminho da imagem
    # ==============================
    image_path = "ai/requirements/criterios.png"

    if not os.path.exists(image_path):
        raise FileNotFoundError(f"❌ Imagem não encontrada: {image_path}")

    # ==============================
    # Leitura da imagem (modo binário)
    # ==============================
    with open(image_path, "rb") as img:
        image_bytes = img.read()

    image_base64 = base64.b64encode(image_bytes).decode("utf-8")

    # Detecta automaticamente o tipo
    if image_path.endswith(".png"):
        media_type = "image/png"
    elif image_path.endswith(".jpg") or image_path.endswith(".jpeg"):
        media_type = "image/jpeg"
    else:
        raise ValueError("❌ Formato de imagem não suportado")

    # ==============================
    # Prompt
    # ==============================
    prompt_text = """
Você é um especialista em análise de requisitos e criação de User Stories ágeis.

Com base na imagem enviada, gere User Stories completas.

Regras:
- Formato: "Como [tipo de usuário], eu quero [objetivo] para [benefício]"
- Descrição detalhada
- Critérios de aceite objetivos
- Rastreabilidade (US01, US02...)
- Não gerar BDDs
"""

    # ==============================
    # Chamada à API Claude (multimodal)
    # ==============================
    response = client.messages.create(
        model=model,
        max_tokens=1500,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": prompt_text
                    },
                    {
                        "type": "image",
                        "source": {
                            "type": "base64",
                            "media_type": media_type,
                            "data": image_base64
                        }
                    }
                ]
            }
        ]
    )

    user_stories_text = response.content[0].text

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/user_stories", exist_ok=True)

    output_path = "ai/user_stories/generated_user_stories.txt"

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(user_stories_text)

    print("✅ User Stories geradas com sucesso!")
    print(f"📄 Arquivo salvo em: {output_path}")


if __name__ == "__main__":
    generate_user_stories_from_image()
