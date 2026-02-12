# Ansible
cd /devops/ansible-deploy-monitor/ansible

## 維運相關
* check version
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/cmd/check_version.yml --extra-vars 'host=testvm'

* 盤點所有監控服務是否都有啟用
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/cmd/check_service.yml --extra-vars 'host=testvm service_name=google-cloud-ops-agent,fail2ban,falcon-sensor,promtail'

* create user
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/cmd/create_user.yml --extra-vars 'host=testvm username=josh pubkey_path=/devops/ssh_key/josh/id_rsa.pub'

* show os user , 刪除使用者的話 del=y
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/cmd/check_os_user.yml --extra-vars 'host=ga del=n'
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/cmd/check_os_user.yml --extra-vars 'host=ga del=y del_users=chrischo,chester,chester.chung'

常用的檔案和服務名稱
host=stg
filepath=/opt/tomcat/bin/setenv.sh
filepath=/etc/nginx/sites-enabled/default
service_name=google-cloud-ops-agent
service_name=falcon-sensor
 
## 安裝後端環境
* install java
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/java.yml

1 = install only
2 = install and configure
3 = configure only
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/java.yml --extra-vars 'host=tf action=2'

* update java
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/java-update.yml

* install php7.4 8.0 8.2 8.4
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/php.yml -e "php_version=8.4"

* install wordpress
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/wordpress.yml

* install docker
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/docker.yml

* install nodejs 22
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/nodejs.yml

* install python
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/setup_env/python.yml

* upload file
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/setup_env/upload.yml

## 安裝監控環境
* install custom monit , component=fail2ban,edr,gcp-monit,prometheus,promtail,gcp-logging-agent
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/monit/all-monitor.yml -e "component=gcp-logging-agent,gcp-monit,fail2ban,prometheus,promtail,edr"
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/new ./yaml/monit/all-monitor.yml -e "component=prometheus"

falcon-sensor

* prometheus (會先上傳exporter, 再寫成service 讓他保持重開機自動執行)
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/exporter-local.yml
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/exporter-docker.yml

* GCP OPS Agent
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/gcp-monit.yml

* GCP Logging Agent / auth log history
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/gcp-custom-log.yml

* falcon
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/falcon-sensor.yml
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/remove-falcon.yml

* promtail
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/promtail.yml

* fail2ban
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/monit/fail2ban.yml

* pi-hole
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/test ./yaml/monit/pi-hole.yml

* adgaurd-home
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/test ./yaml/monit/adgaurd-home.yml


## 異動檔案或設定
* system modify
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/modify_setting/system_modify.yml --extra-vars 'host=testvm'

* tomcat modify
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/modify_setting/tomcat_modify.yml --extra-vars 'host=testvm'

* service account key modify
cd /devops/ansible-deploy-monitor/ansible/ && ansible-playbook -i ./host/stg ./yaml/modify_setting/serviceAcount_modify.yml --extra-vars 'host=testvm'

/devops/ansible-deploy-monitor/ansible/deploy/monit/promtail/promtail.yml.j2 (loki server ip 要換)
172.16.200.6 stg
172.16.2.45 stg


