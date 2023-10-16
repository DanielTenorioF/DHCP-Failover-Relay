#!/bin/bash

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
