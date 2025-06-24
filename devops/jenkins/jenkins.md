# 創建持久化卷
docker volume create jenkins-data

# 運行 Jenkins 容器
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v ~/.ssh:/var/jenkins_home/.ssh \
  jenkins/jenkins:lts

admin_password=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)

連到 IP:8080

# 運行 Jenkins Agent 
手動建置 Agent
填入 agent 名稱、工作目錄
會取得類似
curl -sO http://172.16.1.0:8080/jnlpJars/agent.jar
java -jar agent.jar \
  -url http://172.16.1.0:8080/ \
  -secret 11ceb871760628d2818559f63 \
  -name test2 \
  -webSocket \
  -workDir "/var/agent"

之後在 Agent 的 VM 安裝 Java
sudo apt update
sudo apt install -y openjdk-17-jre-headless
執行上面那段 agent 就會連上 Jenkins Server

