# Instalación de Kong API Gateway Free Mode
La instalación realizada es mediante `Traditional mode`, el cual requiere de una base de datos externa.

## Instalar con Docker compose en entorno local
La instalación mediante docker compose en un entorno local, debe considerar y ejecutar los siguientes puntos.

### Requisitos:
* Docker desktop
* Postgresql 15
* Kong gateway 3.5

### Ejecutar el docker compose
Para ejecutar el archivo docker compose, debe dirigirse al directorio `kong-docker-compose` mediante el cli disponible en su entorno local.

* Ejecutar el siguiente comando:
* `docker compose up -d`

## Desplegar la API a Kong Gateway mediante Deck



## Desplegar la API a Kong Konnect con un gateway local

Ejecutar el comando para hacer ping con deck

`deck ping --konnect-addr https://us.api.konghq.com/--konnect-token kpat_SO3J8PLh63H0qDNAvx3J4aWQ1w7lvlCplgeto5u2e0PfnX04A --konnect-control-plane-name local-docker-desktop`