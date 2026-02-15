# Proxmox

<img src="../assets/images/proxmox.png" alt="proxmox" width="200px"/>

## Introduction

Proxmox is an open-source platform for managing virtual machines and containers. It combines KVM and LXC technologies, offering a web-based interface for easy management, integrated backup solutions, and support for high availability clustering.

## Purpose

Here we are using Proxmox to:

- Create VMs for different Purposes

## Pre-Deployment Steps

1. Open Keycloak Admin Console
2. Select the required Realm (left-hand menu)
3. Go to `Clients` (left-hand menu)
4. Click `Create client` button
5. Fill in the form with the following values and click Next:
   - Client Type: `OpenID Connect`
   - Client ID: `pve-0-site`
   - Name: `Proxmox`
6. Next Set Toggle/Checkboxes as per below
   - Client authentication: `on`
   - Authorization: `off`
   - Authentication flow: `checked`
      - Standard flow
      - Direct access grants
      - OAuth 2.0 Device Authorization Grant
      - Service accounts roles
7. Next Screen
   - Root URL: `https://pve-0-site.devopslab.in`
   - Home URL: `https://pve-0-site.devopslab.in`
   - Valid redirect URIs: `https://pve-0-site.devopslab.in`
   - Valid post logout redirect URIs: `https://pve-0-site.devopslab.in`
   - Admin URL: `https://pve-0-site.devopslab.in`
   - Web origins: `+`
8. Click `Save`
9. Go to `Credentials` tab for that client
10. Copy `Client Secret` and Keep it safe it will be used later

## Deployment Steps
1. Download ISO from Proxmox Site
2. Deploy
3. For More details follow official Docs

## Post-Deployment Steps
1. Login to PVE
2. Select `pve-0-site` 
3. Go to `Updates` > `Repositories`
4. Select All Enterprise and Click `Disable`
5. Click on `Add`
6. Select `Repository` as `No Subscription`
7. Select `Add`
8. Select `Updates` > `Refresh`
9. Select `Upgrade`
10. In terminal press `y` and `Enter`
11. Select `Datacenter` 
12. Go to `Permissions` > `Realms` > `Add` >  `OpenID Connect Server`
13. Put Below
   - `Issuer URL`: `https://keycloak.devopslab.in/realms/devops-lab`
   - `Realm`: `devops-lab`
   - `Client ID`: `pve-0-site`
   - `Client Key`: Secret from Pre-Deployment Step 10
   - `Default`: `checked`
   - `Comment`: `Devops Lab SSO - Keycloak`
   - `Autocreate Users`: `checked`
   - `Username Claim`: `username`
14. OK
