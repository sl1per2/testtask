#!/bin/bash

while true; do
  docker exec lb1 pgrep sshd >/dev/null 2>&1 || docker exec lb1 /usr/sbin/sshd 2>/dev/null
  docker exec lb2 pgrep sshd >/dev/null 2>&1 || docker exec lb2 /usr/sbin/sshd 2>/dev/null
  docker exec backend1 pgrep sshd >/dev/null 2>&1 || docker exec backend1 /usr/sbin/sshd 2>/dev/null
  docker exec backend2 pgrep sshd >/dev/null 2>&1 || docker exec backend2 /usr/sbin/sshd 2>/dev/null
  docker exec victoriametrics pgrep sshd >/dev/null 2>&1 || docker exec victoriametrics /usr/sbin/sshd 2>/dev/null
  docker exec grafana pgrep sshd >/dev/null 2>&1 || docker exec grafana /usr/sbin/sshd 2>/dev/null

  docker exec lb1 pgrep -x haproxy >/dev/null 2>&1 || docker exec lb1 su - contuser -c "/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg"
  docker exec lb2 pgrep -x haproxy >/dev/null 2>&1 || docker exec lb2 su - contuser -c "/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg"

  docker exec lb1 pgrep -x keepalived >/dev/null 2>&1 || docker exec lb1 /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf -n -l &
  docker exec lb2 pgrep -x keepalived >/dev/null 2>&1 || docker exec lb2 /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf -n -l &

  docker exec backend1 pgrep -f "./backend" >/dev/null 2>&1 || docker exec backend1 su - contuser -c "cd /app && nohup ./backend > /dev/null 2>&1 &"
  docker exec backend2 pgrep -f "./backend" >/dev/null 2>&1 || docker exec backend2 su - contuser -c "cd /app && nohup ./backend > /dev/null 2>&1 &"

  docker exec lb1 pgrep -f node_exporter >/dev/null 2>&1 || docker exec lb1 su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  docker exec lb2 pgrep -f node_exporter >/dev/null 2>&1 || docker exec lb2 su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  docker exec backend1 pgrep -f node_exporter >/dev/null 2>&1 || docker exec backend1 su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  docker exec backend2 pgrep -f node_exporter >/dev/null 2>&1 || docker exec backend2 su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  docker exec victoriametrics pgrep -f node_exporter >/dev/null 2>&1 || docker exec victoriametrics su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  docker exec grafana pgrep -f node_exporter >/dev/null 2>&1 || docker exec grafana su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"

  docker exec lb1 pgrep -f exporter_ka >/dev/null 2>&1 || docker exec lb1 su - contuser -c "nohup /usr/local/bin/exporter_ka.sh > /dev/null 2>&1 &"
  docker exec lb2 pgrep -f exporter_ka >/dev/null 2>&1 || docker exec lb2 su - contuser -c "nohup /usr/local/bin/exporter_ka.sh > /dev/null 2>&1 &"

  docker exec victoriametrics pgrep -f victoria-metrics-prod >/dev/null 2>&1 || docker exec victoriametrics su - contuser -c "nohup /usr/local/bin/victoria-metrics-prod -storageDataPath=/var/lib/victoriametrics -httpListenAddr=:8428 -retentionPeriod=30d -promscrape.config=/etc/victoriametrics/promscrape.yml > /dev/null 2>&1 &"

  docker exec grafana pgrep -f grafana-server >/dev/null 2>&1 || docker exec grafana /opt/grafana-8.3.0/bin/grafana-server -config=/etc/grafana/grafana.ini -homepath=/opt/grafana-8.3.0 &

  sleep 30
done
