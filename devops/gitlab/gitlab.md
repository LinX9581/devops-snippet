## gitlab runner
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get update
sudo apt-get install gitlab-runner
sudo gitlab-runner register
sudo gitlab-runner start

會需要 url & token & description & tags
setting -> CICD -> Runners -> Set up a specific Runner manually or group Runner 

executor: "shell" # shell, docker, docker-ssh, ssh, virtualbox, parallels, kubernetes, custom, docker+machine, docker-ssh+machine, kubernetes+machine, ssh+machine, shell+machine
"instance"：使用現有的機器來運行測試和部署工作。
"docker"：在 Docker 容器中運行測試和部署工作。
"docker-ssh"：在遠端主機上的 Docker 容器中運行測試和部署工作。
"shell"：在本地系統上運行測試和部署工作。
"ssh"：在遠端主機上運行測試和部署工作。

## gitlab docker
https://docs.gitlab.com/runner/install/docker.html
docker run -d --name gitlab-runner --restart always   -v /srv/gitlab-runner/config:/etc/gitlab-runner   -v /var/run/docker.sock:/var/run/docker.sock   gitlab/gitlab-runner:latest
docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register

## remove
sudo gitlab-runner uninstall
sudo rm -rf /usr/local/bin/gitlab-runner
sudo userdel gitlab-runner
sudo rm -rf /home/gitlab-runner/


## error
1. ERROR: Job failed: prepare environment: exit status
註解 .bash_logout 所有內容

2. 沒權限
before_script:
    - whoami
    - pwd
    - locate npm
    - echo ${PATH}
    - which npm
    - ls -lh $(which npm)

3. 讓特定使用者 有root權限
sudo visudo 
username ALL=(ALL:ALL) ALL