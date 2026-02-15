mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r traefik-config/* /root/docker-storage/traefik/dynamic

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
