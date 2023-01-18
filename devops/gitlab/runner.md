

docker exec -it gitlab-runner bash

docker run -d --name gitlab-runner --restart always \
    -v /root/.ssh/:/root/.ssh/ \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:v15.5.1

git@github.com:LinX9581/bg-ga-stage.git
docker exec -it gitlab-runner gitlab-runner register
