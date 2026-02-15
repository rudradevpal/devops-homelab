# PowerDNS

<img src="../assets/images/post-configuration.png" alt="PowerDNS" width="200px"/>

## Introduction

Once all required Tools are deployed and configured we need to configure few more things to integrate all those

## Purpose

- Every tool is configured to talk to each other
- Estblish toolchanins flow

## Prerequisites

### Target Server

Before starting, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- OpenLdap, Keycloak, Netbird Installed
- Atleast one sample client(e.g. Your Laptop) client connected to VPN

## Steps

1. Check the sample client and get the VPN subnet IP (e.g. 100.89.131.191/16)
2. Get the subnet from that. e.g. 100.89.0.0/16
3. Check Local Subnet of Gateway Host(Use `ip r s`). e.g. 10.10.0.0/24
4. Go to `/root/docker-storage/traefik/dynamic/traefik-middlewares.yml` in the gateway node and update
   ```bash
   # nano /root/docker-storage/traefik/dynamic/traefik-middlewares.yml
   ...
   ...

   middlewares:
    internal_only:
      ipAllowList:
        sourceRange:
          - "10.10.0.0/24"    # Update VPN Subnet Here
          - "100.89.0.0/16"   # Update Local Subnet Here
   ...
   ...
   ```
5. Login to PowerDNS UI
6. Click On `Create Zone`
   - `Zone Name`: `devopslab.in`
   - Click On `Create Zone`
7. Click on Zone Name
8. Click on `Add Record`
   - `Name`: `*`
   - `Type`: `A`
   - `Data`: Gateway Host Private IP (e.g. `10.10.0.58`)
9. Click on `Save` > `Save Changes` > `Apply Changes` > `OK`
10. Check if DNS resolving correctly
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
11. Loging to Netbird Management UI
12. Go to `Setup Keys` > `Name: devopslab-cloud-gateway-0` > `Create Setup Keys`
13. Copy the key
14. Login to the cloud Gateway Host and run
   ```bash
   curl -fsSL https://pkgs.netbird.io/install.sh | sh
   
   netbird up --management-url https://netbird.devopslab.in:443 --setup-key <YOUR_SETUP_KEY>
   Connected
   ```
15. Go to Netbird UI > `Network Routes` > `Add Route`
   - `Network Range` : Local Subnet from Step 3
   - `Routing Peer`: Select your Cloud Gateway
   - `Distribution Groups`: `All`
   - `Name`: `to-cloud`
16. Select `Continue` > `Add Route`
17. +++++ SKIP +++++ Go to `DNS` > `Nameservers` > `Add Nameserver`
18. +++++ SKIP +++++ Choose `CloCloudflare DNS` and Select Group `All` and `Add Nameserver`
19. Go to `DNS` > `Nameservers` > `Add Nameserver`
20. Choose `Custom DNS` and Select 
   - `IP`: Local IP of Cloud Gateway (e.g. 10.10.0.58)
   - `Distribution Group`: `All`
   - `DNS Name`: `DevOpsLab DNS`
   - +++++ SKIP +++++ `Match Domains`: `devopslab.in`
   
## Security Settings
1. Login to Cloud Gateway Host
2. Edit Traefik Routing files under `/root/docker-storage/traefik/dynamic/` and Uncomment internal-only for those its required
   ```bash
   nano /root/docker-storage/traefik/dynamic/traefik-keycloak.yml
   ...
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
   ...

   nano /root/docker-storage/traefik/dynamic/traefik-openldap.yml
   ...
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
   ...

   nano /root/docker-storage/traefik/dynamic/traefik-pdns.yml
   ...
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
   ...
   ```
