# Stack ELK
La empresa Elastic ofrece entre sus productos:
El stack ELK:
    - ElasticSearch 
    - Logstash 
    - Kibana

## ElasticSearch
Un indexador, es decir, una herramienta donde indexamos información.
Indexar es el procedimiento mediante el cual se genera un índice.
Qué permite un índice? Realizar bñusqueda rápidas sobre información.

Qué indexador conoceis que usais a diario: GOOGLE

Un indexador a priori guarda la información que queremos indexar?
No necesariamente. Lo que guarda en un índice.

INFORMACION > El servidor ha producido un error: El fichero /tmp/registro.log no está disponible.
(guardada en un fichero de log... por ahí)

INDICE DE UN LIBRO
disponible
error    .....
fichero  .....
produci  .....
servidor ............ La segunda palabra dentro de la linea 327 del fichero serv1.prod.log en la máquina 192.168.11.23
/tmp/registro.log

^^^ Términos

## Datos relativos a monitorización
Tienen varias características:
- Muchas veces no están estandarizados
    - Datos estandarizado:  
        - Log apache
            - Timestamp
            - IP
            - Código respuesta HTTP
            - Bytes transmitidos
            - URL
        - CPU usada en una máquina: 17%
    - Datos no estandarizado:  
        - Log de una app propia: Requiere de búsquedas FULL-TEXT
- Una vez producido un evento, ese evento queda congelado... ya no va a cambiar.  =>> 
    - Puede que cambie lo que generó el evento
    - Si guardo una copia del dato original en ELASTICSEARCH (similar a la cache de google), 
      tengo confianza en que el dato no va a acambiar a lo largo del tiempo.
    - ElasticSearch, si es capaz de guardar esa foto del dato... se convierte no solo en un indexador,
      sino también en una base de datos.
- Siempre tienen asociado un timestamp: Cuando se ha generado o captura la métrica

## Por qué se usa elasticsearch para monitorizar sistemas?
- Por sus capacidades de almacenar información no estructurada que no cambie
- Por sus capacidades de indexar / buscar información no estructurada
- Por las herramientas que lo acompañan:
    - Kibana: Permite hacer una explotación grande de los datos que hemos almacenado:
        - Monitorización en tiempo real de los eventos
        - Generar dashboards(cuadros de mando), con indicadores (métricas) (información agregada)
        - Alertas: Cuando se producen eventos
        - Formulario de búsqueda tipo GOOGLE
        - Canvas... parecido a los dashboards. Tienen un alto grado de diseño gráfico:
            - Publicaciones automatizadas
            - Pantalla para publicar en una tele, en lo alto de la sala
        * Machine learning: Predecir cuando se va a producir un error en un sistema.
        * Data mining: Analizar datos, para identifcar patrones en ellos que a priori no serian detectables.
            - Segmentación de datos
- Beats: Agentes ligeros (miniprogramitas) que recopilan información (eventos) <<<<<<
    - MetricBeat  -> Estadísticas de hardware
    - FileBeat    -> Leer ficheros de log
    - HeartBeat   -> Monitorizar servicios <<<< Informes de HA
    - WinlogBeat  -> Monitorizar el registro de Windows
    - AuditBeat   -> Monitorizar el registro de Linux
- Logstash <<<< Tiene su hueco... pero más importantes / útiles son los beats
- Hay una cantidad de plantillas de monitorización enorme:
    - Quiero monitorizar una base de datos PostgreSQL
    - Quiero monitorizar los ficheros de los de apache
    - Quiero monitorizar los ficheros de los de nginx

### Machine learning
Cuanto cuesta un piso en barna (gracia) de 100m2? 
    - 1M€
Cuanto cuesta un piso en Manresa (Alcalá de Henares) de 100m2? 
    - 200000€
Basándome en datos que he leido (escuchado, mirado) previamente... extraigo conclusiones

PC DPM: 1000
PC usuario básico: 500
Servidorcito: 3000-4000 

# Alternativas ElasticSearch/Kibana
Influx(prometheus) --- ElasticSearch
Grafana            --- Kibana

