# 要啟動遠端 tomcat 不能加 -t
ssh lin-drone@10.140.0.19 'sudo sh /opt/startup.sh'

# 忽略金鑰
ssh -o StrictHostKeyChecking=no lin-drone@10.140.0.20 "sudo sh /etc/tomcat/apache-tomcat-8.5.50/bin/startup.sh"

ssh -o StrictHostKeyChecking=no git@github.com