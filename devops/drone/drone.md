# 腳本執行完後還要做的事
開 TCP 4500 port
綁DNS
SSL
綁Github
放rsa key
這定專案的screct name screct value

## 4個環境變數
/drone/.env
DRONE_GITHUB_CLIENT_ID
DRONE_GITHUB_CLIENT_SECRET
DRONE_RPC_SECRET
DRONE_SERVER_HOST

## Dorne 連結 Github 取得 CLIENT_ID CLIENT_SECRET
先到 Github 建立 Oauth App [連結](https://github.com/settings/developers)

Homepage URL & Authorization callback URL
分別填入
https://example.com
https://example.com/login
建立完成後會取得 ID & Secret
 
## 取得DRONE_RPC_SECRET
隨機建立 [連結](https://correcthorsebatterystaple.net/)
DRONE_RPC_SECRET = drone repo setting's screct name
= .drone.yml
key:
	from_secret: ${DRONE_RPC_SECRET}
target: /root/.ssh/id_rsa	# = drone repo setting's screct value

## 建立 RSA Key
ssh-keygen -t rsa

## rollback
git rebase -i 版本號