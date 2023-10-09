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

6.- Comprobamos los cambios realizados observando el fichero 

