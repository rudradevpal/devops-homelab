# UpSnap

<img src="../assets/images/upsnap.png" alt="UpSnap" width="200px"/>

## Introduction

UpSnap (WoL) is a networking standard that allows a computer to be turned on or awakened remotely by a network message. This feature is useful for managing and maintaining systems, especially in large networks or for remote access.

## Purpose

Here we are using UpSnap to:
- Turn on Servers using Magic Packet
- Turn off Servers using Shell Command

## Prerequisites

### Target Server

Before deploying UpSnap, ensure the target server meets the following prerequisites:

- Docker and Docker Compose installed
- Optional: Traefik installed to expose UpSnap

## Deployment Steps
1. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
2. Deploy UpSnap using Docker Compose:
   ```bash
   docker-compose up -d
   ```