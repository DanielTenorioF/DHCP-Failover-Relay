#!/bin/bash

apt update
apt upgrade -y

apt install isc-dhcp-server -y
apt install iptables -y

systemctl disable NetworkManager
systemctl stop NetworkManager

sudo sed -i '/^INTERFACESv4=/s/"\([^"]*\)"/"\1enp0s3"/' /etc/default/isc-dhcp-server

#cat <<EOF >>/etc/dhcp/dhcpd.conf
#subnet 10.0.0.0 netmask 255.255.0.0 {
#  range 10.0.2.26 10.0.2.30;
#  option domain-name-servers 8.8.8.8,8.8.8.4;
#  option domain-name "internal.example.org";
#  option routers 10.0.2.5;
#  option broadcast-address 10.0.255.255;
#  default-lease-time 600;
#  max-lease-time 7200;
#}
#EOF

# PRUEBA

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
  address 10.0.2.5;
  port 647;
  peer address 10.0.2.55;
  peer port 647;
  max-unacked-updates 10;
  max-response-delay 30;
  load balance max seconds 3;
  mclt 1800;
  split 128;
}

subnet 10.0.0.0 netmask 255.255.0.0 {
  option broadcast-address 10.0.255.255;
  option routers 10.0.2.1;
  option domain-name-servers 8.8.8.8, 8.8.4.4;
  pool {
    failover peer "FAILOVER";
    max-lease-time 3600;
    range 10.0.2.26 10.0.2.30;
  }
}
EOF'


#cat <<EOF >> /etc/network/interfaces
# Configuracion red estatica enp0s8
#auto enp0s8
#iface enp0s8 inet static
#address 172.26.2.50
#network 172.26.0.0
#netmask 255.255.0.0
#gateway 172.26.0.1

# Configuracion red estatica enp0s3
#auto enp0s3
#iface enp0s3 inet static
#address 10.0.2.5
#network 10.0.0.0
#netmask 255.255.0.0
#EOF


# PRUEBA

sudo bash -c 'cat << EOF > /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto enp0s3
iface enp0s3 inet static
        address 10.0.2.5
        netmask 255.255.0.0
        network 10.0.0.0
        broadcast 10.0.255.255

auto enp0s8
iface enp0s8 inet dhcp
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
