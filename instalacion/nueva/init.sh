export IP="172.31.11.249"

sed -e "s/\${IP}/$IP/g" apache/heartbeat/heartbeat.template.yml > apache/heartbeat/heartbeat.yml
sed -e "s/\${IP}/$IP/g" apache/docker-compose.template.yaml > apache/docker-compose.yml
sed -e "s/\${IP}/$IP/g" elastic-kibana/instances.template.yml > elastic-kibana/instances.yml
sed -e "s/\${IP}/$IP/g" logstash/pipelines/pipeline_heartbeat.template.conf > logstash/pipelines/pipeline_heartbeat.conf


# Arrancamos el cluster de Elastic y Kibana
cd elastic-kibana
./init.sh

echo "Cluster de elasticSearch arrancando"
echo "  Kibana estará disponible en https://localhost:8082"
echo "  Cerebro estarádisponible en http://localhost:8081"
echo "   Usuario: elastic"
echo "   Password: password"

# Arrancamos logstash
cd ../logstash
./init.sh

# Arrancamos Apache
cd ../apache
./init.sh

echo "Apache y monitorizadores arrancando"
echo "  Apache esta disponible en https://localhost:8080"

