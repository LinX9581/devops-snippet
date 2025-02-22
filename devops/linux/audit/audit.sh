#!/bin/bash

LOG_FILE="/var/log/audit/audit.log"
API_ENDPOINT="https://test.com/stackdriver/audit"

# 監聽 audit.log 並排除 CONFIG_CHANGE 事件
tail -fn0 "$LOG_FILE" | while read -r line; do
    # 只監控 `config_changes_` 開頭的 key，但忽略 `CONFIG_CHANGE`
    if echo "$line" | grep -E 'key="config_changes_' | grep -vq "type=CONFIG_CHANGE"; then
        # 提取關鍵資訊
        TIMESTAMP=$(echo "$line" | grep -oP 'audit\(\K[0-9]+\.[0-9]+')
        EXE=$(echo "$line" | grep -oP 'exe="[^"]+' | cut -d '"' -f 2)
        AUID=$(echo "$line" | grep -oP 'AUID="[a-zA-Z0-9]+' | cut -d '"' -f 2)
        KEY=$(echo "$line" | grep -oP 'key="[^"]+' | cut -d '"' -f 2)

        # 組合 JSON 格式
        JSON_PAYLOAD="{\"timestamp\": \"$TIMESTAMP\", \"exe\": \"$EXE\", \"auid\": \"$AUID\", \"key\": \"$KEY\"}"

        # 發送 API 請求
        echo "$JSON_PAYLOAD"
        # curl -X POST "$API_ENDPOINT" -H "Content-Type: application/json" -d "$JSON_PAYLOAD"
    fi
done
