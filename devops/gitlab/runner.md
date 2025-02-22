
## Step
* Create Runner By Docker

docker run -d --name gitlab-runner --restart always \
    -v /root/.ssh/:/root/.ssh/ \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:v15.5.1

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

因為建立的方式是 Docker in Docker 實際上 Runner 和VM本身共用 docker.sock 
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

```
stages:
  - test
  - deploy_vm

variables:
  NODEJS_APP_VERSION: "3.6"

test_job:
  image: node:14.18.0
  stage: test
  only:
    - master
  script:
    - yarn install
    - npm run test 
  tags: 
    - docker-prod-runner   

deply_job: 
  image: node:14.18.0
  stage: deploy_vm
  only:
    - master
  script:
    # bash /deploy/run-ansible.sh {要佈署的VM群組 , 專案名稱 , Branch}
    - ssh -o StrictHostKeyChecking=no gitlab-runner@172.16.2.45 "bash /deploy/run-ansible.sh ga nn-search-trend master"
  tags:
    - docker-prod-runner

```

基本的 ansible 使用 git 佈署
```
---
- name: Copy and Run shell scripts on remote machine
  hosts: '{{ host }}'
  become: yes  # become root user
  tasks:
    - name: deploy
      shell: "cd /var/www/{{ project }} && git fetch --all && git reset --hard origin/{{ branch }} && git pull origin {{ branch }}"
      register: status

    - name: Print
      debug:
        msg: "{{ status.stdout}}"

```