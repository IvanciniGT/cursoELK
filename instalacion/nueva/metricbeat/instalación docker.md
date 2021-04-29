
#################################################################    

docker run --rm \
    docker.elastic.co/beats/metricbeat:7.12.0 \
    setup -E setup.kibana.host=172.31.11.249:8082 \
    -E output.elasticsearch.hosts=["172.31.11.249:8080"] 

Crear un contenedor para:
    Kibana: Crea los dashboards
    ElasticSearch: Configurar los indices
Borra el contenedor

Esto necesito ejecutarlo una única vez

################################################################    

Crear un contenedor para:
    Ejecutar un metric beat que:
        - Recopilar las metricas
        - Enviarlas a ElasticSearch
Este no lo borro nunca... que siga hasta el infinito y más allá

Esto necesito ejecutarlo dentro de la(s) maquina(s) que quiera monitorizar

################################################################    

Necesito dotar al contenedor de un fichero de configuración:
wget https://raw.githubusercontent.com/elastic/beats/7.12/deploy/docker/metricbeat.docker.yml


docker run -d \
  --name=metricbeat \
  --user=root \
  --restart unless-stopped \
  --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  docker.elastic.co/beats/metricbeat:7.12.0 metricbeat -e \
  -E output.elasticsearch.hosts=["172.31.11.249:8080","172.31.11.250:8080"]  
  
  
docker update --restart unless-stopped metricbeat


HOST                
 C-MetricBeat                               ----->  Cluster. ElasticSearch  ------- Kibana
 Fluentd (lee unos fichero)     ----------------->
 C-Filebeat(lee unos fichero)   ----------------->
 
Cluster Kunernetes
    Nodo 1
     C-MetricBeat  ---------------------------------->  Logstash   ------>    Cluster. ElasticSearch  ------- Kibana
     C-Filebeat(lee unos fichero)   ----------------->
    Nodo 2
     C-MetricBeat  ---------------------------------->  Kafka      ------>    Cluster. ElasticSearch  ------- Kibana
     C-Filebeat(lee unos fichero)   ----------------->
    Nodo 3
     C-MetricBeat  ---------------------------------->  Logstash   ------>    Cluster. ElasticSearch  ------- Kibana
     C-Filebeat(lee unos fichero)   ----------------->
                                                        ^^^^^  Proxy
Si tengo un cluster de Kubernetes no lo haría así.

Si tengo un cluster de weblogics a pelo sobre Hierro.

Que pasa si....
    1. Elastic no está en funcionamiento. UPPPPSSSS
    2. Que pasa si cambio el cluster de elastic a otro sitio? Tengo que cambiar los datos de configuración donde? EN TODOS LOS SITIOS DEL MUNDO 
        IP, usuario, contraseña, certificados
    3. Que pasa si quiero mandar los datos de monitorización a otro sitio adicional?
    

Tendría un logstash  |
Tendría un kafka     | Centralizar todas las metricas recopiladas + preprocesamiento de la información
    En cluster (en un kubernetes)
    
    
    

App1 - Weblogic
    Fichero de log (IPs) --- Filebeat ----> (enriquece las IPs con geo-posicionamiento o quita 16 datos que me llegan del log que nos los quiero) ES
App2 - Metricas de Hardware
    Fichero de log (IPs) --- Filebeat ----> (Filtrar unos campos..) ES

App1 - Weblogic
    Fichero de log (IPs) --- Filebeat ----> Logstash: enriquece las IPs con geo-posicionamiento o quita 16 datos que me llegan del log que nos los quiero ----> ES
App2 - Weblogic
    Fichero de log (IPs) --- Filebeat ----> Logstash: enriquece las IPs con geo-posicionamiento o quita 16 datos que me llegan del log que nos los quiero ----> ES
    
                                            Kafka (colas con persistencia)  No pierdo datos si se cae el ELASTICSEARCH 

A nivel de CPU global me sale lo mismo



Scrapper -----> Logstash                ------> ES
Scrapper -----> Kafka                   ------> 
Scrapper -----> Logstash ------> Kafka  ------> ES
                         ------> ES



App 
200 logs/seg   ---------------> Fluentd -----------------> ES   ( 1 indice ) ----> Cuantos data? 2
UUUUh!!!!!


Objetivos que qieres conseguir?
- Que no se colapse el ES poque procesa muchos datos....
    - Más capacidad de procesamiento > + shards primarios > + nodos ES.  PASTA !!!!
    - Menos datos a procesar > Meter un cuello de botella previo.        DEMORA DE TIEMPO !!!!



Cluster de ES
10 indices y 15 nodos

Cuantos shards primarios quiero por indice: 15
Esta guay en la carga..... que pasa en la consulta? La busqueda puede verse seriamente afectada <<<<<


Estanteria: ElasticSearch

Documentos: Hojas de papel

Archivadores: Shards

Los archivadores los tengo de colores. Cada color es un Indice

------------
Estanteria que es mi elasticsearch
    Los archivadores Azules: Facturas                5 archivadores
    Los archivadores Rojos: Contratos                10 archivadores
    Los archivadores Verdes: Reclamaciones           1  archivador
Cada archivador lleva asociado una persona para su gestión <<< Proceso "Lucene"Puedo llegar a abrir en la práctica los que permitan los recursos hardware de mi maquina
***** Tamaño de la estantería: Disco duro
***** Mesa donde poder ir abriendo los archivadores: Memoria RAM/CPU

Me llegan las facturas 7 facturas por minuto. Cuantos personas/archivador me interesa tener guardando simultaneamente 
    facturas si cada persona tarda 1 minuto en guardar 1 factura ? 7

Me llegan las reclamaciones 1 por minuto. Cuantos necesito tener con reclamaciones? 1.... 

Quiero hacer busquedas de reclamaciones:
    - Quiero buscar la reclamacion 17. Y a lez me piden la 28 y a la vez la 32 
    - Quiero buscar las reclamacion de enero
Quiero hacer busquedas de facturas:
    - Quiero buscar la facturas 17. Y a lez me piden la 28 y a la vez la 32 
    - Quiero buscar las facturas de enero: Va a implicar que cada tio busca las suiyas de enero... pero las tengo que juntar todas: ORDENACION

¿Cual es la tarea de los "tios"? GEstionar UN UNICO ARCHIVADOR DE SU PROPIEDAD QUE NO LO VAN A SLOTAR NI AUNQUE LES PEGUEN UN TIRO EN LA CABEZA









