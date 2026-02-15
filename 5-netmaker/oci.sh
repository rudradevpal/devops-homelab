sudo iptables -I INPUT -p udp -m udp --dport 51821 -j ACCEPT

# https://dev.to/rahgadda/multi-cloud-networking-e1
sudo iptables -A FORWARD -j ACCEPT
sudo iptables -A INPUT -j ACCEPT
sudo iptables -A OUTPUT -j ACCEPT

sudo iptables-save > /etc/iptables/rules.v4

sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sudo echo "net.ipv4.conf.all.src_valid_mark=1" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.all.disable_ipv6=0" >> /etc/sysctl.conf
sudo echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf

sudo sysctl -p