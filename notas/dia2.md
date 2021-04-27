# Instalación de metricbeat

## Instalar sobre el propio hierro

Descargar el paquete metricbeat:
    curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.12.0-amd64.deb

Instalar metric beat
    sudo dpkg -i metricbeat-7.12.0-amd64.deb

No es muy adecuado.. porque?
Si se cae el servicio... no tiene capacidad de reiniciarse
No se está ejecutando en un entorno aislado (el metricbeat)

## Instalar dentro de un contenedor
### Docker vs Kubernetes

Las dos herramientas permiten trabajar con contenedores.

Un contenedor es una forma de ejecutar un proceso (o varios) de forma aislada dentro de una máquina LINUX

                            ENTORNO LOCAL                        UN CLUSTER DE MAQUINAS
                        -----------------------------       --------------------------------        
Lo puedo conseguir con ContainerD-Crio < DOCKER-Podman |||| Docker swarm-KUBERNETES-Openshift

Que aporta un cluster? que aportan Kubernetes y Openshift frente a Docker-podman?
    - Alta Disponibilidad: HA
    - Escalabilidad
    (son caracteristicas propias de un entorno de producción)
    
MetricBeat en Docker vs KUBERNETES?
Depende: Qué quiero monitorizar?
    - Quiero monitorizar el cluster?
    - Quiero monitorizar unas máquinas de unos usuarios?
        - Quiero ver si una maquina de un usuario no se llena el FS
        - Que pasa si tengo un cluster de Weblogics, que no está montado en Kubernetes?
          10 servidores de aplciaciones que son maquinas que forman un cluster, pero no están gestionadas por kubernetes
        
    
HOST    
Procesos en ejecución          MetricBeat (contenedor)


# Para ejecutar metricbeat como un contenedor

Esto haría el setup
docker run --rm \
    docker.elastic.co/beats/metricbeat:7.12.0 \
    setup -E setup.kibana.host=172.31.11.249:8082 \
    -E output.elasticsearch.hosts=["172.31.11.249:8080"] 
    

HOST: 127.0.0.1   |   172.31.11.249    |    172.17.0.1     |    172.18.0.1 
    C. nodo1    172.18.0.2
    C. nodo2    172.18.0.3
    C. nodo3    172.18.0.4
    C. kibana   172.18.0.5
    C. cerebro  172.18.0.6
    
    C. metricbeat 172.17.0.2


docker run =
    docker pull             <<<< descargar una imagen
    docker container create <<<< crear un contenedor
    docker start            <<<< arrancar el contenedor
    docker attach           <<<< mostrar el log por consola
    docker rm               <<<< tras ejecutar el contenedor, borralo
    
    
    
# Instalaciónde apache con un contenedor docker
docker run -d --name mi-apache -p 8081:80 httpd



Host
    Contenedor con Apache 
        /usr/local/apache2/logs/access_log
    
    
Voy a usar Filebeat para mandar ese fichero a ES
Instalar filebeat:
    - A pelo en el hierro
    - Via un contenedor