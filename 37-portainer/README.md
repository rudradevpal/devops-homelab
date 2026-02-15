# Portainer

<img src="../assets/images/wol.png" alt="Wake on LAN" width="200px"/> 

## Introduction

Wake on LAN (WoL) is a networking standard that allows a computer to be turned on or awakened remotely by a network message. This feature is useful for managing and maintaining systems, especially in large networks or for remote access.

## Purpose

Here we are using WOL to:
- Turn on Servers using Magic Packet

## Prerequisites

### Target Server

Before deploying WOL, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- Optional: Traefik installed to expose WOL

## Deployment Steps
1. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
2. Deploy WOL using Docker Compose:
   ```bash
   docker-compose up -d
   ```