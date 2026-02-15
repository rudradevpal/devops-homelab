# Speedtest Tracker

<img src="../assets/images/speedtest-tracker.png" alt="speedtest-tracker" width="200px"/>

## Introduction

Speedtest Tracker is a self-hosted app that automatically monitors and records internet speed tests. It logs download and upload speeds, latency, and other metrics, offering a detailed view of internet performance over time. With customizable test settings and a user-friendly dashboard for visualizing data trends, it ensures privacy and control by running on local servers.

## Purpose

Here we are using Speedtest Tracker to:

- Testing Internet Speed for a Site

## Pre-requisites
### Target Server

To deploy Speedtest Tracker, the you should have the following prerequisites:

- Traefik Configured to forward trrafic
- Docker and Docker Compose installed

## Deployment Steps
1. Update `setup.env` file with the following details:
   - `HOST_LOCAL_IP`: Local IP of the server

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```

3. Deploy Speedtest Tracker using Docker Compose:
   ```bash
   docker-compose up -d
   ```

These steps will set up Speedtest Tracker on your server.