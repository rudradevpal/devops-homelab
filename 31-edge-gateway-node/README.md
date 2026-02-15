# Edge Gateway

<img src="../assets/images/edge.svg" alt="edge" width="200px"/>

## Introduction

An edge gateway is a device or a network entity that serves as an entry point for data traffic into or out of a network's core. It's typically located at the periphery of a network, closer to where data is generated or consumed. Edge nodes play a crucial role in edge computing, enabling processing, storage, and analysis of data closer to the source, which can reduce latency and bandwidth usage. They facilitate faster decision-making and support various applications like IoT, real-time analytics, and content delivery.

## Purpose

Here we are using Edge Gateway to:

- Ingress and Egress Gateway for a site
- Connecting Multiple sites

## Pre-requisites
### Target Server

To deploy Edge Gateway, the you should have the following prerequisites:

- Min 2GB Memory and 1 VCPU
- Connected to TPLink TL-ER605 or TL-R470T+
- Has IP ending with 2 (if your Subnet is 172.25.1.0/24 reserve 172.25.1.2 with MAC of the Gateway)

## Configuration Steps
1. Install Docker and Docker Compose
2. Configure Static Route in the TP Link Router (Do this For All the sites)
   - Login to the router
   - Go to Transmission > Routing
   - Under Static Route Add
   - Name: `to_site`, Destination IP: Destination Subnet IP(ending with 0)
   - Subnet Mask: Subnet Mask for the subnet, Next Hop: Gateway IP
   - Interface: LAN
   - Metric: 
   - Click on `OK`
3. In Gateway Run
   ```bash
   # nano /etc/sysctl.conf
   # Add Below Line
   net.ipv4.ip_forward = 1
   ```
4. Run
   ```bash
   sysctl -p

   iptables -A FORWARD -i eth0 -o wt0 -j ACCEPT
   iptables -t nat -A POSTROUTING -o wt0 -j MASQUERADE
   iptables-save > /etc/iptables/rules.v4

   reboot
   ```