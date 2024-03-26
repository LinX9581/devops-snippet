mkdir /process-exporter
cat>/process-exporter/config.yml<<EOF
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
docker run -itd -p 9256:9256 --privileged --name=process-exporter -v /proc:/host/proc -v /process-exporter/:/config ncabatoff/process-exporter --procfs /host/proc -config.path config/config.yml path config/config.yml


docker run -d -p 9100:9100 \
-v "/proc:/host/proc" \
-v "/sys:/host/sys" \
-v "/:/rootfs" \
--name=gra_node-exporter \
prom/node-exporter \
--path.procfs /host/proc \
--path.sysfs /host/sys \
--collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"