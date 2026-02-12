* 檢查 TLS 1.0 1.1 能否被訪問
sslscan www.test.com:443
openssl s_client -connect backed.test.com:443 -tls1 (這樣測不準 因為這工具預設就不能用 TLS1)

* 第三方測試工具
https://www.sslshopper.com/


jQuery().jquery


* 新增使用者測試
sudo adduser --disabled-password argo
sudo userdel -r argo