* install
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8
apt install python3-pip -y
pip install flask

* run
cd ./backend/python/init
python app.py

* build to image
docker build -t flask-app:1.0 .
docker run -itd -v ./.env:/app/.env --name nodejs-template -p 5000:5000 flask-app:1.0

* test
curl 127.0.0.1:5000/get
curl -d "data=example" -X POST http://127.0.0.1:5000/post
curl 127.0.0.1:5000/echo-env