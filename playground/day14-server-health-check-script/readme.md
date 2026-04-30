# 🖥️ Day 14 Mini Project — Server Health Monitor

> Built on 30 April 2026 as part of my DevOps learning journey.
> Created by Pownkumar A (Founder of Korelium)

---

## 📌 What I Built

A Bash script that monitors server CPU health, logs the result, and fires alerts when usage crosses a threshold. It runs automatically every hour using a **systemd timer** — the modern DevOps alternative to cron.

---

## 📁 Project Structure

```
day14-server-health-check-script/
├── health-moniter.sh        # main script
├── log/
│   ├── health-moniter.log   # full log of every check
│   └── health-alerts.log    # only alerts (threshold breaches)
└── systemd/
    ├── health-moniter.service  # systemd service unit
    └── health-moniter.timer    # systemd timer unit
```

---

## ⚙️ How It Works

### The Script — `health-moniter.sh`

Checks CPU usage every time it runs:

1. Reads idle CPU % from `top`
2. Calculates usage: `100 - idle`
3. Compares against threshold (default: 80%)
4. Logs result to `health-moniter.log`
5. If above threshold → also logs to `health-alerts.log`

**Configuration variables at the top of the script:**

```bash
cpu_threshold=80    # alert if CPU goes above this %
mem_threshold=80    # (for future use)
disk_threshold=80   # (for future use)
```

### The Service — `health-moniter.service`

Tells systemd what to run:

```ini
[Unit]
Description=Server Health Monitor
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/health-moniter.sh

[Install]
WantedBy=multi-user.target
```

`Type=oneshot` means: run the script once and exit. Perfect for a monitoring script.

### The Timer — `health-moniter.timer`

Tells systemd when to run it:

```ini
[Unit]
Description=Run health monitor every hour

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
```

`OnBootSec=5min` — runs 5 minutes after server boots
`OnUnitActiveSec=1h` — then repeats every hour

---

## 🚀 Setup & Installation

```bash
# 1. copy script to system path
sudo cp health-moniter.sh /usr/local/bin/health-moniter.sh
sudo chmod +x /usr/local/bin/health-moniter.sh

# 2. install systemd units
sudo cp systemd/health-moniter.service /etc/systemd/system/
sudo cp systemd/health-moniter.timer /etc/systemd/system/

# 3. enable and start
sudo systemctl daemon-reload
sudo systemctl enable health-moniter.timer
sudo systemctl start health-moniter.timer

# 4. verify
sudo systemctl status health-moniter.timer
```

---

## 📋 Example Output

```
--------------------cpu usage----------------------
current cpu usage: 5%  (threshold: 80%)
ok: cpu usage is normal: 5%
```

Real alert caught during testing (96% spike):

```
[2026-04-30 10:42:58] ALERT: high cpu usage: 96% (threshold: 80%)
```

---

## 📊 Cron vs Systemd Timer — Why I Chose Systemd

This was the biggest learning of Day 14. Both can schedule jobs — but they are very different.

| Feature | Cron | Systemd Timer |
|---|---|---|
| Setup | `crontab -e` | `.timer` file |
| Logs | scattered, hard to find | `journalctl -u health-moniter.service` |
| Missed jobs (server was off) | skipped forever | recoverable with `Persistent=true` |
| Dependencies | none | can wait for network, disk, other services |
| Error handling | silent failures | tracked by systemd, visible in status |
| Modern Linux | older approach | recommended way today |

The key insight: a `.timer` file and `.service` file with the same name are automatically paired by systemd. When the timer fires, systemd finds and runs the matching service. Clean, trackable, and professional.

To check logs anytime:

```bash
journalctl -u health-moniter.service
```

---

## 💡 What I Learned Today

- Writing a real-world Bash monitoring script from scratch
- Reading CPU metrics using `top` and parsing with `grep`, `awk`
- Logging and alerting patterns in shell scripts
- How systemd services work (`Type=oneshot`, `ExecStart`, `After=`)
- How systemd timers work and how they pair with services
- Why systemd timers are better than cron for production use
- Debugging awk column issues when `top` output format varies by system
- Using `grep -oP` with regex for reliable text parsing

---

## 🔜 What's Next

- Add memory check (`free -m`)
- Add disk check (`df -h`)
- Add service status check (`systemctl is-active`)
- Add email alerts
- Add `Persistent=true` to timer so missed runs are caught on reboot
