# Que es un contenedor?
Es un entorno aislado dentro de una máquina con SO Linux donde ejecutar uno o varios procesos, de tal forma que:
    - Podemos restringir el uso de los recursos por parte de los procesos
    - Aumentar la seguridad
Es una forma de instalar aplicaciones, alternativa a las máquinas virtuales (más ligeros que una MV)
Un contenedor se crea desde lo que llamamos una IMAGEN de contenedor.

# Qué es una imagen de contenedor?
No es sino un fichero ZIP que contiene una aplicación ya instalada y configurada lista para su ejecución.
Además, va acompañado (ese zip) de una configuración:
    - Que puertos usa
    - Que procesos son los que se tienen que ejecutar 


# Instalación de ELK
## Preparativos
1. Docker
2. Docker-compose
    $ sudo apt-get  install docker-compose
    $ sudo apt  install docker-compose -y
    $ sudo yum install docker-compose
        
        # Contenedor vs Maquinas Virtuales
        MV tiene su propio SO
        Un contenedor usa el kernel del SO que hay abajo <<<< Son más ligeros
        
        # Una cosita que sale cuando instalamos ElasticSearch dentro de un Contenedor, es que necesito hacer 
        algunos cambios en el SO que hay por debajo...
3. Desactivar swapping
    $ sudo swapoff -a    # aqui solo desactivamos el swap en la ejecución actual del SO
    $ sudo vim /etc/fstab # comentar la swap para que al reiniciar siga desactivada
4.  Como superusuario: Aumentar memoria virtual y numero máximo de archivos abiertos.
    $ sudo su -
    $ ulimit -n 65535
    $ sysctl -w vm.max_map_count=262144
    $ echo "vm.max_map_count=262144" >> /etc/sysctl.conf


## Instalar ElasticSearch + Kibana
Construir un fichero YAML con la definición de los contenedores