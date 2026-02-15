# PowerDNS

<img src="../assets/images/powerdns.png" alt="PowerDNS" width="200px"/>

## Introduction

PowerDNS is an open-source DNS server software known for its high performance, flexibility, and scalability. It supports authoritative DNS service, DNSSEC, DNS caching, and dynamic updates. Its modular architecture allows for customization and integration with various data storage systems. Widely used by ISPs, enterprises, and hosting providers, PowerDNS offers granular control over DNS management and is constantly evolving with community support.

## Purpose

Here we are using PowerDNS to:
- Resolve internal DNS requests to internal IP
- Using same as public domain but with internal IP
   - To create Split Horizon DNS
   - So that we can generate CA Signed Certificate for web servers

## Prerequisites

### Target Server

Before deploying PowerDNS, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- Keycloak Installed to configure authentication
- VPN Subnet Created to only expose it internally
- Optional: Traefik installed to expose PowerDNS

## Pre-Deployment Steps

1. Open Keycloak Admin Console
2. Select the required Realm (left-hand menu)
3. Go to `Clients` (left-hand menu)
4. Click `Create client` button
5. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `powerdns-client`
   - Name: `PowerDNS UI Application Client`
6. Next Set Toggle/Checkboxes as per below
   - Client authentication: `on`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
      - Service accounts roles
7. Next Screen
   - Root URL: `https://pdns.<YOUR-PARENT-DOMAIN>`
   - Valid redirect URIs: `https://pdns.<YOUR-PARENT-DOMAIN>/*`
   - Valid post logout redirect URIs: `https://pdns.<YOUR-PARENT-DOMAIN>/*`
   - Web origins: `+`
8. Click `Save`
9. Click `Client scopes` (left-hand menu)
10. Click `Create client scope` button
11. Fill in the form with the following values:
   - Name: `openid`
   - Type: `Default`
   - Protocol: `OpenID Connect`
12. Click `Save`
13. Click `Clients` (left-hand menu)
14. Choose `powerdns-client` from the list
15. Switch to `Client scopes` tab
16. Click `Add client scope` button
17. Choose `openid`
18. Click `Add` choosing `Default`
19. Go to `Credentials` tab for that client
20. Copy `Client Secret` and Keep it safe it will be used later
21. Go to `Service accounts roles` tab for that client
22. Click `Assign roles` button
23. Select `Filter by clients` and search for `view-users`
24. Check the role checkbox and click `assign`

## Deployment Steps
1. Update `setup.env` file with the necessary details:
   - `MYSQL_DATABASE`: Database name for Backend DB
   - `MYSQL_USER`: Backend database username
   - `MYSQL_PASSWORD`: Backend database user password
   - `PDNS_api_key`: API Key Secret
   - `PDNSCONF_API_KEY`: 
   - `PDNS_webserver-allow-from`:
   - `PDNS_webserver_password`:

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
3. Deploy PowerDNS using Docker Compose:
   ```bash
   docker-compose up -d
   ```

## Post Deployment Steps
1. Open https://pdns.<YOUR-PARENT-DOMAIN> and create admin account
2. It will open `Server Settings` to update Power DNS API details. Update like below:
   - `PowerDNS API URL`: `http://pdns:8081/`
   - `PowerDNS API Key`: <VALUE_FROM_DEPLOYMENT_STEPS_1_PDNS_api_key>
   - `PowerDNS Version`: Latest Version. e.g.`4.1.1`
3. Go to `Settings` > `Authentication` > `Local`
   - Uncheck `Allow users to sign up` and `Save Settings`
4. Go to `Settings` > `Authentication` > `OpenID Connect OAuth`
5. `Check` the `Enable OpenID Connect OAuth`
6. `Client ID` put `powerdns-client`
7. `Client Secret` put `Client Secret` from keycloak generated in step 20 of Pre-Deployment Steps
8. `Scope` put `openid profile email`
9. `API URL` put `https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab/protocol/openid-connect/`
10. `Check` the `Enable OIDC OAuth Auto-Configuration`
11. `Metadata URL` put `https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab/.well-known/openid-configuration`
12. `Logout URL` put `https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab/protocol/openid-connect/logout`
13. Under `Claims`
   - `Username` put `preferred_username`
   - `Email` put `email`
   - `First Name` put `given_name`
   - `Last Name` put `family_name`
14. Save Settings
15. Restart PDNS UI Container
   ```bash
   docker restart pdns-ui
   ```