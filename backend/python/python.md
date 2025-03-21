# intsall python on ubuntu
* install certain version of python
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.13
apt install python3-pip -y

* install default python
sudo apt update
sudo apt install python3 python3-dev python3-pip -y

* python cmd replace python3
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1


# virtualenv
sudo apt install python3-virtualenv -y

cd dir
virtualenv venv
* 會在當前目錄建立虛擬環境
source venv/bin/activate
* 針對 /var/www/test2 建立虛擬環境
source /var/www/test2/venv/bin/activate
該虛擬環境只會對該資料夾有效
deactivate 回到原本環境


# Flask
pip install flask
pip install -r requirements.txt

* run
cd ./backend/python/init
python3 app.py

* build to image
docker build -t flask-app:1.0 .
docker run -itd -v ./.env:/app/.env --name nodejs-template -p 5000:5000 flask-app:1.0

* test
curl 127.0.0.1:5000/get
curl -d "data=example" -X POST http://127.0.0.1:5000/post
curl 127.0.0.1:5000/echo-env

* 清除原有程序並重啟
 pkill -f "python3 app.py" && sleep 5 && cd /var/www/lifestyle_post_crawler_result_web && nohup python3 app.py > app.log 2>&1 &