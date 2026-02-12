[環境變數、開發&測試](https://huskylin.github.io/2020/06/18/Node-js-PM2-%E8%A8%AD%E7%BD%AE%E7%92%B0%E5%A2%83%E8%AE%8A%E6%95%B8%EF%BC%8C%E6%9B%B4%E5%BD%88%E6%80%A7%E5%9C%B0%E9%96%8B%E7%99%BC%E8%88%87%E9%83%A8%E5%B1%AC/)
```
pm2 start npm --time --name "template" -- start
pm2 logs 0 --lines 150
pm2 restart 0 --time --watch
pm2 update
pm2 startup
pm2 save
```

pm2 unstartup systemd
pm2 startup systemd
systemctl daemon-reload
systemctl start pm2-root
pm2 save
systemctl enable pm2-root

底下來源
https://tn710617.github.io/zh-tw/pm2/

# pm2 解決什麼問題？
pm2 可以讓 node 服務 crash 掉之後，自動幫我們重啟

pm2 可以在 server 重啟之後，自動幫我們重啟

pm2 可利用 CPU 多核，開啟多程序，已達到類似負載平衡的效果

Graceful reload 可達成類似 rolling upgrade 的效果，0 downtime 升級

多程序多服務，可提升處理 request 的速度

可設定 cron 排程自動重啟時間

pm2 提供多項資訊，包含已重啟次數、 CPU 用量、 memory 用量, process id, 等等…

pm2 可以在指定的條件下，自動幫我們重啟，條件可以是’up time’, ‘已使用多少 memory’, 等等…,

pm2 可以幫我們整理 log, 讓 log 以我們想要的週期分割檔案，並保存我們想要的數量，若有超過，自動刪除。

pm2 提供簡單的部署方式，可一次性部署到多台 server

pm2 可與 CD / CD 工具做結合， CI / CD 部署也沒有問題

# 本篇將提到：
安裝 pm2
使用 CLI 啟動 pm2
使用 pm2 設定檔 ecosystem 啟動 pm2
使用 pm2 設定檔 ecosystem 部署 node 專案
使用 pm2 搭配 GitLab CI / CD Runner 部署 node 專案


# 安裝
全域安裝
npm install pm2@latest -g


# pm2 with CLI
# 可以使用 pm2 CLI 來啟動 node 專案, 範例如下：
pm2 start location/fileName.js --name appName \
--watch true \
--max-memory-restart 500M \
--log ~/.pm2/logs/appName/ \
--time true \
--cron "0 17 * * *" \
--no-daemon true \
--merge-logs
以上範例中設定代表的意思，參考如下：


# 靜態檔的服務器
也可以服務靜態檔
pm2 serve <path> <port>

# 啟動可以附加的參數
--name
指定 app 一個名字
--watch
檔案有變更時，會自動重新啟動
--max-memory-restart
Memory 使用超過這個門檻時，會自動重啟
--log
指定 log 的位址, 若要指定新位址，需將原本的 process 刪掉，再重新啟動指定
--output
指定 output log 位址
--error
指定 error log 位址
--log-date-format
指定 log 的格式
--merge-logs
同一個 app 跑多程序時，不要依據程序 id 去分割 log, 全部合在一起
--arg1 --arg2 --arg3
指派額外的參數
--restart-delay
自動重啟時，要 delay 多久
--time
給 log 加上前綴
--no-autorestart
不要自動重啟
--cron
指定 cron 規律，強制重啟
--no-daemon
無 daemon 模式， listen log 模式
--spa
限定 serve 使用, 會重導所有的請求到 index.html
--basic-auth-username --basic-auth-password
用於靜態檔, 讓該頁面需要帳號密碼方可存取

## # 叢集模式 - pm2 自動偵測該機器的 CPU 數量，啟動最大能負荷的 process, 適用上面的選項, 
−
i
 後面接希望啟動 instance 的數量， 0 或 max 默認自動偵測 CPU 啟動最大值
pm2 start app.js -i max


## # 管理程序 - 直接 kill 掉 process, 再重新開始程序
pm2 restart app_name
如果是在 cluster mode, reload 會依序升級重啟每一個程序，達到 zero downtime 升級

pm2 reload app_name
停止服務

pm2 stop app_name
停止並刪除服務

pm2 delete app_name
除了 app_name 之外，你也可以指定
all : 啟動所有程序
id : 該程序 id



## # 顯示管理程序狀態
pm2 [list|ls|status]




# Logs
輸出 log

pm2 logs
顯示指定行數 log (指定倒數 200 行)

pm2 logs --lines 200
指定輸出程序 log

pm2 logs id
指定輸出格式 format

pm2 logs --format
指定輸出格式 json

pm2 logs --json
清空 log

pm2 flush
取消 log
可以利用指定 log 路徑為 /dev/null 來取消 log 輸出, log 參數用法請參考 ecosystem 範例



# 循環 log
如果你看過 log 檔案超肥，幾年的 log 都寫在同一個檔案; 如果你打開 log 資料夾，發現裡面躺著幾百個 log 檔案; 如果你看過千奇百怪的 log 檔名; 如果你 du -h 發現 log 資料夾大的嚇死人
如果你有以上的經驗，那恭喜你，你有救了


# 安裝
pm2 install pm2-logrotate

# config 檔位置
/home/user/.pm2/module_conf.json


# 參數
max_size (預設 10M):
當 log 檔案達到多大時， logrotate module 會將它分割成另外一個檔案。 logrotate module 有可能在檢查檔案時，檔案已經超過指定的大小了，所以超過一些些是可能的。 單位可以自行指定, 10G, 10M, 10K
retain (預設 30 個 log 檔案):
預設最多保存的 log 數量，如果設定為 7 的話，將會保存目前的 log, 以及最多 7 個 log 檔案
compress (預設 false):
壓縮所有循環 log 檔案
dateFormat (時間格式，預設 YYYY-MM-DD_HH-mm-ss) :
檔案命名的時間格式
rotateModule (預設 true) :
跟其他 apps 一樣，循環 pm2’s module
workerInterval (預設 30 秒) :
多久 logrotate 會檢查一次 log 檔案大小
rotateInterval (預設每天午夜循環, 範例 0 0 * * * ):
除了設定檔案大小以外，我們也可以設定以時間為單位去循環，格式上採用 node-schedule
TZ (預設為系統時間):
檔案命名的時間會根據你所設定的時區而改變

# 圖示
*    *    *    *    *    *
┬    ┬    ┬    ┬    ┬    ┬
│    │    │    │    │    |
│    │    │    │    │    └ day of week (0 - 7) (0 or 7 is Sun)
│    │    │    │    └───── month (1 - 12)
│    │    │    └────────── day of month (1 - 31)
│    │    └─────────────── hour (0 - 23)
│    └──────────────────── minute (0 - 59)
└───────────────────────── second (0 - 59, OPTIONAL)


# terminal 監控面板
pm2 monit


# pm2 ecosystem
CLI 工具固然不錯，但只要是人難免手滑打錯或漏打參數。 pm2 ecosystem 解決了這個問題，只要好好的打上一次，以後除非設定有變更，否則啟動服務只需要短短幾個指令，而且 ecosystem 檔案還可以納入 git 控管，跟著專案跑

產生範例 ecosystem file
pm2 ecosystem

# CLI
跟前面介紹過的管理程序一樣，差別只是將 app.js 換成 ecosystem.js
多個管理程序 CLI, 這邊就只列出 start, 其餘同上

pm2 start ecosystem.config.js

# 從 ecosystem 中只啟動特定 app
下面的 appName 為我們寫在 ecosystem.config.js 檔案中的 appName

pm2 start ecosystem.config.js --only yourApp

# 帶入參數
拿下面的範例來說，如果我輸入 pm2 start ecosystem --only app1 --env production , 那麼 pm2 就會使用 NODE_ENV=production 這個環境變數


# 參數範例
下面的參數有點多，我們肯定不會一次使用到這麼多的參數，所以可以視專案需求留下我們需要的參數即可

module.exports = {
    apps: [
        // First application
        {
            // App 名稱
            name: 'app1',
            // 執行服務的入口檔案
            script: './server.js',
            // 你的服務所在位置
            cwd: 'var/www/yourApp/',
            // 分為 cluster 以及 fork 模式
            exec_mode: 'cluster',
            // 只適用於 cluster 模式，程序啟動數量
            instances: 0,
            // 適合開發時用，檔案一有變更就會自動重啟
            watch: false,
            // 當佔用的 memory 達到 500M, 就自動重啟
            max_memory_restart: '500M',
            // 可以指定要啟動服務的 node 版本
            interpreter: '/root/.nvm/versions/node/v8.16.0/bin/node',
            // node 的額外參數
            // 格式可以是 array, 像是 "args": ["--toto=heya coco", "-d", "1"], 或是 string, 像是 "args": "--to='heya coco' -d 1"
            interpreter_args: "port=3001 sitename='first pm2 app'",
            // 同上
            node_args: "port=3001 sitename='first pm2 app'",
            // 'cron' 模式指定重啟時間，只支持 cluster 模式
            cron_restart: "0 17 * * *",
            // log 顯示時間
            time: true,
            // 可經由 CLI 帶入的參數
            args: '-a 13 -b 12',
            // 想要被忽略的檔案或資料夾, 支援正則，指定的檔案或資料夾如果內容有變更，服務將不會重啟
            // 格式可以是 array, 像是 "args": ["--toto=heya coco", "-d", "1"], 或是 string, 像是 "args": "--to='heya coco' -d 1"
            ignore_watch: ["[\/\\]\./", "node_modules"],
            // 支援 source_map, 預設 true, 細節可參考
            // http://pm2.keymetrics.io/docs/usage/source-map-support/
            // https://www.html5rocks.com/en/tutorials/developertools/sourcemaps/
            source_map_support: true,
            // instance_var, 詳見以下連結
            // http://pm2.keymetrics.io/docs/usage/environment/#specific-environment-variables
            instance_var: 'NODE_APP_INSTANCE',
            // log 的時間格式
            log_date_format: 'YYYY-MM-DD HH:mm Z',
            // 錯誤 log 的指定位置
            error_file: '/var/log',
            // 正常輸出 log 的指定位置
            out_file: '/var/log',
            // 同一個 app 有多程序 id, 如果設定為 true 的話， 同 app 的 log 檔案將不會根據不同的程序 id 分割，會全部合在一起
            combine_logs: true,
            // 同上
            merge_logs: true,
            // pid file 指定位置, 預設 $HOME/.pm2/pid/app-pm_id.pid
            pid_file: 'user/.pm2/pid/app-pm_id.pid',
            // pm2 會根據此選項內的時間來判定程序是否有成功啟動
            // 格式可使用 number 或 string, number 的話， 3000 代表 3000 ms。 string 的話, 可使用 '1h' 代表一個小時, '5m' 代表五分鐘, '10s' 代表十秒
            min_uptime: '5',
            // 單位為 ms, 如果在該時間內 app 沒有聽 port 的話，強制重啟
            listen_timeout: 8000,
            // 當執行 reload 時，因為 graceful reload 會等到服務都沒有被存取了才會斷開，如果超過這個時間，強制斷開重啟
            // 細節可參考官方文件 http://pm2.keymetrics.io/docs/usage/signals-clean-restart/
            kill_timeout: 1600,
            // 一般來說，服務等待 listen 事件觸發後，執行 reload, 若此選項為 true, 則等待 'ready' message
            // 細節可參考官方文件 http://pm2.keymetrics.io/docs/usage/signals-clean-restart/
            wait_ready: false,
            // pm2 具有 crash 自動重啟的功能。 但若異常狀況重啟超過此選項的指定次數，則停止自動重啟功能。 異常與否的判定，預設為 1 秒，也就是說如果服務啟動不足一秒又立即重啟，則異常重啟次數 + 1。 若 min_uptime 選項有指定，則以 min_uptime 指定的最小正常啟動時間為標準來判斷是否為異常重啟
            // 細節可參考官方文件 http://pm2.keymetrics.io/docs/usage/signals-clean-restart/
            max_restarts: 10,
            // 單位為 ms, 預設為 0, 若有指定時間，則 app 會等待指定時間過後重啟
            restart_delay: 4000,
            // 預設為 true, 若設為 false, pm2 將會關閉自動重啟功能, 也就是說 app crash 之後將不會自動重啟
            autorestart: true,
            // 預設為 true, 預設執行 pm2 start app 時，只要 ssh key 沒問題， pm2 會自動比較 local 跟 remote, 看是否為最新的 commit，若否，會自動下載更新。 此功能有版本問題，需新版才支援
            vizion: true,
            // 進階功能，當使用 Keymetrics 的 dashboard 執行 pull 或 update 操作後，可以觸發執行的一系列指令
            post_update: ["npm install", "echo launching the app"],
            // defaults to false. if true, you can start the same script several times which is usually not allowed by PM2
            // 預設為 false, 如果設定為 true, 
            force: false,
            // 當不指定 env 時，會套用此 object 裡頭的環境變數, 例如 pm2 start ecosystem.js
            env: {
                COMMON_VARIABLE: 'true',
                NODE_ENV: '',
                ID: '44'
            },
            // 當有指定 env 時，會套用此 object 裡頭的環境變數, 例如 pm2 start ecosystem.js --env production
            env_production: {
                NODE_ENV: 'production',
                ID: '55'
            },
            // 同上
            env_development: {
                NODE_ENV: 'development'
            }
        },
        // 第二個 app, 很多資訊上面有介紹過的就不再重複
        {
            // Serve 模式, 可服務靜態資料夾
            script: "serve",
            env: {
                PM2_SERVE_PATH: '.',
                PM2_SERVE_PORT: 8080
                },
            name: 'app2',
            // 預設模式，可應用在其他語言, cluster 只可用在 node.js
            exec_mode: 'fork',
            interpreter: '/root/.nvm/versions/node/v8.16.0/bin/node',
            time: true,
        }
    ],
    // 這一個區塊是部署的部分
    deploy: {
        // production
        production: {
            // 要登入執行 pm2 的 user
            user: 'root',
            // 支援多個 host 部署
            host: ['host1', 'host2'],
            // remote 要檢查的 public key 的位置
            key: 'path/to/some.pem',
            // 要部署的分支
            ref: 'origin/master',
            // Git 倉庫位址
            repo: 'git@gitlab.com:user/yourProject.git',
            // 要部署到 server 上的資料夾路徑
            path: '/var/www/yourProjectName',
            // 如果 ssh 有設定好，從 local 連到 remote 端將不會再詢問是否將 remote 端的 public key 加到 known host
            "ssh_options": "StrictHostKeyChecking=no",
            // 在 pm2 要從 local 端連到 remote 端之前要執行的指令，可以多個指令，由 ; 分割，也可以指定 shell script 的檔案路徑
            "pre-setup": 'apt update -y; apt install git -y',
            // 當 pm2 在 remote 機器上將專案 clone 下來之後會執行的指令，同上，可以多個指令，由 ; 分割，也可以指定 shell script 的檔案路徑
            "post-setup": "ls -la",
            // 當 pm2 在 local 要連上 remote 部署之前 ，在 local 端所要執行的指令, 同上，可以多個指令，由 ; 分割，也可以指定 shell script 的檔案路徑
            "pre-deploy-local" : "echo 'This is a local executed command'",
            // 部署完成後, 所要執行的指令 同上，可以多個指令，由 ; 分割，也可以指定 shell script 的檔案路徑
            'post-deploy': 'sudo /root/.nvm/versions/node/v8.16.0/bin/npm install && sudo /root/.nvm/versions/node/v8.16.0/bin/npm rebuild && /root/.nvm/versions/node/v8.16.0/bin/pm2 reload ecosystem.config.js',
            env_production: {
                 NODE_ENV: 'production'
            }
        }, 
        staging: {
            user: 'root',
            host: ['host3', 'host4'],
            ref: 'origin/staging',
            repo: 'git@gitlab.com:user/yourProject.git',
            path: '/var/www/yourProjectName',
            "ssh_options": "StrictHostKeyChecking=no",
            "pre-setup": 'apt update -y; apt install git -y',
            "post-setup": "ls -la",
            "pre-deploy-local" : "echo 'This is a local executed command'",
            'post-deploy': 'sudo /root/.nvm/versions/node/v8.16.0/bin/npm install && sudo /root/.nvm/versions/node/v8.16.0/bin/npm rebuild && /root/.nvm/versions/node/v8.16.0/bin/pm2 reload ecosystem.config.js',
            env_production: {
                 NODE_ENV: 'staging'
            }
        },
    },
};


# pm2 部署
pm2 的部署功能，可以讓我們從本機直接部署到多台 server 上, 也可以結合 CI / CD 工具，在提交 commit 後自動部署


# 部署前的必要條件
首先要先確定，local 到 remote 端的 ssh key 有準備好了嗎？ local 到 remote server 的 ssh 連線是必要的哦！ 簡單來說，你需要在 local 放一把 private key, 然後在你的 remote server 放一把 public key, 這樣才能暢通無阻哦！ 這部分再麻煩 Google 一下哦！

再來，因為 pm2 會 ssh 到 remote server 上，然後在 remote server 上從我們的專案處 GitHub 或 GitLab 將專案 clone 下來，所以務必確保 remote server 是可以從 GitHub 或 GitLab clone 我們的專案, 所以你要在 remote server 上放一把 clone 用的 private key, 然後將 public key 放在 GitLab 或 GitHub 上，這部分也是麻煩 Google 一下哦

由於首次 ssh 連線時會跳詢問是否將 public key 加入到 known host，這個 prompt 會讓 pm2 deploy 卡住，所以務必先將 remote server 設定好哦！ 可以先連線一次，也可以修改 ssh config, 取消這個 hostKey 的 確認功能。

echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
接下來，要將 ecosystem 設定檔寫好，這部分請參考上方的 deploy 範例

最後，請確認 remote server 的 ssh 通道 (預設 port 22) 不是關閉的哦！


# 初始化遠端資料夾
在部署之前, 先在 remote server 上初始化專案的資料夾, 可以帶入不同的參數讓 pm2 根據設定檔做相對應得部署

pm2 deploy ecosystem.config.js production setup

# 部署
部署
在初始化遠端資料夾之後，我們就可以使用 pm2 的部署功能了

pm2 deploy ecosystem.config.js production
deploy 可使用的參數如下，也可使用 pm2 deploy help 查看

pm2 deploy <configuration_file> <environment> <command>

  Commands:
    setup                遠端初始化（第一次部署才會用到）
    update               更新到最新的 commit
    revert [n]           回復到上一次的 deployment
    curr[ent]            輸出目前上線中的 commit 
    prev[ious]           輸出上一次部署的 commit
    exec|run <cmd>       執行指定的指令
    list                 列出包含目前，以及之前所部署的 commit
    [ref]                部署到指定的 ref

# 部署相關指令
pm2 startOrRestart all.json            # 重啟所有 app
pm2 startOrReload all.json             # 觸發 reload

# 強制重啟
pm2 的部署，會要求 local 端先將變更推上 Git repository, 然後 pm2 會在 remote server 執行 git pull, 所以當 local 的變更尚未推上 Git 時，部署會失敗。
這時候如果我們硬要部署，我們可以使用

pm2 deploy ecosystem.json production --force


# CI / CD 部署
利用 GitLab 的 CI / CD Runner 配合 pm2 來跑自動部署, 以下為 gitlab.yml 檔案範例
設定好之後，只要 git push 到 master branch, 就會觸發 GitLab CI / CD Runner 自動完成 CI / CD
# 使用輕量化 pm2 image
image: keymetrics/pm2:latest-alpine
stages:
- deploy

Deploy:
  stage: deploy
  script:
  # 若 ssh-agent 未安裝，則安裝
  - 'which ssh-agent || ( apk add --update openssh )'
  # 安裝 bash, 以執行 pm2 CLI 工具
  - apk add --update bash
  # 安裝 git, pm2 要連過去時會用到
  - apk add --update git
  # 執行 ssh agent
  - eval $(ssh-agent -s)
  # 將 ssh key 加到 ssh agent, 此 ssh key 為 GitLab 的 variable 選項
  - echo "$SSH_PRIVATE_KEY" | ssh-add -
  # 執行 pm2 CLI
  - pm2 deploy ecosystem.config.js production update
  
  only:
  - master


# 開機自動啟動
產生開機 script

pm2 startup
取消開機自動重啟

pm2 unstartup
儲存下次重啟時，預設啟動的 process

pm2 save
如果有更新 node 的版本，記得更新 script

pm2 unstartup && pm2 startup && pm2 save


# 有變更時重啟
監看該資料夾下的所有檔案，以及子資料夾，並且忽略 node_module 這個資料夾

cd /path/to/my/app
pm2 start env.js --watch --ignore-watch="node_modules"


# 更新 PM2
npm install pm2@latest -g && pm2 update


# 常用指令
# Fork 模式
pm2 start app.js --name my-api # 指定程序名稱

# Cluster 模式
pm2 start app.js -i 0        # 會根據可用的 CPU 數量來啟動最大的程序數量，達到平衡負載的效果
pm2 start app.js -i max      # 跟上面一樣，但是廢除了
pm2 scale app +3             # 增加三個 worker
pm2 scale app 2              # 將 worker 更新成兩個

# 狀態顯示

pm2 list               # 顯示所有程序狀態
pm2 jlist              # 將程序狀態使用 raw JSON 印出
pm2 prettylist         # 將程序狀態用美化的 JSON 印出

pm2 describe 0         # 顯示特定程序的所有資訊

pm2 monit              # 監控所有程序

# Logs

pm2 logs [--raw]       # 以串流的方式顯示所有 log
pm2 flush              # 移除所有 log 檔案
pm2 reloadLogs         # 重新載入 logs

# 操作

pm2 stop all           # 停止所有程序
pm2 restart all        # 重新開啟所有程序

pm2 reload all         # 重新載入服務

pm2 stop 0             # 停止特定 id 的程序
pm2 restart 0          # 重新啟動特定 id 程序

pm2 delete 0           # 從 pm2 list 移除特定 id 程序, 但這並不會停止該程序
pm2 delete all         # 移除所有程序, 但這並不會停止這些程序

# Misc

pm2 reset <process>    # 重置 meta data
pm2 updatePM2          # 更新 pm2
pm2 ping               # Ensure pm2 daemon has been launched
pm2 sendSignal SIGUSR2 my-app # Send system signal to script
pm2 start app.js --no-daemon # 不要背景執行
pm2 start app.js --no-vizion # 不加這一行，預設執行 pm2 start app 時，只要 ssh key 沒問題， pm2 會自動比較 local 跟 remote, 看是否為最新的 commit，若否，會自動下載更新
pm2 start app.js --no-autorestart # 不自動重啟


# 自動補齊
支援 pm2 指令可以打 tab 自動補齊
pm2 completion install


# 疑難雜症
# 遇到錯誤 Error: ENOENT: no such file or directory, uv_cwd
意思是說， pm2 的工作目錄資料夾不存在，所謂的工作目錄資料夾就是我們第一次啟動 pm2 的位置。很可能是我們啟動之後，就不小心把它刪了，如果要尋找工作目錄資料夾在哪，可以使用下面的 command

找到 pm2 的 process id
ps ax | grep PM2
然後查詢該 process 執行時所在的目錄（將上面得到的 process id 替換下面的 PM2_Process_ID
ls -l /proc/PM2_Process_ID/cwd
公布結果
ls -l /proc/24016/cwd
結果應該會如下, 最後的 deleted 表示該目錄已經被刪除了

lrwxrwxrwx 1 root root 0 Feb 4 17:04 /proc/24016/cwd -> /home/nodejs/deploy(deleted)
現在知道原因了，那解決的方法呢？ 我們要先把目前的 process 砍掉，然後到一個安全一點的地方在開啟一次，以免下次又被誤刪了！

殺掉 pm2 process id

kill -9 processID
到一個安全不會再被意外砍掉的目錄再次啟動 pm2

cd ~ && pm2 -v
