
* 先建立 地圖辨識的 template
curl -s -X PUT "localhost:9200/_index_template/nginx_access_geoip_template?pretty" -u elastic:password -H 'Content-Type: application/json' -d '
{
  "index_patterns": ["*log_nginx_access-*", "*nginx-access-*"],
  "priority": 600,
  "template": {
    "mappings": {
      "properties": {
        "@timestamp": { "type": "date" },
        "nginx": {
          "properties": {
            "access": {
              "properties": {
                "real_ip": { "type": "ip" },
                "response_code": { "type": "integer" },
                "geoip": {
                  "properties": {
                    "city_name": { "type": "keyword" },
                    "country_name": { "type": "keyword" },
                    "country_code2": { "type": "keyword" },
                    "continent_code": { "type": "keyword" },
                    "location": { "type": "geo_point" },
                    "region_name": { "type": "keyword" },
                    "region_code": { "type": "keyword" }
                  }
                },
                "remote_ip": { "type": "ip" },
                "http_version": { "type": "float" },
                "body_sent": {
                  "properties": { "bytes": { "type": "long" } }
                },
                "upstream_response_time": { "type": "float" }
              }
            }
          }
        }
      }
    }
  }
}'

* 要刪除當日的index才會生效
curl -s -X DELETE "localhost:9200/www_log_nginx_access-2025.11.28?pretty" -u elastic:password

* 查詢中國流量
nginx.access.geoip.geo.country_name.keyword :China