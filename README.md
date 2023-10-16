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

## Configurar la IP del Cliente

1.- Ir a la configuracion de la máquina del Cliente y cambiar el Adaptador 1 a "Red interna" y Modo promiscuo a "Permitir todo"

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/9bc87e23-ac9b-4db4-82cf-13fdeb687c5c)

2.- Crear el siguiente script en el Servidor (con extesión .sh) para que el Cliente pueda acceder a Internet:

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/7292518d-b0a8-4c10-8718-9f1bbab4b7a9)

3.- Acceder al terminal de Cliente (Windows) y eliminar la ip y renovarla ejecutando los siguientes comandos:
- ipconfig /release --> Para eliminar
- ipconfig /renew --> Para renovar

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/8cd89d51-808b-438e-92b8-fa7d74b698e3)

4.- Hacer ping a *google* y al *servidor*:

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/4885b107-71f8-46fa-ab61-fc015e4fd61d)

## Configurar Failover

1.- Para configurar el Failover primero habrá que modificar el fichero /etc/dhcp/dhcpd.conf. 
- Añadiendo en "peer address" la IP que tendrá el servidor de *respaldo* y en "address" la IP del servidor *principal*.

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/a3a88f98-55b6-4cd2-822c-0a5a9ecfc25c)

2.- Reiniciar el servicio:
- systemctl restart isc-dhcp-service

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/8a91d715-e86d-46ae-8fe9-27ace35c7425)

3.- Una vez modificado el fichero en el Servidor, hay que clonarlo y modificar el mismo fichero pero esta vez en el servidor de *respaldo*.
- Pero ahora en el apartado "peer address" poner la IP del servidor principal y en "address" la del servidor del respaldo:

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/e6060dd4-ad62-4f95-9d84-46b3b3e77b22)

4.- Reiniciar el servicio:
- systemctl restart isc-dhcp-server

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/e9c0fde9-6f1b-448c-b13f-d3386bebfc26)

5.- Ahora hay que configurar la IP estática, modificando el ficher /etc/network/interfaces. Poner la misma IP asiganda anteriormente.
- Comentar las lineas de la otra tarjeta (enp0s8) para que no cree ningún tipo de conflicto, incluso desactivarlo desde la configuración de la máquina.

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/46abfa0a-9063-48f6-98f0-e6b20a510353)

6.- Reiniciar el servicio:
- systemctl restart networking
![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/d43eed1f-7222-4ccb-8506-e3e4b19163c5)

7.- Comprobar si hace ping entre servidores

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/6dba48ac-8c55-4c58-b4ab-56c9ea605dfb)

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/f70b2c24-a45c-423f-b54f-ceab72018409)

![image](https://github.com/DanielTenorioF/Dhcp/assets/114906968/392b7cf6-d3ed-460a-ad7c-7a17fab3d36e)

- [Paso a paso](pasoAPaso.md)
