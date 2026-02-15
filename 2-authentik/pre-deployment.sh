mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r traefik-config/* /root/docker-storage/traefik/dynamic

mkdir -p /root/docker-storage/authentik-postgresql
mkdir -p /root/docker-storage/authentik-redis
mkdir -p /root/docker-storage/authentik-server/media
mkdir -p /root/docker-storage/authentik-server/certs
mkdir -p /root/docker-storage/authentik-server/custom-templates

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
