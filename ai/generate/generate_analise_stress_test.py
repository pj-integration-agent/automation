import os
from groq import Groq

def generate_stress_analysis():

    # ==============================
    # GROQ (via CI/CD secrets)
    # ==============================
    client = Groq(api_key=os.getenv("GROQ_API_KEY"))

    # ==============================
    # Leitura do resultado do JMeter
    # ==============================
    jtl_path = "results/resultado.jtl"

    if not os.path.exists(jtl_path):
        raise FileNotFoundError("❌ Arquivo JTL não encontrado em results/resultado.jtl")

    with open(jtl_path, "r", encoding="utf-8") as f:
        jtl_lines = f.readlines()

    # ⚠️ Limita conteúdo para não estourar tokens
    resumo_jtl = "".join(jtl_lines[:300])

    # ==============================
    # PROMPT EMBUTIDO
    # ==============================
    prompt = f"""
Você é um engenheiro de performance especialista em Apache JMeter e testes de carga.

Analise o resultado abaixo, extraído de um arquivo JTL de um teste de stress, e gere
um relatório técnico em TEXTO PURO contendo obrigatoriamente:

- Resumo do cenário de teste
- Volume total de requisições
- Throughput estimado
- Latência (p50, p90, p95, p99)
- Taxa de erros
- Principais gargalos identificados
- Impacto potencial em ambiente de produção
- Recomendações técnicas claras e acionáveis

Não utilize markdown.
Não utilize listas com símbolos especiais.
Use linguagem profissional, objetiva e técnica.

Resultado do stress-test (JTL resumido):
{resumo_jtl}
"""

    # ==============================
    # Chamada à API Groq
    # ==============================
    response = client.chat.completions.create(
        model="openai/gpt-oss-20b",
        messages=[
            {"role": "user", "content": prompt}
        ]
    )

    analysis_text = response.choices[0].message.content

    # ==============================
    # Escrita do resultado
    # ==============================
    os.makedirs("ai/analysis", exist_ok=True)

    output_path = "ai/analysis/stress_analysis.txt"
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(analysis_text)

    print(f"✅ Análise de stress-test gerada com sucesso em {output_path}")

if __name__ == "__main__":
    generate_stress_analysis()
