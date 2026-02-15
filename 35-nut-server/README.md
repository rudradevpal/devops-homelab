# NUT

<img src="../assets/images/nut.png" alt="NUT" width="200px"/>

## Introduction

A NUT server in the context of small-scale computing or home networks refers to the "Network UPS Tools" server. NUT is an open-source project that provides a standardized way to monitor and manage uninterruptible power supplies (UPS) over a network. It is particularly useful for ensuring that various devices connected to the UPS can be monitored and controlled in case of power issues.

## Purpose

Here we are using NUT to:
- Get Status of Battery Health of UPS
- Monitor Status of the UPS
- Trigger Action depending on UPS state

## Prerequisites

### Target Server

Before deploying NUT, ensure the target server meets the following prerequisites:

- Connected to the UPS over USB Serial Port

## Deployment Steps
1. Check USB Serial Devices and if the UPS is detected
   ```shell
   lsusb
   ```
2. Install Dependency Packages
   ```shell
   sudo apt-get install -y libusb-1.0-0-dev libsnmp-dev libneon27-dev libavahi-client-dev libfreeipmi-dev libupsclient-dev
   ```
3. Install NUT Server and Client
   ```shell
   sudo apt-get install -y nut nut-client nut-server
   ```
4. Scan for the UPS
   ```shell
   sudo nut-scanner -U

   # YOU WILL SEE SOME OUTPUT LIKE BELOW. KEEP A NOTE OF THIS
   [nutdev1]
      driver = "usbhid-ups"
      port = "auto"
      vendorid = "051D"
      productid = "0002"
      product = "Back-UPS RS 1000G-IN FW:900.L10.I USB FW:L10"
      serial = "B22307020051"
      vendor = "American Power Conversion"
      bus = "001"
      device = "003"
      busport = "004"
      ###NOTMATCHED-YET###bcdDevice = "0090"
   ```
5. Update `ups.conf` depending on above output
   ```shell
   sudo mv /etc/nut/ups.conf /etc/nut/ups.example.conf
   sudo nano /etc/nut/ups.conf

   # WITH BELOW CONTENT
   pollinterval = 1
   maxretry = 3

   [ups-0-hyd]                # Update Name here
      driver = "usbhid-ups"
      port = "auto"
      desc = "APC Back-UPS RS 1000G-IN"
      vendorid = "051D"
      productid = "0002"
      serial = "B22307020051"
   ```
6. Update `upsmon.conf`
   ```shell
   sudo mv /etc/nut/upsmon.conf /etc/nut/upsmon.example.conf
   sudo nano /etc/nut/upsmon.conf

   # WITH BELOW CONTENT
   RUN_AS_USER root

   MONITOR ups-0-hyd@localhost 1 devops-lab DevOpsLab@12345 master # Update Creds and Name Here
   ```
7. Update `upsd.conf`
   ```shell
   sudo mv /etc/nut/upsd.conf /etc/nut/upsd.example.conf
   sudo nano /etc/nut/upsd.conf

   # WITH BELOW CONTENT
   LISTEN 0.0.0.0 3493
   ```
8. Update `nut.conf`
   ```shell
   sudo mv /etc/nut/nut.conf /etc/nut/nut.example.conf
   sudo nano /etc/nut/nut.conf

   # WITH BELOW CONTENT
   MODE=netserver
   ```
9. Update `upsd.users`
   ```shell
   sudo mv /etc/nut/upsd.users /etc/nut/upsd.example.users
   sudo nano /etc/nut/upsd.users

   # WITH BELOW CONTENT (Update Creds Here)
   [monuser]
      password = DevOpsLab@12345
      devops-lab master
   ```
10. Reboot the System
    ```shell
    reboot
    ```

## Post Deployment Steps
To configure NUT client in a target Server SSH to the server

1. Install Required Packages
   ```shell
   sudo apt install -y nut-client
   ```
2. Test the connection
   ```shell
   upsc ups-0-hyd@172.25.2.2     # Update IP and Name here
   ```
