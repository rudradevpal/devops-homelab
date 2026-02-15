# OpenLDAP and phpLDAPadmin

<img src="../assets/images/openldap.png" alt="OpenLDAP" width="200px"/>
<img src="../assets/images/phpldapadmin.png" alt="phpLDAPadmin" width="200px"/>

## Introduction

OpenLDAP is an open-source implementation of the Lightweight Directory Access Protocol (LDAP), providing a centralized repository for storing and managing user accounts, groups, and directory information in network environments.

phpLDAPadmin is a web-based LDAP administration tool written in PHP, offering a user-friendly interface for managing LDAP directories through a web browser.

## Purpose

### OpenLDAP:
- Centralized repository for storing and managing user accounts and groups.
- Integration with other applications for unified authentication.

### phpLDAPadmin:
- Managing users and groups of OpenLDAP through a graphical user interface.

## Prerequisites

### Target Server

Before deploying OpenLDAP and phpLDAPadmin, ensure the target server meets the following prerequisites:

- Public IP address
- Port 389 opened
- Docker and Docker Compose installed
- Optional: Traefik installed to expose phpLDAPadmin

## Deployment Steps

1. Update `setup.env` file with the necessary details.
   - `LDAP_ORGANISATION`: Name of your Company
   - `LDAP_DOMAIN`: Parent domain of LDAP
   - `LDAP_ADMIN_PASSWORD`: OpenLDAP Admin user's password
2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
3. Deploy OpenLDAP and phpLDAPadmin using Docker Compose:
   ```bash
   docker-compose up -d
   ```
## Post Deployment Steps
1. Open phpLDAPadmin UI in browser `ldap.<YOUR-PARENT-DOMAIN>`
2. Click On Login
3. Login with Login DN: `cn=admin,dc=<FIRST-PART-OF-PARENT-DOMAIN>,dc=<SECOND-PART-OF-PARENT-DOMAIN>` and password as `LDAP_ADMIN_PASSWORD`
   If your `LDAP_DOMAIN` is `devopslab.in` it will be `cn=admin,dc=devopslab,dc=in`
4. Click on `Import`
5. Select file `sample.ldif`
6. Click On `Proceed >>`
7. Ignore Warnings

## Note
To allow any ldap user to search others apply belo ACL rules

1. Install ldap-utils on the host
   ```bash
   sudo apt-get install ldap-utils -y
   ```
2. Copy sample-acl.ldif to the host
3. Run below command <PASSWORD> is `LDAP_ADMIN_PASSWORD`
   ```bash
   ldapmodify -x -D "cn=admin,cn=config" -H ldap://<LOCAL_HOST_IP> -f sample-acl.ldif -w '<PASSWORD>'
   ```
