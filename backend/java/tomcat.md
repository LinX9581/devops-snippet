
* 更換版本腳本
ssh -o StrictHostKeyChecking=no ansible@172.16.2.68 "sudo tar -xf apache-tomcat-9.0.93.tar.gz && sudo rm -rf /home/ansible/apache-tomcat-9.0.93/webapps/* && sudo cp /home/ansible/apache-tomcat-9.0.93 /etc/tomcat -R && sudo cp /etc/tomcat/apache-tomcat-8.5.81/webapps /etc/tomcat/apache-tomcat-9.0.93 -R && sudo cp /etc/tomcat/apache-tomcat-8.5.81/conf/server.xml /etc/tomcat/apache-tomcat-9.0.93/conf/server.xml && sudo cp /etc/tomcat/apache-tomcat-8.5.81/bin/setenv.sh /etc/tomcat/apache-tomcat-9.0.93/bin/setenv.sh && sudo sh /etc/tomcat/apache-tomcat-8.5.81/bin/shutdown.sh && sleep 3 && sudo sh /etc/tomcat/apache-tomcat-9.0.93/bin/startup.sh && sudo ln -sfn /etc/tomcat/apache-tomcat-9.0.93/bin/shutdown.sh /opt/shutdown.sh && sudo ln -sfn /etc/tomcat/apache-tomcat-9.0.93/bin/startup.sh /opt/startup.sh && sudo ln -sfn /etc/tomcat/apache-tomcat-9.0.93 /opt/tomcat && crontab -l | sed 's/8.5.81/9.0.93/g' | crontab - && sudo sed -i 's/8\.5\.81/9.0.93/g' /etc/systemd/system/tomcat.service && sudo systemctl daemon-reload"

crontab -l | sed 's/8.5.81/9.0.93/g' | crontab -
rm -rf ROOT/ docs/ examples/ host-manager/ manager/

sh /opt/tomcat/bin/version.sh