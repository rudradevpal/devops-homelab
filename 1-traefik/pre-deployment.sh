mkdir -p /root/docker-static
mkdir -p /root/docker-storage

cp -r docker-static/* /root/docker-static/
cp -r docker-storage/* /root/docker-storage/

mkdir -p /root/docker-storage/traefik/dynamic
mkdir -p /root/docker-storage/traefik/letsencrypt

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
