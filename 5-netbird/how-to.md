Following: https://docs.netbird.io/selfhosted/selfhosted-guide

Configure keycloak https://docs.netbird.io/selfhosted/identity-providers#keycloak (Recomanded use netbird-api incase of api scope)

sudo apt-get install curl jq -y

#!/bin/bash
REPO="https://github.com/netbirdio/netbird/"
LATEST_TAG=$(basename $(curl -fs -o/dev/null -w %{redirect_url} ${REPO}releases/latest))
echo $LATEST_TAG
git clone --depth 1 --branch $LATEST_TAG $REPO
cd netbird/infrastructure_files/

Copy setup.env and modify required params
Run ./configure.sh
Copy artifacts/management.json to docker-static/netbird-mgmt/management.json (This Repo)
cp artifacts/ /root/homelab-full/2-netbird/docker-static/netbird-mgmt/

Copy artifacts/turnserver.conf to docker-static/netbird-coturn/turnserver.conf (This Repo)
cp artifacts/management.json /root/homelab-full/2-netbird/docker-static/netbird-mgmt/

cat artifacts/docker-compose.yml
Copy Environments from the file to docker-compose.yml (This Repo)

Update Traefik config from traefik.yml

chmod +x run.sh; ./run.sh