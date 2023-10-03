curl "http://127.0.0.1/dynamic?upstream=zone_for_backends"

curl "http://127.0.0.1/dynamic?upstream=zone_for_backends&server=34.81.41.232:80&down="

curl "http://127.0.0.1/dynamic?upstream=zone_for_backends&server=34.81.41.232:80&up="

curl "http://127.0.0.1/dynamic?upstream=zone_for_backends&add=&server=127.0.0.1:6004"