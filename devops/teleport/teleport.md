* 文件
https://goteleport.com/docs/
https://gist.github.com/snail007/340aef1ae708a1b51db7a84285398a70
https://github.com/gravitational/teleport
https://blog.cptsai.com/2021/07/19/access-from-teleport

* 安裝
curl https://goteleport.com/static/install.sh | bash -s 13.3.7

* 建立使用者
sudo tctl users add teleport-admin --roles=editor,access --logins=root,ubuntu,ec2-user
需連到臨時網址設定密碼 和 2FA 用的是 Authy
https://prod-deploy:3080/web/invite/d8e9a159cb1844c049880ca2cbbc0d0d

* 新增節點
tctl --auth-server=127.0.0.1:3025 nodes add
會給一個遠端節點安裝的指令
遠端節點在下該指令時 要先安裝 teleport
curl https://goteleport.com/static/install.sh | bash -s 13.3.7

* 確認節點
tctl --auth-server=127.0.0.1:3025 nodes ls

* 用 CLI 登入節點
tsh login --proxy=127.0.0.1:3080 --user=teleport-admin
tsh ssh ubuntu@stg-devops:3022



## Nginx Proxy
location / {
    proxy_pass https://127.0.0.1:3080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;     # websocket 這兩行一定要加
    proxy_set_header Connection "upgrade";      # websocket
    proxy_set_header Host $host;
}

## NOTE
預設的登入狀態會維持12小時
可以手動登出 才會保留影片檔