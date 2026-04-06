#!/bin/bash
while true; do
  pgrep -x sshd > /dev/null 2>&1 || /usr/sbin/sshd >/dev/null 2>&1
  pgrep -x haproxy > /dev/null 2>&1 || su - contuser -c "/usr/sbin/haproxy -f /etc/haproxy/haproxy.cfg"
  pgrep -x keepalived > /dev/null 2>&1 || /usr/sbin/keepalived -f /etc/keepalived/keepalived.conf -n -l &
  pgrep -f node_exporter > /dev/null 2>&1 ||  su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
  pgrep -f exporter_ka >/dev/null 2>&1 || su - contuser -c "nohup /usr/local/bin/exporter_ka.sh > /dev/null 2>&1 &"
  sleep 30
done
