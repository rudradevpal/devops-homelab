# DRAFT




# Configuring DevOpsLab Edge Gateway on TP-Link ER605 v2
This guide provides step-by-step instructions to install OpenWrt on a factory-flashed TP-Link ER605 hardware version 2 router, including setting up the Argon theme, Wireguard, Netbird, and converting it into a DevOpsLab Edge Gateway.

## Installing OpenWrt

### 1. Initial Setup
1. **Reset the Router**: Reset your TP-Link ER605 v2 to its factory settings and configure the admin username and password.
2. **Connect to the Internet**:
   - Plug the WAN port into an active internet connection.
   - Connect the LAN port to your computer.
3. **Access the Router Web Portal**:
   - Open a web browser and go to [http://192.168.0.1](http://192.168.0.1).
   - Log in using the credentials set in step 1.

### 2. Enabling SSH Access
4. **Enable SSH**:
   - Navigate to `System Tools > Diagnostics > Remote Assistance` in the web portal.
   - Enable "Remote Assistance".
5. **Generate Password**:
   - Open the `password-gen.html` file and input the MAC address (found on the back of the router) along with the username set in step 1.

### 3. SSH into the Router
6. **SSH Login**:
   - Open a terminal on your computer and SSH into your ER605 router. If you encounter an error about the host key or key exchange method, use the following command:
     ```bash
     ssh -o hostkeyalgorithms=ssh-rsa root@192.168.0.1
     # OR
     ssh -o KexAlgorithms=+diffie-hellman-group1-sha1 admin@192.168.0.1
     ```
   - If SSH still does not work, upgrade your router's firmware to the latest version.

7. **Login Based on Firmware Version**:
   - **v2.0.1 and below**: Log in using the username `root` and the "root password" generated in step 5.
   - **v2.1.1 and above**: Log in using your web portal credentials.

8. **Enable Debug Mode**:
   - After logging in, run the following commands to enter debug mode:
     ```bash
     enable
     debug
     ```
   - When prompted, enter the "CLI debug mode password" generated in step 5. You should now see the OpenWrt banner.

### 4. Installing OpenWrt
9. **Prepare for Installation**:
   - Download `openwrt-initramfs-compact.bin` and `er605v2_write_initramfs.sh` to the router's `/tmp` directory using the following commands:
     ```bash
     cd /tmp

     # curl -o er605v2_write_initramfs.sh https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/er605v2_write_initramfs.sh
     # curl -o openwrt-initramfs-compact.bin https://raw.githubusercontent.com/chill1Penguin/er605v2_openwrt_install/main/openwrt-initramfs-compact.bin
     
     chmod +x er605v2_write_initramfs.sh
     ```

10. **Verify the Image**:
    - Check the integrity of the `openwrt-initramfs-compact.bin` file by verifying its checksum:
      ```bash
      md5sum openwrt-initramfs-compact.bin
      ```
    - Ensure the checksum matches the one listed in the [md5sums](md5sums) file.

11. **Flash the Initramfs Image**:
    - Run the script to flash the initramfs image:
      ```bash
      ./er605v2_write_initramfs.sh openwrt-initramfs-compact.bin
      ```

12. **Reboot the Router**:
    - Reboot your ER605 router and wait for it to fully restart.

13. **Access OpenWrt Interface**:
    - After rebooting, navigate to [http://192.168.1.1/](http://192.168.1.1/) in your web browser. If the page doesn't load, wait a bit longer, or try clearing your browser cache. (_Note: If another router or DHCP server is connected to the ER605, it might cause IP address conflicts. Disconnect unnecessary devices if you encounter issues._)

### 5. Finalizing the Installation
14. **Adjust UBI Layout**:
    - Run `Adjust UBI Layout` and wait for the process to complete. Do not reload the page.

15. **Download Sysupgrade Image**:
    - Download the sysupgrade image from [OpenWrt Downloads](https://downloads.openwrt.org). Alternatively, use this specific file: `openwrt-24.10.0-rc4-ramips-mt7621-tplink_er605-v2-squashfs-sysupgrade.bin`.

16. **Flash the Sysupgrade Image**:
    - Under "Step 2: Flash Sysupgrade Image," select the downloaded sysupgrade file and click "Flash". Avoid reloading or opening another tab until the flash process completes and the router reboots into OpenWrt.

17. **Final Reboot**:
    - After the final reboot, your ER605 should boot into OpenWrt. This process may take up to 10 minutes.


## Installing the Material Theme

### 1. Installation Steps

2. **Install the Material Theme**:
   - Navigate to `System > Software`.
   - Click **Update Lists** to refresh the available packages.
   - In the `Filter` section, search for **theme**.
   - Locate `luci-theme-material` in the results and click **Install**.

3. **Access the Router Web Portal**:
   - Open a new tab in your web browser and go to [http://192.168.1.1](http://192.168.1.1).
   - If the installation was successful, the Material theme will be applied automatically.


## Installing VPN Client

### 1. Installation Steps

1. **Install WireGuard and Netbird**:
   - SSH into the OpenWrt console and update the package list:
     ```bash
     opkg update
     ```
   - Install the required packages:
     ```bash
     opkg install kmod-wireguard netbird
     ```

2. **Connect to Netbird**:
   - Log in to the Netbird UI and generate the Pre-Shared Key.
   - Connect to the Netbird server using the following command:
     ```bash
     netbird up --management-url https://netbird.devopslab.in:443 --setup-key 9F544AA9-7A49-4658-83DD-6JUL89478E965
     ```
   - Enable Netbird to start automatically on boot:
     ```bash
     /etc/init.d/netbird enable
     /etc/init.d/netbird start
     ```

3. **Create the Interface for VPN**:
   - In the OpenWrt web interface, navigate to `Network` > `Interfaces` and add a new interface:
     - **Name**: `wt0`
     - **Protocol**: `Unmanaged`
     - **Device**: `wt0`
   - Create the interface and save the settings.
   - In the "Firewall Settings" tab, select `wan` and save the changes.
   - Save and apply the settings.

4. **Reboot the System**:
   - Reboot the router to apply all changes.


## Configuration

### 1. Configuration Steps

1. **Allow Netbird Routes**:
   - In the OpenWrt web interface, navigate to `Network` > `Firewall`.
   - Click on **Add** to create a new firewall zone.
     - **Name**: `wt0`
     - **Input**: `accept`
     - **Output**: `accept`
     - **Forward**: `accept`
     - **Masquerading**: Unchecked
     - **Covered networks**: `wt0`
     - **Allow forward to destination zones**: `lan`
   - Click **Save** and then **Save & Apply** to apply the changes.

2. **Set Client DNS**:
   - In the OpenWrt web interface, navigate to `Network` > `Interfaces`.
   - Edit the `lan` interface.
   - Go to the **DHCP Server** tab.
   - Navigate to **Advanced Settings**.
   - In the **DHCP-Options** field, enter `6,10.10.0.58`.
   - Click **Save** and then **Save & Apply**.
   - Restart the `lan` interface to apply the DNS settings.

3. **Change LAN Subnet**:
   - In the OpenWrt web interface, navigate to `Network` > `Interfaces`.
   - Edit the `lan` interface.
   - Go to the **General Settings** tab.
   - In the **IPv4 address** field, enter `172.25.10.1` as the new LAN IP address.
   - Go to the **DHCP Server** and then the **General Setup** tab.
   - Adjust the **Start** and **Limit** values according to your desired DHCP range.
   - Click **Save** and then **Save & Apply**.
   - Restart the `lan` interface to apply the new subnet settings.

4. **Change Hostname**:
   - Connect to OpenWrt CLI via SSH
   - Run below Commands
      ```shell
      uci set system.@system[0].hostname='devopslab-edge-gateway-0-kol'
      uci commit system
      /etc/init.d/system reload
      ```