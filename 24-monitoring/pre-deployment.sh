mkdir -p /root/docker-static
mkdir -p /root/docker-storage

cp -r docker-static/* /root/docker-static/
cp -r docker-storage/* /root/docker-storage/

mkdir -p /root/docker-storage/prometheus/data
mkdir -p /root/docker-storage/grafana
mkdir -p /root/docker-storage/uptime

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env