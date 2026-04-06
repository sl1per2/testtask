#!/bin/bash
while true; do
  pgrep -x sshd >/dev/null 2>&1 || /usr/sbin/sshd >/dev/null 2>&1
  pgrep -f node_exporter >/dev/null 2>&1 || su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  pgrep -f grafana-server >/dev/null 2>&1 || /opt/grafana-8.3.0/bin/grafana-server -config=/etc/grafana/grafana.ini -homepath=/opt/grafana-8.3.0 &
  sleep30
done
