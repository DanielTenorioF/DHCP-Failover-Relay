+#!/bin/bash

apt update
apt upgrade

apt install isc-dhcp-server
apt install iptables

#cat <<EOF >> /etc/default/isc-dhcp-server
#INTERFACESv4="enp0s3"
#INTERFACESv6=""
#EOF

sudo sed -i '/^INTERFACESv4=/s/"\([^"]*\)"/"\1enp0s3"/' /etc/default/isc-dhcp-server

cat <<EOF >>/etc/dhcp/dhcpd.conf
subnet 10.0.0.0 netmask 255.255.0.0 {
  range 10.0.2.26 10.0.2.30;
  option domain-name-servers 8.8.8.8,8.8.8.4;
  option domain-name "internal.example.org";
  option routers 10.0.2.5;
  option broadcast-address 10.0.255.255;
  default-lease-time 600;
  max-lease-time 7200;
}
EOF

systemctl restart isc-dhcp-server

systemctl disable NetworkManager
systemctl stop NetworkManager

cat <<EOF >> /etc/network/interfaces
# Configuracion red estatica enp0s8
auto enp0s8
iface enp0s8 inet static
address 172.26.2.50
network 172.26.0.0
netmask 255.255.0.0
gateway 172.26.0.1

# Configuracion red estatica enp0s3
auto enp0s3
iface enp0s3 inet static
address 10.0.2.5
network 10.0.0.0
netmask 255.255.0.0
EOF

systemctl restart networking

