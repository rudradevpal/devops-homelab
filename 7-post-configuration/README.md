# PowerDNS

<img src="../assets/images/post-configuration.png" alt="PowerDNS" width="200px"/>

## Introduction

Once all required tools are deployed and configured, we need to integrate them for seamless operation.

## Purpose

- Ensure all tools can communicate with each other
- Establish toolchain flow

## Prerequisites

### Target Server

Before starting, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- OpenLDAP, Keycloak, and Netbird installed
- At least one sample client (e.g., your laptop) connected to the VPN

## Steps

1. Check the sample client and get the VPN subnet IP (e.g., 100.89.131.191/16).
2. Extract the subnet from that IP (e.g., 100.89.0.0/16).
3. Check the local subnet of the gateway host using `ip r s` (e.g., 10.10.0.0/24).
4. Check the host docker subnet of the gateway host using `ip r s` (e.g., 172.18.0.0/16).
5. Update the VPN and local subnets in the Traefik middlewares configuration:
   ```bash
   # nano /root/docker-storage/traefik/dynamic/traefik-middlewares.yml
   ...
   middlewares:
     internal_only:
       ipAllowList:
         sourceRange:
           - "10.10.0.0/24"    # Update local subnet here
           - "100.89.0.0/16"   # Update VPN subnet here
   ...
   ```
6. Login to the PowerDNS UI.
7. Create a new zone:
   - `Zone Name`: `devopslab.in`
   - Click on `Create Zone`
8. Click on the newly created zone name.
9. Add a DNS record:
   - `Name`: `*`
   - `Type`: `A`
   - `Data`: Gateway Host Private IP (e.g., `10.10.0.58`)
10. Save the changes and apply them:
   - Click on `Save`
   - Click on `Save Changes`
   - Click on `Apply Changes`
   - Click `OK`
11. Verify DNS resolution:
   ```bash
   $ nslookup test.devopslab.in 10.10.0.58
   Server:		10.10.0.58
   Address:	10.10.0.58#53

   Non-authoritative answer:
   Name:	abc73a.devopslab.in
   Address: 10.10.0.58

   $ nslookup google.com 10.10.0.58
   Server:		10.10.0.58
   Address:	10.10.0.58#53

   Non-authoritative answer:
   Name:	google.com
   Address: 142.250.195.46
   Name:	google.com
   Address: 2404:6800:4007:81f::200e
   ```
12. Login to the Netbird Management UI.
13. Create a setup key:
   - Go to `Setup Keys`
   - Name: `devopslab-cloud-gateway-0`
   - Click `Create Setup Keys`
14. Copy the setup key.
15. On the Cloud Gateway Host, run:
   ```bash
   curl -fsSL https://pkgs.netbird.io/install.sh | sh
   netbird up --management-url https://netbird.devopslab.in:443 --setup-key <YOUR_SETUP_KEY>
   Connected
   ```
16. Add a network route in Netbird (Both Cloud gateway and Docker):
   - Go to `Networks > Networks`
   - Click `Add Network` and give a name
   - Click `Add Routing Peer` Select your Cloud Gateway
   - Click `Add Resource` and give a name
   - `Address`: Local subnet from Step 3 or Docker Subnet from step 4
   - `Assigned Groups`: `All`
   - Click on `Add Resource`
17. Add a Cloudflare DNS nameserver:
   - Go to `DNS` > `Nameservers`
   - Click `Add Nameserver`
   - Choose `Cloudflare DNS`
   - Select Group `All`
   - Click `Add Nameserver`
18. Add a custom DNS nameserver:
   - Go to `DNS` > `Nameservers`
   - Click `Add Nameserver`
   - Choose `Custom DNS`
   - `IP`: Local IP of Cloud Gateway (e.g., 10.10.0.58)
   - `Distribution Group`: `All`
   - `DNS Name`: `DevOpsLab DNS`
   - `Match Domains`: `devopslab.in`

## Security Settings

1. Login to the Cloud Gateway Host.
2. Edit Traefik routing files to uncomment `internal_only` where required:
   ```bash
   nano /root/docker-storage/traefik/dynamic/traefik-keycloak.yml
   ...
   keycloak-master-ssl:
     rule: Host(`keycloak.{{env "HOST_DOMAIN"}}`) && PathPrefix(`/realms/master`)
     service: keycloak-service
     entryPoints:
       - websecure
     tls:
       certResolver: letsencrypt-default-resolver
     middlewares:
       - "error_pages"
       - "internal_only"  # Update here
   ...
   ```

   ```bash
   nano /root/docker-storage/traefik/dynamic/traefik-openldap.yml
   ...
   ldap-ui-ssl:
     rule: Host(`ldap.{{env "HOST_DOMAIN"}}`)
     service: ldap-ui-service
     entryPoints:
       - websecure
     tls:
       certResolver: letsencrypt-default-resolver
     middlewares:
       - "error_pages"
       - "internal_only"  # Update here
   ...
   ```

   ```bash
   nano /root/docker-storage/traefik/dynamic/traefik-pdns.yml
   ...
   pdns-ssl:
     rule: Host(`pdns.{{env "HOST_DOMAIN"}}`)
     service: pdns-service
     entryPoints:
       - websecure
     tls:
       certResolver: letsencrypt-default-resolver
     middlewares:
       - "error_pages"
       - "internal_only"  # Update here
   ...
   ```
3. On the cloud Network Security Only Open Below Ports
  - TCP ports: 80, 443, 33073, 10000
  - UDP ports: 3478, 49152-65535