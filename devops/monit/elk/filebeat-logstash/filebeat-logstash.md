
* filebeat 參數介紹
https://iter01.com/517589.html

* filebeat 安裝
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.7.1-amd64.deb
sudo dpkg -i filebeat-8.7.1-amd64.deb

cat>/var/log/logstash.conf<<EOF
filebeat.inputs:
- type: log
  enabled: true
  backoff: "1s"             # 一秒掃一次
  tail_files: true         # 預設是false 會從log最後一行開始記錄
  paths:
    - /root/.pm2/logs/*-error.log
  exclude_files: ['\.gz$']
  fields:                   # 這邊設的變數可以從logstash的output中取得 [fields][log_topics]
    log_topics: log_nginx_access
  fields_under_root: true   # 這邊設置true output那邊就不用加[fields]
  include_lines: ['keyword1', 'keyword2', 'keyword3']

output.logstash:
  hosts: ["localhost:5044"]
EOF

* logsatsh 安裝

cat>/var/log/logstash.conf<<EOF
input {
  beats {
    port => 5044
  }
}

output {
  http {
    url => "http://172.20.11.22:3003/errorlog"
    http_method => "post"
  }
}
EOF

docker run -d -p 5044:5044 -v /var/log/logstash.conf:/usr/share/logstash/pipeline/logstash.conf docker.elastic.co/logstash/logstash:8.7.1


* nodejs api 

app.post('/errorlog', function(req, res) {
    const logData = req.body.event;
    console.log(logData);
    res.send(JSON.stringify({
        "res": "200"
    }));
})