#!/bin/bash
#put the static ip address and the gateway in the variables
STATIC_IP="192.168.1.5/24"
GATEWAY="192.168.1.0"
INTERFACE_NAME="eth1"

#list only the network interfaces name
available_network_interfaces=$(ip link show | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')
echo "available_network_interfaces: $available_network_interfaces"

#check if the eth1 is available
if [[ $available_network_interfaces == *"$INTERFACE_NAME"* ]]; then
    echo "$INTERFACE_NAME is available"
cat > temp.txt <<EOF
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    $INTERFACE_NAME:
      dhcp4: no
      addresses: [$STATIC_IP]
      gateway4: $GATEWAY
      nameservers:
          addresses: [8.8.8.8,1.1.1.1]
EOF
# Copy the temporary file to the network configuration file
sudo cp temp.txt /etc/netplan/01-netcfg.yaml
#apply the changes
sudo netplan apply
else
    echo "eth1 is not available"
fi

