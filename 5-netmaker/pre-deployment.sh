sudo ufw allow proto tcp from any to any port 443
sudo ufw allow proto tcp from any to any port 80
sudo ufw allow proto tcp from any to any port 3479
sudo ufw allow proto tcp from any to any port 8089
sudo ufw allow 51821:51830/udp

mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r docker-static/* /root/docker-static/
cp -r traefik-config/* /root/docker-storage/traefik/dynamic

mkdir -p /root/docker-storage/netmaker-mosquitto/mosquitto_logs
mkdir -p /root/docker-storage/netmaker-mosquitto/mosquitto_data
mkdir -p /root/docker-storage/netmaker/dnsconfig
mkdir -p /root/docker-storage/netmaker/sqldata

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
