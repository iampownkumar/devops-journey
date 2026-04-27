#!/bin/bash

#so this is the script that i wrote to practice the systemctl service creattions 
log=/var/log/korelium-moniter.log

while true; do
    echo "$(date) | CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')% | MEM: $(free -m | awk '/Mem/ {printf "%.0f%%", $3/$2*100}')" >> $log
    sleep 60
done