3. Update `upsmon.conf`
   ```shell
   sudo mv /etc/nut/upsmon.conf /etc/nut/upsmon.example.conf
   sudo nano /etc/nut/upsmon.conf

   # WITH BELOW CONTENT
   RUN_AS_USER root

   MONITOR ups-0-hyd@172.25.2.2 1 devops-lab DevOpsLab@12345 slave # Update IP and Creds Here
   MINSUPPLIES 1
   SHUTDOWNCMD "/sbin/shutdown -h"
   NOTIFYCMD /usr/sbin/upssched
   POLLFREQ 2
   POLLFREQALERT 1
   HOSTSYNC 15
   DEADTIME 15
   POWERDOWNFLAG /etc/killpower

   NOTIFYMSG ONLINE    "UPS %s on line power"
   NOTIFYMSG ONBATT    "UPS %s on battery"
   NOTIFYMSG LOWBATT   "UPS %s battery is low"
   NOTIFYMSG FSD       "UPS %s: forced shutdown in progress"
   NOTIFYMSG COMMOK    "Communications with UPS %s established"
   NOTIFYMSG COMMBAD   "Communications with UPS %s lost"
   NOTIFYMSG SHUTDOWN  "Auto logout and shutdown proceeding"
   NOTIFYMSG REPLBATT  "UPS %s battery needs to be replaced"
   NOTIFYMSG NOCOMM    "UPS %s is unavailable"
   NOTIFYMSG NOPARENT  "upsmon parent process died - shutdown impossible"

   NOTIFYFLAG ONLINE   SYSLOG+WALL+EXEC
   NOTIFYFLAG ONBATT   SYSLOG+WALL+EXEC
   NOTIFYFLAG LOWBATT  SYSLOG+WALL
   NOTIFYFLAG FSD      SYSLOG+WALL+EXEC
   NOTIFYFLAG COMMOK   SYSLOG+WALL+EXEC
   NOTIFYFLAG COMMBAD  SYSLOG+WALL+EXEC
   NOTIFYFLAG SHUTDOWN SYSLOG+WALL+EXEC
   NOTIFYFLAG REPLBATT SYSLOG+WALL
   NOTIFYFLAG NOCOMM   SYSLOG+WALL+EXEC
   NOTIFYFLAG NOPARENT SYSLOG+WALL

   RBWARNTIME 43200

   NOCOMMWARNTIME 600

   FINALDELAY 5
   ```
4. Update `nut.conf`
   ```shell
   sudo mv /etc/nut/nut.conf /etc/nut/nut.example.conf
   sudo nano /etc/nut/nut.conf

   # WITH BELOW CONTENT
   MODE=netclient
   ```
5. Update `upssched.conf`
   ```shell
   sudo mv /etc/nut/upssched.conf /etc/nut/upssched.example.conf
   sudo nano /etc/nut/upssched.conf

   # WITH BELOW CONTENT
   CMDSCRIPT /etc/nut/upssched-cmd
   PIPEFN /etc/nut/upssched.pipe
   LOCKFN /etc/nut/upssched.lock

   AT ONBATT * START-TIMER onbatt 30
   AT ONLINE * CANCEL-TIMER onbatt online
   AT ONBATT * START-TIMER earlyshutdown 30     # Update 30 to required time in sec
   AT LOWBATT * EXECUTE onbatt
   AT COMMBAD * START-TIMER commbad 30
   AT COMMOK * CANCEL-TIMER commbad commok
   AT NOCOMM * EXECUTE commbad
   AT SHUTDOWN * EXECUTE powerdown
   AT SHUTDOWN * EXECUTE powerdown
   ```
6. Create `upssched-cmd` script
   ```shell
   sudo nano /etc/nut/upssched-cmd

   # WITH BELOW CONTENT
   #!/bin/sh
   case $1 in
         onbatt)
            logger -t upssched-cmd "UPS running on battery"
            ;;
         earlyshutdown)
            logger -t upssched-cmd "UPS on battery too long, early shutdown"
            /usr/sbin/upsmon -c fsd
            ;;
         shutdowncritical)
            logger -t upssched-cmd "UPS on battery critical, forced shutdown"
            /usr/sbin/upsmon -c fsd
            ;;
         upsgone)
            logger -t upssched-cmd "UPS has been gone too long, can't reach"
            ;;
         *)
            logger -t upssched-cmd "Unrecognized command: $1"
            ;;
   esac
   ```
7. Change Permission of the Script and Create Dir for `PIPEFN` and `LOCKFN`
   ```shell
   chmod +x /etc/nut/upssched-cmd
   mkdir /etc/nut/upssched/
   ```
8. Restart NUT Client
   ```shell
   systemctl restart nut-client
   ```