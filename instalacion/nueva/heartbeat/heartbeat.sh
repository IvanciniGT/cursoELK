if [[ "$1" == "setup" ]]; then
    docker run \
        --volume="$(pwd)/heartbeat.yml:/usr/share/heartbeat/heartbeat.yml:ro" \
        docker.elastic.co/beats/heartbeat:7.12.1 \
        setup -E setup.kibana.host=172.31.11.249:8082 \
        -E output.elasticsearch.hosts=["172.31.11.249:8080"]
fi

docker run --rm \
  --name=heartbeat \
  --user=heartbeat \
  --volume="$(pwd)/heartbeat.yml:/usr/share/heartbeat/heartbeat.yml:ro" \
  docker.elastic.co/beats/heartbeat:7.12.1 \
  --strict.perms=false
  