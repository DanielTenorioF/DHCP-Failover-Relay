# Posible Tarea 1

## Instalar DHCP en Debian12
1.- Acceder a la configuracion d ela maquina servidor y el apartado "Red", cambiar el Adaptador 1 a "Red interna" y el Adaptador 2 a "Adaptador punte"
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/87407add-fcee-465e-ac67-05e993524986)
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/ec1932c8-7c97-472c-8609-4b37903b4e86)


2.- Actualizar la lista de paquetes e instalar el paquete isc-dhcp-server y iptables
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/1c2efd71-7d7b-404b-b199-f4c915f00698)


3.- Modificamos con nano el fichero /etc/default/isc-dhcp-server añadiendo "enp0s3":
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/c75d5e3d-06a9-4c48-877d-9737f449cb7e)


4.- Configurar la red dinámica modificando el fichero /etc/dhcp/dhcpd.conf:
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/f85e9adc-230e-49f8-a122-4824afc3e65e)


5.- Reiniciar el Servicio dhcp:
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/99183a4f-ffaf-4e4d-8f85-772fe3bf562f)


6.- Comprobamos los cambios realizados observando, con el comando *cat*, el fichero /etc/var/lib/dhcp/dhcpd.leases y ejecutando el comando *journalctl -f*:
- cat /etc/var/lib/dhcp/dhcpd.leases
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/4ef666ad-c1b2-469a-b9b4-8264b32b14a9)

- journalctl -f
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/ab00ade8-2315-489c-82ae-58d6e515bfe3)

7.- Deshabilitar y parar el servicio NetworkManager para poder configurar la red estática:
- systemctl disable NetworlManager
- systemctl stop NetworkManager
Comprobar: systemctl status NetworkManager
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/b39c928d-39f4-47ae-8db0-7365a4f9f2c6)


8.- Configurar IP fija de enp0s3 y enp0s8, modificando el fichero /etc/network/interfaces:
- nano /etc/network/interfaces
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/2c6d73db-db5d-4fc8-ad84-802784e73927)

9.- Reiniciar el servicio:
- systemctl restart networking
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/25201343-3861-41f4-80b7-df35eb71b0b1)



