~/.ssh/config

Host gitlab
    HostName gitlab
    User git
    ProxyCommand ssh ai@ip nc %h %p 2> /dev/null

