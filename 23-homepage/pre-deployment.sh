mkdir -p /root/docker-static
mkdir -p /root/docker-storage

mkdir -p /root/docker-storage/homepage/config
mkdir -p /root/docker-storage/homepage/images

chmod -R 0777 /root/docker-storage
chmod -R 0777 /root/docker-static

cp setup.env .env
