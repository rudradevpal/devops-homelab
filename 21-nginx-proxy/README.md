# Nginx Proxy Manager

<img src="../assets/images/nginx.svg" alt="nginx-proxy" width="200px"/>

## Introduction

NGINX Proxy Manager is a user-friendly application for managing reverse proxies, SSL certificates, and access controls through a simple web interface. It allows users to easily configure and host multiple websites, secure them with automated SSL certificates from Let's Encrypt, and set up access restrictions. Designed for ease of use, it supports multi-user access and provides a straightforward way to manage web traffic, making it ideal for both beginners and experienced users looking for efficient web service management.

## Purpose

Here we are using Nginx Proxy Manager to:

- Expose customers applications to the internet
- Route traffic to applications based on domain
- Integrate TLS certificates to the domain
- Add authentication to the application

## Pre-requisites
### Target Server

To deploy Nginx Proxy, the target server should have the following prerequisites:

- Public IP address
- Ports 80 and 443 opened
- Docker and Docker Compose installed

## Domain Provider

Before deploying Nginx Proxy Manager, ensure the following pre-requisites are met:

- Map the domain to the public IP of the target server (where Nginx Proxy Manager is deployed)

    <img src="../assets/images/dns-entry.png" alt="DNS entry"/>

## Deployment Steps

1. Update `setup.env` file with the following details:
   - `HOST_LOCAL_IP`: Local IP of the server

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```

3. Deploy Nginx Proxy using Docker Compose:
   ```bash
   docker-compose up -d
   ```

These steps will set up Nginx Proxy on your server, allowing you to manage traffic effectively and securely route requests to your applications.