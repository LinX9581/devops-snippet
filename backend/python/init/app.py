from flask import Flask, request

app = Flask(__name__)

@app.route('/get', methods=['GET'])
def handle_get():
    # 處理GET請求
    return "This is a GET requets."

@app.route('/post', methods=['POST'])
def handle_post():
    # 處理POST請求
    data = request.form['data']
    return f"Received POST request with data: {data}"

if __name__ == "__main__":
    app.run(debug=True)
