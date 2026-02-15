# NetBird

<img src="../assets/images/netbird.png" alt="NetBird" width="200px"/>

## Introduction

Netbird is a comprehensive network monitoring and management tool designed to provide administrators with real-time insights into the performance, availability, and security of their network infrastructure. With its intuitive interface and powerful features, Netbird empowers users to proactively monitor network traffic, detect and troubleshoot issues, and ensure the optimal operation of their network environment. Key features include real-time monitoring, alerting and notifications, traffic analysis, security monitoring, configuration management, and scalability. Overall, Netbird offers administrators the tools and insights they need to ensure the reliability, performance, and security of their network infrastructure at all times.

## Purpose

Here we are using NetBird to:
- Enable VPN to access all services
- Creating an Overlay network for the organization
- Managing Site to Site Connectivity
- Role based Network access Control

## Prerequisites

### Target Server

Before deploying NetBird, ensure the target server meets the following prerequisites:

- Public IP address
- Docker and Docker Compose installed
- Keycloak Installed to configure authentication for netbird
- Optional: Traefik installed to expose NetBird

## Pre-Deployment Steps

1. Open Keycloak Admin Console
2. Select the required Realm (left-hand menu)
3. Go to `Clients` (left-hand menu)
4. Click `Create client` button
5. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `netbird-client`
   - Name: `Netbird Application Client`
6. Next Screen Set Toggle/Checkboxes as per below
   - Client authentication: `off`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
7. Next Screen
   - Root URL: `https://netbird.<YOUR-PARENT-DOMAIN>`
   - Valid redirect URIs:
      - `https://netbird.<YOUR-PARENT-DOMAIN>/*`
      - `http://localhost:53000`
   - Valid post logout redirect URIs: `https://netbird.<YOUR-PARENT-DOMAIN>/*`
   - Web origins: `+`
8. Click `Save`
9. Click `Client scopes` (left-hand menu)
10. Click `Create client scope` button
11. Fill in the form with the following values:
   - Name: `netbird-api`
   - Type: `Default`
   - Protocol: `OpenID Connect`
12. Click `Save`
13. Go to the `Mappers` tab
14. Click `Configure a new mapper`
15. Choose the `Audience` mapping
16. Fill ill in the form with the following values:
   - Name: `Audience for NetBird Management API`
   - Included Client Audience: `netbird-client`
   - Add to access token: `on`
   - Add to token introspection: `on`
17. Click `Save`
18. Click `Clients` (left-hand menu)
19. Choose `netbird-client` from the list
20. Switch to `Client scopes` tab
21. Click `Add client scope` button
22. Choose `netbird-api`
23. Click `Add` choosing `Default`
24. Click `Clients` (left-hand menu)
25. Click `Create client` button
26. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `netbird-backend`
   - Name: `NetBird Backend Client`
27. Next Set Toggle/Checkboxes as per below
   - Client authentication: `on`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
      - Service accounts roles
28. Next Screen Leave Everything
29. Click `Save`
30. Go to `Credentials` tab for that client
31. Copy `Client Secret` and Keep it safe it will be used later
32. Go to `Service accounts roles` tab for that client
33. Click `Assign roles` button
34. Select `Filter by clients` and search for `view-users`
35. Check the role checkbox and click `assign`

## Deployment Steps
1. Update `setup.env` file with the necessary details:
   - `NETBIRD_DOMAIN`: Domain for netbird. https://netbird.<YOUR-PARENT-DOMAIN>
   - `NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT`: Keycloak OICD endpoint. <YOUR-KEYCLOAK-ROOT-URL>/realms/devops-lab/.well-known/openid-configuration
   - `NETBIRD_IDP_MGMT_CLIENT_SECRET`: Update with the Secret generated from Keycloak `@Pre-Deployment Step 31`
   - `NETBIRD_IDP_MGMT_EXTRA_ADMIN_ENDPOINT`: Keycloak admin endpoint. <YOUR-KEYCLOAK-ROOT-URL>/admin/realms/devops-lab
   - `NETBIRD_MGMT_DNS_DOMAIN`: netbird-net.<YOUR-PARENT-DOMAIN>

2. Install dependency packages on the host
   ```bash
   sudo apt-get install curl jq -y
   ```
3. Download the official repository
   ```bash
   REPO="https://github.com/netbirdio/netbird/"
   # FOR STABLE
   LATEST_TAG=$(basename $(curl -fs -o/dev/null -w %{redirect_url} ${REPO}releases/latest))
   echo $LATEST_TAG
   git clone --depth 1 --branch $LATEST_TAG $REPO
   ```
4. Generate environments parameters:
   ```bash
   cd netbird/infrastructure_files/
   cp ../../setup.env .
   ./configure.sh
   cd ../..
   cp netbird/infrastructure_files/artifacts/management.json docker-static/netbird-mgmt/management.json
   cp netbird/infrastructure_files/artifacts/turnserver.conf docker-static/netbird-coturn/turnserver.conf
   cat netbird/infrastructure_files/artifacts/docker-compose.yml
   ```

5. Take environments from above output and update it in docker-compose.yml
6. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
7. Deploy netbird using Docker Compose:
   ```bash
   docker-compose up -d
   ```

## Post Deployment Steps
1. Open https://netbird.<YOUR-PARENT-DOMAIN> and login with SSO
2. The First Logged in user will be the admin
