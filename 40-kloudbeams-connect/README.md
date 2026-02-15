# DevOpsLab Connect

## Introduction
DevOpsLab Connect is a USB VPN dongle router designed to provide secure internet access through VPN to DevOpsLab Internal Servers. This guide will walk you through the steps to set up DevOpsLab Connect on your system.

## Purpose
We are using DevOpsLab Connect to:
- To access DevOpsLab Servers Securely
- When we cant install VPN client to our PC

## Requirements
- Raspberry Pi Zero W
- Minimum 2GB Micro SD Card
- Micro USB with Power Adapter
- Monitor, keyboard
- Personal Laptop
- Access to a Wi-Fi network

## Deployment Steps
1. Download the OpenWrt firmware from [here](https://firmware-selector.openwrt.org/?version=23.05.0&target=bcm27xx%2Fbcm2708&id=rpi).
2. Connect the monitor, keyboard, and power on the RPi Zero W device.
3. Run the following commands:
    ```
    uci show wireless
    uci set wireless.radio0.country='IN'
    uci set wireless.radio0.disabled='0'
    uci commit wireless
    wifi reload
    ```
4. Edit the firewall configuration file:
    ```
    vi /etc/config/firewall
    ```
5. Update the `option input` to `ACCEPT` in the `wan` zone section.
6. Save the changes and reboot the device.
    ```
    reboot
    ```
7. Connect to the `OpenWrt` Wi-Fi network from your PC
8. Access the OpenWrt UI using http://192.168.1.1.
9. Login with username `root` (password not required).
10. Navigate to `Network` > `Wireless` > `radio0` > `Scan`.
11. Join your Wi-Fi network and check `Replace wireless configuration`.
12. Set `Operating frequency` and `Channel` to `auto`.
13. Save
14. Save and apply the changes.
15. Determine the IP address using the following command from keyboard:
    ```
    ip r s
    ```
16. Update package lists:
    ```
    opkg update
    ```
17. Install necessary packages:
    ```
    opkg install kmod-usb-dwc2 kmod-usb-gadget-eth
    ```
18. Edit `/boot/config.txt` and add the following line at the end:
    ```
    dtoverlay=dwc2
    ```
19. Edit `/etc/rc.local` and add the following lines:
    ```
    modprobe g_ether
    sleep 5
    exit 0
    ```
20. Run the following command:
    ```
    modprobe g_ether
    ```
21. Access the OpenWrt UI using http://192.168.11.173(`IP Fetched in Step 15`).
22. Go to `Network` > `Interfaces` > Edit `lan` interface.
23. Select device `usb0` and save the settings.
24. Save and apply the changes.
25. Restart the LAN interface.
26. SSH into the device:
    ```
    ssh root@192.168.11.173
    ```
27. Update package lists:
    ```
    opkg update
    ```
28. Install WireGuard and Netbird:
    ```
    opkg install kmod-wireguard netbird
    ```
29. Set up Netbird:
    ```
    netbird up --management-url https://netbird.devopslab.in:443 --setup-key 9F544AA9-7A49-4658-83DD-6JUL89478E965
    ```
30. Enable and start Netbird service:
    ```
    /etc/init.d/netbird enable
    /etc/init.d/netbird start
    ```

31. Go to `Network` > `Interfaces` and add a new interface:
    - Name: `wt0`
    - Protocol: `Unmanaged`
    - Device: `wt0`
2. Create the interface and save the settings.
3. In the Firewall Settings tab, select `wan` and save the changes.
4. Save and apply the settings.
5. Reboot the system.

## Conclusion
Once you have completed these steps, your DevOpsLab Connect USB dongle router should be set up and ready to provide secure internet access through DevOpsLab's VPN.