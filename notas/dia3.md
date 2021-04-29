MetricBeat >>>>      Logstash   >>> ES Nodo1, Nodo2, Nodo3     <<<<<  Kibana
FileBeat   >>>>      Kafka


Logs
172.20.0.1 - - [28/Apr/2021:07:14:50 +0000] "GET / HTTP/1.1" 304 - "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36"

Filebeat Linea >>> JSON
{
    "timestamp","28/Apr/2021:07:14:50 +0000", # En el que se ha leido la linea
    "server": "IP|NOMBRE",
    "fichero": "ruta",
    "linea"," "
---
    "numero_linea",
    "IP", "172.20.0.1"
    "timestamp","28/Apr/2021:07:14:50 +0000"
    
}

Weblogic
    ---> Fichero log ..... Crecen hasta el infinito.... problemas de espacio en disco
        Rotar los logs. Cada fichero le voy a dar un tamaño X
            LOG A 
            LOG B 
    
    
    
ElasticSearch
    Indices





MetricBeat
Filebeat
Heartbeat                        Logstash            ES      Kibana

HEARTBEAT para monitorizar un puerto de un host