# A la hora de integrar Beats con ElasticSearch... van a salir algunas peculiaridades.
Beats     >> datos >>     ElasticSearch   <<<<   Kibana
 VV                                                ^^   
  >>>>>>>>>>> create un dashboard adecuado >>>>>>>>>
  
La cuestión es que vamos a recopilar eventos que se van produciendo.
Por un lado, cuando se produce una evento, lo necesito registrar.
Por otro lado, ese evento registrado(medido) necesito mandarlo posteriormente a un sistema de almacenamiento.
                                                                                        ^^^^^^^^
                            BEATS                       BEATS                         ElasticSearch
                            Loggers                     Fluentd
                            
Logger >>> Generar un log de una app (nginx)     >>>>   Fluentd(filebeat, logstash)  >>> ElasticSearch
MetricBeat  >>> Tomando méticas en tiempo real y mandarlas      >>>>>>>                  ElasticSearch

El problema que tenemos es que esa información debe llegar a ElasticSearch.
Si no llega a que puede ser debido?
- Puedo tener un fallo en la comunicación: 
    - Que se caiga ES
    - Que se caiga uno de los beats
        - Que tenga un beats para registrar y mandar los datos.
            - Si se cae el beat... pierdo datos... irrecuperables
        - Que tenga un programa externo registrando los datos (logger) y un beats para mandarlos.
            - Si se cae el beat... a posteriori puedo reeler el fichero de log y mandar los eventos.
            - Se me pueden acumular demasiados datos para mandar...
                - Que llene un disco un duro > rotar el fichero de log entre 2 ficheros
                    - Fichero 1 y Fichero2 tienen 2Mbs de tamaño

Quien me puede ayudar a resolver estos problemas?
- CONTENEDORES < Gestor de contenedores encima, monitorizando que los contenedores están en marcha... Si no,
                 el gestor de contenedores, va a reemplazarlo. Por ejemplo: Kubernetes, Openshift, Docker, Podman
- Si se cae un elastic... necesito tener un sitio donde ir almacenando temporalmente los eventos, hasta que ES vuelva a la vida.
    - KAFKA


# Los beats crean índices en autoático dentro de ElasticSearch para guardar los documentos (eventos) que recopilan
Que configuración importante tenemos en un índice dentro de ES?
- Número de shards primarios (Que me aportan? Más capacidad de computo indexación / busqueda)
- Número de replicas. Son copias que hacemos de los shards primarios... que deben estar continuamente actualizadas
                      Lo que se hace al indexar UN DOCUMENTO es incluirlo en todas y cada una de las copias de el fragmento
                      Que me aportan? 
                        - Alta disponibilidad de la información: REDUNDANCIA DE DATOS
                        - Me aceleran las búsquedas... porque tengo más sitios en donde buscar
                        - Me aceleran las cargas? NO 



# Dentro de ElasticSearch, los documentos se guardan en Indices (como si fuera una tabla en una BBDD relacional)
Shard? Una partición de índice 



Indice de las metricas de los servidores:
    Particion 1 - Shard primario
    Particion 2 - Shard primario
Qué me aportan las particiones? 
    Tener más recursos para realizar los trabajos de carga / búsqueda
    Cada shard o particion primaria es un proceso dentro del servidor, que se encarga de indexar/buscar independiente
    

Monitorizar estadísticas de máquinas
    Vamos a tener más trabajo de carga o de búsqueda?     CARGA
    Que es más pesado a priori... la carga o la búsqueda? Buscarlos RUINA !!!! NI DE COÑA
    ¿Cual es la misión de un indexador? Hacer que la búsqueda sea más rápida, 
                                        a costa de hacer una carga mucho más lenta.
                                        
                                        
"El servidor ha producido un error: El fichero /tmp/registro.log no está disponible."
Carga en una BBDD?
INSERT INTO TABLA_DOCUMENTO VALUES("El servidor ha producido un error: El fichero /tmp/registro.log no está disponible.");
Añade ese texto al final de un fichero.