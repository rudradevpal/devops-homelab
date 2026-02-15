# Monitoring

<img src="../assets/images/uptime.png" alt="Uptime" width="200px"/>
<img src="../assets/images/prometheus.png" alt="Prometheus" width="200px"/>
<img src="../assets/images/grafana.png" alt="Grafana" width="200px"/>

## Introduction

- **Prometheus**: An open-source monitoring and alerting toolkit designed for reliability and scalability. It collects and stores metrics as time series data, providing a powerful query language (PromQL) to retrieve and analyze this data.

- **Grafana**: An open-source analytics and monitoring platform that integrates with Prometheus and other data sources. It allows users to create and share dynamic dashboards, providing visual insights into system metrics and performance.

- **Uptime**: A monitoring tool that tracks the availability and performance of web services. It helps ensure that websites and applications are up and running, providing notifications when downtime or performance issues occur.

## Purpose

We use Monitoring to:
- Monitor servers, hypervisors, containers, power backups, etc.
- Receive real-time notifications of critical issues
- Analyze utilization and other metrics

## Prerequisites

### Target Server

Ensure the target server meets the following prerequisites before deploying Monitoring:

- Docker and Docker Compose installed
- Keycloak installed to configure authentication
- Optional: Traefik installed to expose Monitoring

## Deployment Steps

1. Update the `setup.env` file with the necessary details:
   - `HOST_LOCAL_IP`: Local IP of the server
   - `GF_SECURITY_ADMIN_USER`: Admin user for Grafana
   - `GF_SECURITY_ADMIN_PASSWORD`: Admin password for Grafana

2. Run the pre-deployment script:
   ```bash
   chmod +x pre-deployment.sh
   ./pre-deployment.sh
   ```

3. Deploy Monitoring using Docker Compose:
   ```bash
   docker-compose up -d
   ```

## Post Deployment Steps

1. Edit `/root/docker-storage/prometheus/dynamic/prometheus.json` to update all downstream Prometheus configurations.
2. Open `grafana.devopslab.in` and log in with your credentials.
3. Navigate to `Connections` > `Data sources` > `Add New Data Source`:
   - `Name`: `prometheus`
   - `Prometheus server URL`: `http://prometheus:9090`
4. Save and test the configuration.
5. Import all dashboards from the `dashboards` directory.