#!/bin/bash

sudo apt update
sudo apt upgrade -y

apt install isc-dhcp-server -y
apt install iptables -y

sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager

sudo sed -i '/^INTERFACESv4=/s/"\([^"]*\)"/"\1enp0s3"/' /etc/default/isc-dhcp-server


# Configuracion IP SERVIDOR

sudo bash -c 'cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto enX0
iface enp0s3 inet static
        address 172.31.16.64
        netmask 255.255.240.0
        network 172.31.16.0
        broadcast 172.31.31.255

#auto enp0s8
#iface enp0s8 inet dhcp
EOF'


# Configuracion DHCP SERVIDOR y FAILOVER

sudo bash -c 'cat << EOF > /etc/dhcp/dhcpd.conf
# dhcpd.conf

option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;

authoritative;
failover peer "FAILOVER" {
  primary;
  address 172.31.16.64;
  port 647;
  peer address 172.31.16.65;
  peer port 647;
  max-unacked-updates 10;
  max-response-delay 30;
  load balance max seconds 3;
  mclt 1800;
  split 128;
}

subnet 172.31.16.0 netmask 255.255.240.0 {
  option broadcast-address 172.31.31.255;
  option routers 172.31.16.1;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  pool {
    failover peer "FAILOVER";
    max-lease-time 3600;
    range 172.31.16.10 172.31.16.20;
  }
}
EOF'


# Script Cliente para acceder a internet
echo -n "INICIANDO EL SCRIPT..."
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F

    # POLITICA DE ACEPTAR
sleep 3
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

iptables -t nat -A POSTROUTING -s 10.0.0.0/16 -o enp0s8 -j MASQUERADE

    # ACTIVAR FORWARDING
echo -n "ACTIVANDO FORWARDING"

sleep 3
echo 1 > /proc/sys/net/ipv4/ip_forward
echo ""VERIFIQUE_LO QUE SE HA CONFIRMADO CON: iptables -L -n"

sudo systemctl restart networking
sudo systemctl restart isc-dhcp-server

echo "Configuracion completada"
