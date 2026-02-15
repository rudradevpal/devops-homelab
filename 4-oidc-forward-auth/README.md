# OIDC Forward Auth

<img src="../assets/images/oidc.png" alt="OIDC Forward Auth" width="200px"/>

## Introduction

OIDC Forward Authentication leverages the OpenID Connect protocol to authenticate users via an Identity Provider (IdP) before granting access to protected resources. It typically involves a reverse proxy (such as NGINX or Traefik) configured with OIDC middleware that intercepts requests, redirects unauthenticated users to the IdP, and validates the returned authentication tokens. This approach ensures that only authenticated users can access specified services, simplifies the authentication process by offloading it to a trusted IdP, and supports scalable and flexible integration within various application architectures, making it ideal for securing microservices and implementing Single Sign-On (SSO) across multiple applications.

## Purpose

Here we are using OIDC Forward Auth to:
- Enable single sign-on for applications that doesnot support OIDC.

## Prerequisites
### Target Server

Before deploying OIDC Forward Auth, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- Traefik installed to use OIDC Forward Auth

## Pre-Deployment Steps

1. Open Keycloak Admin Console
2. Select the required Realm (left-hand menu)
3. Go to `Clients` (left-hand menu)
4. Click `Create client` button
5. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `forward-auth`
   - Name: `Forward Auth`
6. Next Set Toggle/Checkboxes as per below
   - Client authentication: `on`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
      - Service accounts roles
7. Next Screen
   - Root URL: `blank`
   - Home URL: `blank`
   - Valid redirect URIs: `*`
   - Valid post logout redirect URIs: `blank`
   - Admin URL: `blank`
   - Web origins: `+`
8. Click `Save`
9. Go to `Credentials` tab for that client
10. Copy `Client Secret` and Keep it safe it will be used later

## Deployment Steps

1. Update `setup.env` file with the necessary details:
   - `PROVIDERS_OIDC_ISSUER_URL`: OIDC Issuer URL (e.g. `https://keycloak.devopslab.in/realms/devops-lab`)
   - `PROVIDERS_OIDC_CLIENT_ID`: `forward-auth`
   - `PROVIDERS_OIDC_CLIENT_SECRET`: OIDC Client Secret that we copied in Pre-Deployment Steps - 10
   - `SECRET`: Some random Secret Value
   - `INSECURE_COOKIE`: INSECURE_COOKIE is `true` if using a http entrypoint else `false`

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```

3. Deploy OpenLDAP and phpLDAPadmin using Docker Compose:
   ```bash
   docker-compose up -d
   ```

These steps will set up OIDC Forward Auth on your server, providing robust identity and access management capabilities for your applications.
