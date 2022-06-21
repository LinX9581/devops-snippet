# 建置
開port 1194
nano docker-compose.yml

version: '2'

services:
  ovpn:
    image: kylemanna/openvpn
    volumes:
      - ./data:/etc/openvpn
    ports:
      - '1194:1194/udp'
    cap_add:
      - NET_ADMIN
    restart: always

docker-compose run --rm ovpn ovpn_genconfig -u udp://172.16.2.7
docker-compose run --rm ovpn ovpn_initpki
docker-compose up -d
export CLIENTNAME="cyber"
docker-compose run --rm ovpn easyrsa build-client-full "$CLIENTNAME" nopass
docker-compose run --rm ovpn ovpn_getclient "$CLIENTNAME" > "$CLIENTNAME.ovpn"