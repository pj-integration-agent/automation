import webview
import os
from ai.generate.generate_user_stories import generate_user_stories_from_criterios
from ai.generate.generate_bdd import generate_bdd_from_user_stories

class Api:
    def generate_user_stories(self, prompt):
        try:
            os.makedirs("ai/requirements", exist_ok=True)
            with open("ai/requirements/criterios.md", "w", encoding="utf-8") as f:
                f.write(prompt.strip())

            generate_user_stories_from_criterios()

            output_file = "ai/user_stories/generated_user_stories.txt"
            if os.path.exists(output_file):
                with open(output_file, "r", encoding="utf-8") as f:
                    content = f.read()
                stories = [s.strip() for s in content.split("\n\n") if s.strip()]

                # Cria arquivo .txt para download
                txt_path = "ai/user_stories/user_stories.txt"
                with open(txt_path, "w", encoding="utf-8") as f:
                    f.write(content)

                return {
                    "success": True,
                    "user_stories": stories,
                    "txt_content": content,
                    "txt_filename": "user_stories.txt"
                }
            else:
                return {"success": False, "error": "Arquivo de user stories não encontrado"}
        except Exception as e:
            return {"success": False, "error": str(e)}

    def generate_bdd(self, user_stories):
        try:
            generate_bdd_from_user_stories()

            output_file = "ai/bdd/generated.txt"
            if os.path.exists(output_file):
                with open(output_file, "r", encoding="utf-8") as f:
                    content = f.read()

                # Cria arquivo .txt para download
                txt_path = "ai/bdd/generated_bdds.txt"
                with open(txt_path, "w", encoding="utf-8") as f:
                    f.write(content)

                return {
                    "success": True,
                    "txt_content": content,
                    "txt_filename": "generated_bdds.txt"
                }
            else:
                return {"success": False, "error": "Arquivo de BDD não encontrado"}
        except Exception as e:
            return {"success": False, "error": str(e)}

def start_app():
    api = Api()
    window = webview.create_window(
        title="Agente de IA — User Stories & BDDs",
        url="web/index.html",
        js_api=api,
        width=980,
        height=750,
    )
    webview.start(debug=True)

if __name__ == "__main__":
    start_app()
