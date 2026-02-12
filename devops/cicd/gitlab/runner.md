
## Step
* Create Runner By Docker

docker run -d --name gitlab-runner1 --restart always \
    -v /root/.ssh/:/root/.ssh/ \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:v16.3.1

* ssh to runner
docker exec -it gitlab-runner bash

* register runner (to bind gitlab and runner)
registration-token = repo -> setting -> CI/CD -> Runners -> Set up a specific Runner manually

* ssh gitlab-runner container & register runner
gitlab-runner register -n \
  --url https://gitlab.{domain}.com/ \
  --registration-token {register code} \
  --executor docker \
  --config /etc/gitlab-runner/config.toml \
  --description "Gitlab Docker Runner" \
  --docker-image "node:latest" \
  --tag-list "docker-prod-runner" \
  --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
  --docker-disable-cache=true

* runner 最主要的設定檔 runner config
/srv/gitlab-runner/config/config.toml

因為建立的方式是 把 Docker API 掛載到 Runner，Runner 會直接呼叫 VM本身的 Docker API 去建立容器執行 CI Job 
跑的任何一個 CI Job 都是另外起一個 Conatiner 執行
所以權限的問題 要改下面這段 讓他們共用一些Key(必要的話)
這樣的話 每個 Runner 起來的 Container 都會共用以下的資料夾
volumes = ["/gitlab-runner/auth/docker/:/certs/client/:rw","/root/.ssh/:/root/.ssh/","/cache:/cache:rw"]

有關docker的部分要改成下面 , privileged = true
image 的部分則是假設 .gitlab-ci.yml 沒有指定 image 預設就會用 docker:stable
一開始註冊 Runner 也能選預設 image 但還是以 /srv/gitlab-runner/config/config.toml 裡設定的為主

設定檔的格式
```
  [runners.docker]
    tls_verify = false
    image = "docker:stable"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = true
    volumes = ["/gitlab-runner/auth/docker/:/certs/client/:rw","/root/.ssh/:/root/.ssh/","/cache:/cache:rw"]
    shm_size = 0

```

## 完整流程
1. 先建立 Runner Container
2. 連入 Runner Container 並且註冊 Runner 填入 gitlab url 和 token
3. 更改 /srv/gitlab-runner/config/config.toml 設定檔 , 假設裡面的 runner 建立的 image 需要 ssh 到其他機器 就要讓本地的 /root/.ssh 同步到 runner container，之後重啟 runner container
4. 在 gitlab 上建立一個 project 並且在裡面建立一個 .gitlab-ci.yml 確保 tag 和 runner 的 tag 一致


## 相關runner 指令
gitlab-runner list

* 會刪除未註冊的runner (網頁版可能刪了 但server上還在)
gitlab-runner verify --delete


## .gitlab-ci.yml 範例
要注意 tag 必須和 runner 的 tag 一致才會被執行

避免 runner 有過大權限，只讓他運行一個腳本
```
deply_job: 
  image: node:14.18.0
  stage: deploy_vm
  only:
    - main
  script:
    # bash /deploy/run-ansible.sh {要佈署的VM群組 , 專案名稱 , Branch , 語言}
    - ssh -o StrictHostKeyChecking=no gitlab-runner@172.16.2.6 "bash /deploy/run-ansible.sh $CI_PROJECT_NAME $CI_PROJECT_NAME main python"

```

## 限縮 Runner 權限

要限縮 172.16.2.6 這台機器的 gitlab-runner 使用者能執行的指令

/home/gitlab-runner/.ssh/authorized_keys
前面加上
command="/devops/restricted-deploy.sh $SSH_ORIGINAL_COMMAND",no-port-forwarding,no-X11-forwarding,no-a
gent-forwarding,no-pty 

把可執行指令寫在 /devops/restricted-deploy.sh 裡面
scp 如果同檔名 他不會執行刪除 所以要設白名單
```
#!/bin/bash

LOG_FILE="/devops/deploy.log"

# 檢查傳入的命令
case "$SSH_ORIGINAL_COMMAND" in
    "scp -t /deploy/"*)
        # 提取目標檔案名稱
        target_file=$(echo "$SSH_ORIGINAL_COMMAND" | sed 's/scp -t //')
        # 檢查目標檔案是否位於 /deploy/ 且副檔名為 .war
        if [[ "$target_file" =~ ^/deploy/.*\.war$ ]]; then
            # 如果目標檔案已存在，先移除
            [ -f "$target_file" ] && rm -f "$target_file"
            # 執行 scp 上傳
            exec /usr/bin/scp -t "$target_file"
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Rejected: Only .war files are allowed in /deploy/" >> "$LOG_FILE"
            echo "Only .war files are allowed in /deploy/"
            exit 1
        fi
        ;;
    "sudo bash /deploy/deploy.sh "*)
        # 提取參數並執行 deploy.sh
        params="${SSH_ORIGINAL_COMMAND#sudo bash /deploy/deploy.sh }"
        exec sudo bash /deploy/deploy.sh "$params"
        ;;
    "bash /deploy/run-ansible.sh "*)
        # 提取參數並執行 /deploy/run-ansible.sh
        params="${SSH_ORIGINAL_COMMAND#bash /deploy/run-ansible.sh }"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Executing: sudo bash /deploy/run-ansible.sh with params: '$params'" >> "$LOG_FILE"
        exec bash /deploy/run-ansible.sh "$params"
        ;;
    *)
        # 其他命令一律拒絕
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Rejected: Command not allowed" >> "$LOG_FILE"
        echo "Command not allowed"
        exit 1
        ;;
esac

```

--extra-vars "host=prod-intra-system project='html && ls -l'"