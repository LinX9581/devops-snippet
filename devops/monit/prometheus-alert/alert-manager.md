# 參考文件
https://grafana.com/blog/2020/02/25/step-by-step-guide-to-setting-up-prometheus-alertmanager-with-slack-pagerduty-and-gmail/

# 各服務監控設定
https://awesome-prometheus-alerts.grep.to/rules.html#mysql
# hot reload
curl -X POST http://localhost:9090/-/reload
curl -X POST http://localhost:9093/-/reload

# backup prometheus data
docker cp prometheus:/prometheus-data /local/path/to/backup

## 基本設定檔
alert.yml
```
global: 
  resolve_timeout: 5m
route:
  receiver: critical
  group_interval: 5s
  repeat_interval: 1m
  routes:
  - match:
      severity: critical
    receiver: critical
receivers:
- name: 'critical'
  webhook_configs:
  - url: 'http://172.16.200.6:3500/alert'
    send_resolved: true
```

## 設定檔註解
```
global: 
  resolve_timeout: 10m #處理超時時間，預設為5min
  #smtp_smarthost: 'smtp.sina.com:25' # 郵箱smtp伺服器代理
  #smtp_from: '******@sina.com' # 傳送郵箱名稱
  #smtp_auth_username: '******@sina.com' # 郵箱名稱
  #smtp_auth_password: '******' # 郵箱密碼或授權碼
  #wechat_api_url: 'https://qyapi.weixin.qq.com/cgi-bin/' # 企業微信地址
# 定義模板信心
#templates:
#  - 'template/*.tmpl'

# 定義路由樹資訊
route:
  group_by: ['node'] # 報警分組依據
  group_wait: 10s # 最初即第一次等待多久時間傳送一組警報的通知
  group_interval: 10s # 在傳送新警報前的等待時間
  repeat_interval: 1m # 傳送重複警報的週期 對於email配置中，此項不可以設定過低，否則將會由於郵件傳送太多頻繁，被smtp伺服器拒絕
  receiver: 'email' # 傳送警報的接收者的名稱，以下receivers name的名稱

# 定義警報接收者資訊
receivers:
  - name: 'email' # 警報
    # email_configs: # 郵箱配置
    # - to: '******@163.com'  # 接收警報的email配置
    #   html: '{{ template "test.html" . }}' # 設定郵箱的內容模板
    #   headers: { Subject: "[WARN] 報警郵件"} # 接收郵件的標題
    webhook_configs: # webhook配置
    - url: 'webhook.url'
    - send_resolved: true
    # wechat_configs: # 企業微信報警配置
    # - send_resolved: true
    #   to_party: '1' # 接收組的id
    #   agent_id: '1000002' # (企業微信-->自定應用-->AgentId)
    #   corp_id: '******' # 企業資訊(我的企業-->CorpId[在底部])
    #   api_secret: '******' # 企業微信(企業微信-->自定應用-->Secret)
    #   message: '{{ template "test_wechat.html" . }}' # 傳送訊息模板的設定

```