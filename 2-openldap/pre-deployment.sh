mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r traefik-config/* /root/docker-storage/traefik/dynamic

mkdir -p /root/docker-storage/openldap/data
mkdir -p /root/docker-storage/openldap/config

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
