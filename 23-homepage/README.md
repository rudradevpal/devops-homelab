# Homepage

<img src="../assets/images/guacamole.png" alt="guacamole" width="200px"/> 

## Introduction

Apache Guacamole is an open-source, clientless remote desktop gateway that allows users to access their desktop environments from any device with a web browser. By utilizing HTML5, Guacamole enables remote access to a variety of desktop protocols, such as VNC, RDP, and SSH, without the need for additional client software. This makes it highly versatile and accessible for managing and interacting with remote systems. Its architecture comprises a server component (guacd) and a web application, which together provide a seamless and secure remote desktop experience. Guacamole is ideal for IT administrators, developers, and end-users who require reliable and straightforward remote access to their systems.

## Purpose

Here we are using Guacamole to:

- Connect to SSH, RDP, VNC without connecting to VPN
- Role Based Access Control for Servers

## Pre-requisites
### Target Server

To deploy Guacamole, the you should have the following prerequisites:

- Traefik Configured to forward trrafic
- Docker and Docker Compose installed

## Pre-Deployment Steps
1. Open Keycloak Admin Console
2. Select the required Realm (left-hand menu)
3. Go to `Clients` (left-hand menu)
4. Click `Create client` button
5. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `guacamole`
   - Name: `Guacamole Application Client`
6. Next Set Toggle/Checkboxes as per below
   - Client authentication: `on`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Implicit flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
      - Service accounts roles
7. Next Screen
   - Root URL: `https://guacamole.<YOUR-PARENT-DOMAIN>`
   - Home URL: `https://guacamole.<YOUR-PARENT-DOMAIN>`
   - Valid redirect URIs: `https://guacamole.<YOUR-PARENT-DOMAIN>/*`
   - Valid post logout redirect URIs: `https://guacamole.<YOUR-PARENT-DOMAIN>/*`
   - Admin URL: `https://guacamole.<YOUR-PARENT-DOMAIN>`
   - Web origins: `+`
8. Click `Save`
9. Go to `Credentials` tab for that client
10. Copy `Client Secret` and Keep it safe it will be used later

## Deployment Steps
1. Update `setup.env` file with the following details:
   - `HOST_LOCAL_IP`: Local IP of the server

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```

3. Deploy Guacamole using Docker Compose:
   ```bash
   docker-compose up -d
   ```

## Post Deployment Steps
1. Wait 5min for for Guacamole to fully initialize.
2. Run `docker-compose down`
3. Update file `/root/docker-storage/guacamole/config/guacamole/guacamole.properties` to add few lines
   ```shell
   # nano /root/docker-storage/guacamole/config/guacamole/guacamole.properties
   ...
   ...

   # Add Below Lines

   openid-authorization-endpoint: https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab/protocol/openid-connect/auth
   openid-jwks-endpoint: https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab/protocol/openid-connect/certs
   openid-issuer: https://keycloak.<YOUR-PARENT-DOMAIN>/realms/devops-lab
   openid-client-id: guacamole
   openid-redirect-uri: https://guacamole.<YOUR-PARENT-DOMAIN>
   openid-groups-claim-type: admins
   openid-username-claim-type: preferred_username
   extension-priority: *, openid
   # extension-priority: openid
   ...
   ...

   enable-clipboard-integration: true
   ```
4. Run `docker-compose up -d`
5. Access Web Console: https://guacamole.<YOUR-PARENT-DOMAIN>
6. Login with
   - Username: `guacadmin`
   - Password: `guacadmin`
7. Go to Right Top Dropdown after username and select `Settings`
8. Select `Users` Tab and click on `New User`
9. In `Username` enter Username of one of the LDAP/SSO Admin
10. `DON'T CLICK ON THE BOXES OF PASSWORD FIELDS`
11. In `PERMISSIONS` check all
12. Click on `Save`
13. Logout
14. Run `docker-compose down`
15. Update file `/root/docker-storage/guacamole/config/guacamole/guacamole.properties`
   ```shell
   # nano /root/docker-storage/guacamole/config/guacamole/guacamole.properties
   ...
   ...

   # extension-priority: *, openid  # Comment this line
   extension-priority: openid       # Un-Comment this line

   ...
   ...
   ```
16. Run `docker-compose up -d`
17. Access Web Console: https://guacamole.<YOUR-PARENT-DOMAIN>
18. Login with SSO with the User (For which we provided email)
19. Go to Right Top Dropdown after username and select `Settings`
20. Select `Users` Tab and select `guacadmin` User
21. Delete the User

These steps will set up Guacamole on your server.