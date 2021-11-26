echo "For practicity you can execute this ones."
echo "If you executed more than once, errors will appear and the maybe fix by commenting some lines in the script"
echo "Creating network"
podman network create mon-net 
echo "Creating monitoring pod"
podman pod create --name=monitoring 

#echo "Creating cadvisor"
#podman run --name=monitoring_cadvisor_1 -it -d -p 8080:8080 --pod=monitoring --net mon-net  --mount type=bind,source=/,destination=/rootfs,ro --mount type=bind,source=/var/run,destination=/var/run,ro --mount type=bind,source=/sys,destination=/sys,ro --mount type=bind,source=/var/lib/docker/,destination=/var/lib/docker,ro --mount type=bind,source=/dev/disk,destination=/dev/disk,ro gcr.io/cadvisor/cadvisor 
echo "Creating redis"
podman run --name=monitoring_redis_1 -it -d -p 6379:6379 --pod=monitoring --net mon-net redis:latest
echo "Creating prometheus"
podman run --name=monitoring_prometheus_1 -it -d -p 9090:9090 --pod=monitoring --net mon-net --mount type=bind,source=/f/dev/Profiler/monitoring/./prometheus.yml,destination=/etc/prometheus/prometheus.yml,ro prom/prometheus:latest --config.file=/etc/prometheus/prometheus.yml
echo "Creating grafana"
podman run --name=monitoring_grafana_1 -it -d -p 3000:3000 --pod=monitoring --net mon-net grafana/grafana 