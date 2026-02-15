**DevOps HomeLab**

### Overview:
This repository contains the complete configuration and infrastructure setup for a self-hosted DevOps homelab environment. It includes reverse proxy routing, authentication systems, networking, monitoring, identity management, remote access, DNS, and infrastructure services.

The setup is designed to provide:

* Centralized authentication & identity management
* Secure service exposure via reverse proxy
* Infrastructure monitoring & observability
* Private networking & connectivity
* Remote access services
* Edge + cloud gateway architecture
* Containerized deployments (Docker-based)

### Architecture Components

#### Reverse Proxy & Routing

* **Traefik** - Core reverse proxy, routing, TLS termination, and service exposure
* **Nginx Proxy** - Additional proxy handling and upstream routing

#### Authentication & Identity

* **Authentik** - Identity provider and authentication gateway
* **Keycloak** - Identity and access management with custom themes
* **OpenLDAP** - Directory services for centralized user management
* **OIDC Forward Auth** - Authentication middleware for protected services

#### Networking & Connectivity

* **NetBird** - Secure private networking (WireGuard-based mesh VPN)
* **Netmaker** - Virtual overlay network management
* **Edge Gateway (Node / Router)** - Edge routing and gateway infrastructure
* **Kloudbeams Connect** - Custom connectivity service

#### Remote Access & Infrastructure

* **Apache Guacamole** - Clientless remote desktop gateway
* **rdesktop** - Remote desktop access
* **Proxmox Integration** - Virtualization platform monitoring and access

#### Monitoring & Observability

* **Prometheus** - Metrics collection and monitoring
* **Grafana Dashboards** - Visualization and observability dashboards
* **Cloud Gateway Monitoring** - Downstream monitoring pipeline
* **Edge Monitoring Stack** - Edge infrastructure metrics
* **PVE Exporter** - Proxmox metrics exporter
* **Speedtest Tracker** - Network performance monitoring

#### Infrastructure & Management Tools

* **Portainer** - Container management UI
* **Portainer Agent** - Distributed container management
* **Homepage Dashboard** - Central service dashboard

#### DNS & Network Services

* **Pi-hole** - Network-wide ad blocking and DNS filtering
* **PowerDNS** - Authoritative DNS service

#### Power & Hardware Management

* **NUT Server** - UPS monitoring and power management
* **UPSnap** - Wake-on-LAN management


### Architecture
![Architecture](assets/images/architecture.png)

### Physical Network Communication
![Physical Network Communication](assets/images/network-physical.png)

### Virtual Network Communication
![Virtual Network Communication](assets/images/network-virtual.png)

### Logical Communication
![Local Communication](assets/images/network-logical.png)

### Service Communication
![Service Communication](assets/images/service.png)

### Contributing:
Contributions to DevOpsLab are welcome! Please refer to the CONTRIBUTING.md file in the repository for guidelines on how to contribute effectively.

### License:
DevOpsLab Lab is licensed under the [MIT License](LICENSE.md). Please review the license file for more details.

### Support:
For support or inquiries, contact [email@example.com](mailto:email@example.com).

### About:
DevOpsLab is developed and maintained by [Your Organization Name]. Our mission is to empower organizations with efficient DevOps solutions to accelerate software delivery and innovation.

### Version:
Current Version: 1.0.0

### Changelog:
- Version 1.0.0:
  - Initial release

### Roadmap:
- Version 1.1.0:
  - Enhanced monitoring and logging features
  - Improved scalability and performance optimizations
- Version 1.2.0:
  - Additional integrations with popular DevOps tools and cloud services
  - Advanced security enhancements and compliance controls
- Version 2.0.0:
  - Major feature updates based on user feedback and requirements
  - Compatibility improvements and bug fixes

### How to Contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/feature-name`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/feature-name`).
5. Create a new Pull Request.


apt install apache2-utils -y
docker network rm devops-lab_docker_network > /dev/null 2>&1
docker network create devops-lab_docker_network  --driver bridge --subnet=10.1.0.0/16
