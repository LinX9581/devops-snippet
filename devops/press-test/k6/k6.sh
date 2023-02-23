apt update
apt upgrade -y

# K6
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6

# Grafana
sudo wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - 
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt install -y apt-transport-https software-properties-common wget -y
apt update
apt install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# InfluxDb
sudo apt install influxdb
# sudo service influxdb stop

mkdir k6
cat>/k6/hello.js<<EOF
import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
    vus: 10,
    duration: '30s',
  };
  
export default function () {
  http.get('https://test.k6.io');
  sleep(1);
  const res = http.get('http://httpbin.test.k6.io');
  console.log('Response time was ' + String(res.timings.duration) + ' ms');
}
EOF
cd k6
k6 run --out influxdb=http://localhost:8086/myk6db hello.js

# Grafana Create a data source -> influxdb -> http://localhost:8086 database=myk6db
# import dashboard id 2587
# https://grafana.com/grafana/dashboards/2587

