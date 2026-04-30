#!/bin/bash

# health-monitor script
# Created by : Pownkumar A (Founder of Korelium)
# Created Date: 30 April 2026 08:04 AM IST

cpu_threshold=80
mem_threshold=80
disk_threshold=80

log_file="/home/ubuntu/dev-workspace/devops-journey/playground/day14-server-health-check-script/log/health-moniter.log"
alert_log="/home/ubuntu/dev-workspace/devops-journey/playground/day14-server-health-check-script/log/health-alerts.log"

services=("nginx" "ssh" "cron") #services we are going to moniter

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

log() {
    echo "[$(timestamp)] $1" | tee -a "$log_file"
}

alert() {
    local message=$1
    echo "[$(timestamp)] ALERT: $message" | tee -a "$log_file" "$alert_log"
}

echo "--------------------cpu usage----------------------"

cpu_idle=$(top -bn1 | grep "Cpu(s)" | grep -oP '\d+\.\d+ id' | awk '{print $1}')
cpu_idle=${cpu_idle%.*}
cpu_usage=$((100 - cpu_idle))

echo "current cpu usage: ${cpu_usage}%  (threshold: ${cpu_threshold}%)"

if (( cpu_usage >= cpu_threshold )); then
    alert "high cpu usage: ${cpu_usage}% (threshold: ${cpu_threshold}%)"
    echo "ALERT: cpu usage is high: ${cpu_usage}%"
else
    log "ok: cpu usage is normal: ${cpu_usage}%"
    echo "ok: cpu usage is normal: ${cpu_usage}%"
fi
