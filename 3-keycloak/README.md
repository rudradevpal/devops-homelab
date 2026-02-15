# Keycloak

<img src="../assets/images/keycloak.png" alt="Keycloak" width="200px"/>

## Introduction

Keycloak is an open-source identity and access management solution developed by Red Hat. It provides authentication, authorization, and single sign-on capabilities for web applications and services. Keycloak allows organizations to securely manage user identities, roles, and permissions, simplifying the process of implementing security features in their applications.

## Purpose

Here we are using Keycloak to:
- Enable single sign-on for multiple applications.
- Integrate with OpenLDAP for centralized user management.
- Manage LDAP users from the Keycloak UI.
- Provide an account self-service portal for users.

## Prerequisites

### Target Server

Before deploying Keycloak, ensure the target server meets the following prerequisites:

- Public IP address
- Docker and Docker Compose installed
- Traefik installed to expose Keycloak

## Deployment Steps

1. Update `setup.env` file with the necessary details:
   - `POSTGRES_DB`: Database name for Keycloak
   - `POSTGRES_USER`: Username for Keycloak connection
   - `POSTGRES_PASSWORD`: Password for Keycloak connection
   - `KEYCLOAK_ADMIN`: Keycloak admin username
   - `KEYCLOAK_ADMIN_PASSWORD`: Keycloak admin password

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
1. Wait for approximately 5 minutes for Keycloak to fully initialize.
2. Open Keycloak UI in your browser by navigating to `keycloak.<YOUR-PARENT-DOMAIN>`.
3. Click on `Administration Console`.
4. Log in using the administrator credentials provided in the `setup.env` file.
5. From the drop-down menu next to `master`, select `Create Realm`.
6. Put Realm Name `devops-lab`
7. Click on `Create` to create the realm.
8. Navigate to `Realm Settings` 
9. In `General` Tab
   - `Display name` put as `DevOpsLab`
   - Click on `Save`
10. In `Login` Tab
   - Turn on `Remember me`
11. In `Themes` Tab
   - `Login theme` select `devops-lab`
   - `Account theme` select `Keycloak.v3`
   - `Admin theme` select `Keycloak.v2`
   - `Email theme` select `devops-lab`
   - Click on `Save`
12. In `User Profile` Tab `Create attribute` or `Edit` as per below table

   | Attribute [Name] | Display name     | Required For | User Edit | Admin Edit | User view | Admin View |
   |------------------|------------------|--------------|-----------|------------|-----------|------------|
   | title            | Title            | Both         | No        | Yes        | Yes       | Yes        |
   | employeeType     | Employee Type    | Both         | No        | Yes        | Yes       | Yes        |
   | employeeNumber   | Employee Number  | Both         | No        | Yes        | Yes       | Yes        |
   | firstName        | ${firstName}     | Both         | No        | Yes        | Yes       | Yes        |
   | lastName         | ${lastName}      | Both         | No        | Yes        | Yes       | Yes        |
   | username         | ${username}      | Both         | No        | No         | Yes       | Yes        |
   | email            | ${email}         | Both         | No        | Yes        | Yes       | Yes        |
   | mobile           | Mobile           | None         | Yes       | Yes        | Yes       | Yes        |
   | location         | Location         | None         | Yes       | Yes        | Yes       | Yes        |
   | state            | State            | None         | Yes       | Yes        | Yes       | Yes        |
   | postalCode       | Postal Code      | None         | Yes       | Yes        | Yes       | Yes        |

13. Navigate to `User Federation` and select `LDAP`.
   - `UI display name`: `ldap`
   - `Vendor`: `Other`
   - `Connection URL`: `ldap://openldap`
   - `Enable StartTLS`: off
   - `Bind type`: `simple` 
   - `Bind DN`: `cn=admin,dc=devopslab,dc=in`
   - `Bind credentials`: <LDAP_ADMIN_PASSWORD>
   - `Edit mode`: `WRITABLE`
   - `Users DN`: `ou=users,ou=devops-lab,dc=devopslab,dc=in`
   - `Username LDAP attribute`: `cn`
   - `RDN LDAP attribute`: `cn`
   - `UUID LDAP attribute`: `entryUUID`
   - `User object classes`: `inetOrgPerson`
   - Click on `Save`
14. Navigate to `User Federation` and select `LDAP`.
15. In the same window, go to the `Mappers` tab.
16. `Add Mapper` or `Edit` existing as per below table

   | Name            | Mapper type                | User Model Attribute | LDAP Attribute | Read Only | Write Only | Always Read Value From LDAP | Is Mandatory In LDAP |
   |-----------------|----------------------------|----------------------|----------------|-----------|------------|-----------------------------|----------------------|
   | email           | user-attribute-ldap-mapper | email                | mail           | Off       | Off        | On                          | On                   |
   | first name      | user-attribute-ldap-mapper | firstName            | givenName      | Off       | Off        | On                          | On                   |
   | last name       | user-attribute-ldap-mapper | lastName             | sn             | Off       | Off        | On                          | On                   |
   | username        | user-attribute-ldap-mapper | username             | cn             | Off       | Off        | On                          | On                   |
   | mobile          | user-attribute-ldap-mapper | mobile               | mobile         | Off       | Off        | On                          | Off                  |
   | location        | user-attribute-ldap-mapper | location             | l              | Off       | Off        | On                          | Off                  |
   | state           | user-attribute-ldap-mapper | state                | st             | Off       | Off        | On                          | Off                  |
   | postal code     | user-attribute-ldap-mapper | postalCode           | postalcode     | Off       | Off        | On                          | Off                  |
   | title           | user-attribute-ldap-mapper | title                | title          | Off       | Off        | On                          | On                   |
   | employee type   | user-attribute-ldap-mapper | employeeType         | employeeType   | Off       | Off        | On                          | On                   |
   | employee number | user-attribute-ldap-mapper | employeeNumber       | employeeNumber | Off       | Off        | On                          | On                   |
   | display name    | full-name-ldap-mapper      |                      | displayName    | Off       | On         |                             |                      |

17. `Add Mapper` as per below
   - `Name`: `group`
   - `Mapper type`: `group-ldap-mapper`
   - `LDAP Groups DN`: `ou=groups,ou=devops-lab,dc=devopslab,dc=in`
   - `Group Name LDAP Attribute`: `cn`
   - `Group Object Classes`: `groupOfUniqueNames`
   - `Preserve Group Inheritance`: On
   - `Ignore Missing Groups`: Off
   - `Membership LDAP Attribute`: `uniquemember`
   - `Membership Attribute Type`: `DN`
   - `Membership User LDAP Attribute`: `cn`

18. Go back to `User Federation` and select `LDAP` again.
19. From the `Action` dropdown, choose `Sync all users`.
20. (Optional) Go to `Authentication` and select `Required actions` Tab and turn `on` for `Set as default action`
   - `Configure OTP`
   - `Update Password`
   - `Verify Email`
21. (Optional) To Force users to use MFA
   - Go to `Authentication` > `browser`
   - Change `Browser - Conditional OTP` to `Required`
22. Navigate to `Users` and use the search function to search for `*` and click the search button.
23. Verify that all LDAP users are displayed.

These steps will set up Keycloak on your server, providing robust identity and access management capabilities for your applications.
