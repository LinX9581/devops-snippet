# Docker install
docker run \
    -d \
    -p 3000:3000 \
    --name=grafana \
    grafana/grafana

# Local install
sudo wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - 
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt install -y apt-transport-https software-properties-common wget
apt update
apt install grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

初始密碼 admin/admin
設定可以調 Grafana時區

## 安裝圖表
docker exec -it grafana /bin/bash
grafana cli plugins install grafana-worldmap-panel
grafana cli plugins install marcusolsson-treemap-panel
grafana cli plugins install grafana-piechart-panel