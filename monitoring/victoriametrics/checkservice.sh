#!/bin/bash
while true; do
  pgrep -x sshd >/dev/null 2>&1 || /usr/sbin/sshd >/dev/null 2>&1
  pgrep -f victoria-metrics-prod >/dev/null 2>&1 || su - contuser -c "nohup /usr/local/bin/victoria-metrics-prod -storageDataPath=/var/lib/victoriametrics -httpListenAddr=:8428 -retentionPeriod=30d -promscrape.config=/etc/victoriametrics/promscrape.yml > /dev/null 2>&1 &"
  pgrep -f node_exporter >/dev/null 2>&1 || su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  sleep 30
done
