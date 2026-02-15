mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r docker-static/* /root/docker-static/
cp -r traefik-config/* /root/docker-storage/traefik/dynamic

mkdir -p /root/docker-storage/netbird-signal
mkdir -p /root/docker-storage/netbird-mgmt

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static