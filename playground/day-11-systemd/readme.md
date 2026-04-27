# Day 11 — Systemd Notes
> Written by Pownkumar (Founder of Korelium ) · 27 April 2026

---

## How to Create a Custom Systemd Service (Step by Step)

### Step 1 — Write your script
Place it in `/usr/local/bin/`

```bash
sudo nano /usr/local/bin/your-script-name.sh
```

Add your script content, then make it executable:

```bash
sudo chmod +x /usr/local/bin/your-script-name.sh
```

> ⚠️ If you skip chmod +x → you get `status=203/EXEC` error. This is the most common mistake.

---

### Step 2 — Create the .service file
Place it in `/etc/systemd/system/`

```bash
sudo nano /etc/systemd/system/your-service-name.service
```

Paste this template:

```ini
[Unit]
Description=Your Service Description
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/your-script-name.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

> ⚠️ ExecStart path must EXACTLY match your script path. One typo = 203/EXEC error.

---

### Step 3 — Load and start

```bash
# Reload systemd so it picks up your new .service file
sudo systemctl daemon-reload

# Start the service
sudo systemctl start your-service-name.service

# Enable on boot
sudo systemctl enable your-service-name.service

# Check it's running
systemctl status your-service-name.service
```

---

### Step 4 — Watch logs

```bash
# Live logs from your service
journalctl -u your-service-name.service -f

# Live log file (if your script writes to one)
tail -f /var/log/your-log-file.log
```

> ⚠️ `cat -f` does NOT work. Always use `tail -f` for live log watching.

---

## Permission Errors Quick Reference

| Error | Cause | Fix |
|-------|-------|-----|
| `Permission denied` reading script | File not readable | `sudo cat filename` |
| `status=203/EXEC` | Script not executable | `sudo chmod +x /path/to/script.sh` |
| `Permission denied` on systemctl | Not using sudo | `sudo systemctl ...` |
| Log file not created | Script missing `>> $log` redirect | Add `>> /var/log/name.log` in script |
| Service keeps restarting | Script exits immediately or crashes | Check `journalctl -u servicename -f` |

---

## File Locations — Remember These

| What | Where |
|------|-------|
| Your scripts | `/usr/local/bin/` |
| Service unit files | `/etc/systemd/system/` |
| Log files (custom) | `/var/log/` |

---

## Key Commands — Cheat Sheet

```bash
sudo systemctl start name.service      # start
sudo systemctl stop name.service       # stop
sudo systemctl restart name.service    # restart
sudo systemctl enable name.service     # auto-start on boot
sudo systemctl disable name.service    # remove from boot
systemctl status name.service          # check status

sudo systemctl daemon-reload           # run this after editing .service file

journalctl -u name.service -f          # live logs
journalctl -u name.service -n 50       # last 50 lines
```

---

## What I Built Today

- **Script:** `/usr/local/bin/korelium-monitor.sh`
  - Logs CPU + memory every 60 seconds to `/var/log/korelium-monitor.log`
- **Service:** `/etc/systemd/system/korelium-moniter.service`
  - Runs on boot, restarts on failure
- **Debugged:** `203/EXEC` error caused by filename mismatch between service file and script

---

*Mistakes made → fixed → learned. That's the job.*
