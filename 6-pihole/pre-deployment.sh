systemctl stop systemd-resolved
systemctl disable systemd-resolved

echo "nameserver 1.1.1.1" > /etc/resolv.conf

mkdir -p /root/docker-static
mkdir -p /root/docker-storage
mkdir -p /root/docker-storage/traefik/dynamic

cp -r traefik-config/* /root/docker-storage/traefik/dynamic

mkdir -p /root/docker-storage/pihole/pihole-config
mkdir -p /root/docker-storage/pihole/dnsmasq-config

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env