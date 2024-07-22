
# Gitlab Proxy
Gitlab 只允許特定IP連線

其餘機器只要能 SSH 到該機器並修改以下設定檔即可

~/.ssh/config

Host gitlab
    HostName gitlab
    User git
    ProxyCommand ssh ai@ip nc %h %p 2> /dev/null

