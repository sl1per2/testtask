#!/bin/bash
while true; do
   pgrep -x sshd >/dev/null 2>&1 || /usr/sbin/sshd >/dev/null 2>&1
   pgrep -f "./backend" >/dev/null 2>&1 || su - contuser -c "cd /app && nohup ./backend > /dev/null 2>&1 &"
   pgrep -f node_exporter >/dev/null 2>&1 || su - contuser -c "nohup /usr/local/bin/node_exporter --web.listen-address=:9100 > /dev/null 2>&1 &"
   sleep 30
done
