# Que necesitamos montar para tener una infraestructura de monitorización con ELK:

## Cluster con Elastic y Kibana
    - ElasticSearch
        2 Nodos maestros <<< Cluster Activo - Pasivo
            v 1 Nodo con capacidad de voto
        2 Nodos de datos < Al menos 2 >> Alta disponibilidad de los datos
        * Ingesta <<< Preprocesamiento de la información que cargo en ElasticSearch
        * Coordinadores <<< Es a traves del nodo desde el que hacemos consultas
        
        Activar usuarios y https            
        
    - Kibana
    (- Cerebro)

## Apache

## Recolectores de datos

### Heartbeat
### Filebeat
### MetricBeat

## Preprocesador y proxy de los datos

### Logstash


Toda esta infra la vamos a tener en Kubernetes o Openshift
Quiero un cluster de logstash. Para que? HA
    Necesito un cluster en Kubernetes para tener HA?
        Pod -> Contenedor Logstash
        Si se cae el Pod de Logstash.... puedo configurar Kubernetes para que cree uno nuevo
            Que problema tendría esto?
                Qué pasa miestras se cae y se levanta?

El cluster lo que te va a dar es persistencia de una cola

Filebeat        >>>
COMO ES EL RITMO DE PRODUCCION DE MENSAJES => Variable
------------
MetricBeat      >>>     Logstash        >>>>    Kafka    >>>>       ElasticSearch
                >>>     Logstash        >>>>
                        pipeline_metricbeat
MetricBeat
MetricBeat

HeartBeat       >>>     
                        pipeline_heartbeat


HeartBeat       >>>     Logstash        >>>>   
COMO ES EL RITMO DE PRODUCCION DE MENSAJES => Constante

Como voy a hacer llegar el pipeline a logstash?
    ConfigMap
    
-----
Como se están mandando los datos de un sitio a otro? PROTOCOLO RED/HTTP
Me fio? del caserio? Habria que securizarlos . Minimo HTTPS.... Quien hace eso?
    Securizo el destino (en el destino monto certificado... para que sirva por HTTPS)
Que pasa con la autenticacion?
Dejo que cualquiera me mande datos?
Me vale Securizo el destino ? NO
Me tengo que ir a ? mutualTLS
-----
ISTIO < ServiceMesh