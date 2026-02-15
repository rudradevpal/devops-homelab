# Monitoring Gateway

<img src="../assets/images/prometheus.png" alt="Prometheus" width="200px"/>

## Introduction

The Monitoring Gateway is a site-specific solution designed to collect metrics from individual sites and store them in Prometheus. It then exposes these metrics to a central Prometheus server.

## Purpose

The Monitoring Gateway is used to:
- Collect and store site-specific metrics
- Expose Site Metrics to Central Prometheus

## Prerequisites

### Target Server

Ensure the target server meets the following prerequisites before deploying the Monitoring Gateway:

- Docker and Docker Compose installed

## Deployment Steps

1. Update the `setup.env` file with the necessary details:
   - `HOST_LOCAL_IP`: Local IP of the server
2. Update `docker-static/pve-exporter/pve.yml` with the PVE credentials.
3. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```
4. Deploy the Monitoring Gateway using Docker Compose:
   ```bash
   docker-compose up -d
   ```

## Post Deployment Steps

1. Edit `/root/docker-storage/prometheus/dynamic/pve.json` to update all PVE details.