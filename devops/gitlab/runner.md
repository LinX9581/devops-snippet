
## Step
* Create Runner By Docker

docker run -d --name gitlab-runner --restart always \
    -v /root/.ssh/:/root/.ssh/ \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:v15.5.1

* ssh to runner
docker exec -it gitlab-runner bash

* register runner (要讓gitlab 綁定自建的runner)
registration-token = repo -> setting -> CI/CD -> Runners -> Set up a specific Runner manually

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

* runner config
/srv/gitlab-runner/config/config.toml

因為建立的方式是 Docker in Docker 實際上 Runner 和VM本身共用 docker.sock 
跑的任何一個 CI Job 都是另外起一個 Conatiner 執行
所以權限的問題 要改下面這段 讓他們共用一些Key(必要的話)
volumes = ["/gitlab-runner/auth/docker/:/certs/client/:rw","/root/.ssh/:/root/.ssh/","/cache:/cache:rw"]


* simple .gitlab-ci.yml
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