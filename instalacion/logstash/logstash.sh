docker run --rm -it \
    -v /home/ubuntu/environment/curso/instalacion/logstash/pipeline_logfile.conf:/usr/share/logstash/pipeline/logstash.conf \
    -v /home/ubuntu/environment/datos/access_log:/tmp/access_log \
    docker.elastic.co/logstash/logstash:7.12.1
