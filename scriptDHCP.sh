#!/bin/bash

apt update
apt upgrade

apt install isc-dhcp-server
apt install iptables

cat <<EOF >> /etc/default/isc-dhcp-server
INTERFACESv4="enp0s3"
INTERFACESv6=""
EOF
