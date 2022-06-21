# 寫入檔案
curl -H "Content-type: multipart/form-data" -F "mypic=@/1.jpg" http://127.0.0.1:4000/uploadphoto

# 下載檔案
curl https://test/img/kabi.jpg -O
# Post Json Data
curl -X POST http://127.0.0.1:5000/uploads -H 'Content-Type: application/json' -d '{"login":"my_login","password":"my_password"}'

# ab
sudo apt-get install apache2-utils
ab -n 1 -c 1  -T application/json -p 1.json http://127.0.0.1:3301/anal/api/test/
ab -n 1 -c 1 https://127.0.0.1:3301/

* -k 同一個連線下
