
# Auditd
* 安裝腳本
./auditd.sh

* log 超過 1G 輪轉
max_log_file 1024

* log 保留180天
num_logs = 180

預設監控以下四個檔案
-w /etc/passwd -p wa -k passwd_changes
-w /etc/shadow -p wa -k shadow_changes
-w /etc/sudoers -p wa -k sudoers_changes
-w /etc/audit -p wa -k auditconfig

有異動 /var/log/audit/audit.log 就會有紀錄

* 檢視格式化後的 log
aureport -f
aureport -f -ts 01/19/25 00:00:00 -te 02/18/25 23:59:59

* 查看規則
auditctl -l


curl -G -s "http://localhost:3100/loki/api/v1/query_range" --data-urlencode 'query={job="audit_filtered"}' --data-urlencode 'limit=10'
