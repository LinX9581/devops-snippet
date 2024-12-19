from flask import Flask, request, jsonify
from dotenv import load_dotenv
import os
import openai

# 載入環境變數
load_dotenv()

app = Flask(__name__)

# 從環境變數獲取OpenAI API金鑰
openai.api_key = os.getenv("OPENAI_API_KEY")

@app.route('/openai', methods=['POST'])
def openai_api():
    data = request.json
    prompt = data.get('prompt')
    
    if not prompt:
        return jsonify({"error": "缺少prompt參數"}), 400
    
    try:
        response = openai.Completion.create(
            engine="text-davinci-002",
            prompt=prompt,
            max_tokens=150
        )
        return jsonify({"response": response.choices[0].text.strip()})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)