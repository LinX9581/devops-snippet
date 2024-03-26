# 使用官方Python運行時作為父映像
FROM python:3.8-slim

# 設定工作目錄
WORKDIR /app

# 將當前目錄內容複製到位於容器內的/app中
COPY . /app

# 安裝requirements.txt中列出的所有必需的包
# 假設你的應用有依賴其他Python包，則需要一個requirements.txt文件
RUN pip install --no-cache-dir -r requirements.txt

# 讓世界可以訪問你的應用
EXPOSE 5000

# 定義環境變量
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# 使用flask命令來運行Flask應用
CMD ["flask", "run"]
