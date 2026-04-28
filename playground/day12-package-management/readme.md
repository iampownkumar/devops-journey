# Day 12 — Package Management Deep Dive
> Written by Pownkumar (Founder of Korelium ) · 28 April 2026
> Practiced on a **live AWS EC2 instance** (Ubuntu 22.04)

---

## What I Understood Today

Package management is how Ubuntu installs, updates, and removes software.

Before today I was just running `sudo apt install` without knowing what was actually happening underneath. Today I learned:

- The difference between `apt` (high level) and `dpkg` (low level)
- How to **hold** a package so it doesn't get upgraded accidentally in production
- How to install `.deb` files manually — this is how tools like VS Code and Chrome get installed
- The difference between `remove` (keeps config) vs `purge` (deletes everything)
- How to audit a server to see exactly what was manually installed

The most important thing I understood: **`apt` is a wrapper over `dpkg`**. When you `apt install`, it finds the `.deb` file, downloads it, and calls `dpkg` to install it — plus handles all the dependencies automatically.

---

## Commands I Practiced

### Update package index
```bash
sudo apt update
```
Always run this first. Without it, apt uses a stale list and may install old versions.

### Install multiple packages
```bash
sudo apt install -y curl tree htop
```

### Check installed version
```bash
apt show curl
dpkg -l curl
```

### Hold a package (pin the version)
```bash
sudo apt-mark hold curl

# Check what's held
apt-mark showhold
```
Used in production when you don't want a service like nginx or python to auto-upgrade and break things.

### Unhold
```bash
sudo apt-mark unhold curl
```

### Install a `.deb` file manually
```bash
wget http://archive.ubuntu.com/ubuntu/pool/universe/n/neofetch/neofetch_7.1.0-4_all.deb
sudo dpkg -i neofetch_7.1.0-4_all.deb

# Fix missing dependencies that dpkg can't auto-resolve
sudo apt install -f
```

### List all installed packages
```bash
dpkg -l | grep "^ii" | head -20
```

### Remove vs Purge
```bash
sudo apt remove tree       # removes binary, keeps config files
sudo apt purge tree        # removes binary + config (full clean)
sudo apt autoremove        # cleans up orphaned dependencies
```

---

## 🚀 Mini Project — Package Audit

**Goal:** Find out exactly what's manually installed on the AWS server and save it to a file.

**Real-world use:** Before migrating a server, DevOps engineers run this audit to know what needs to be reinstalled on the new machine.

### The one-liner
```bash
apt-mark showmanual | sort > manually-installed-packages.txt
```

### What each part does

| Part | What it does |
|------|--------------|
| `apt-mark showmanual` | Shows packages a human installed — not auto-installed dependencies |
| `\|` pipe | Sends output of left command as input to right command |
| `sort` | Alphabetizes the list |
| `> file.txt` | Saves to a file instead of printing to screen |

### My output on the AWS instance

```
base-files
bash
curl
docker.io
fish
htop
neofetch
neovim
nginx
openssh-server
traceroute
ubuntu-minimal
ubuntu-server
ubuntu-standard
util-linux
... (and more)
```

Full list → [`manually-installed-packages.txt`](./manually-installed-packages.txt)

---

## What I Understood vs What I Just Ran

**Things I actually understood:**
- Why `apt update` must come before `apt install`
- The pipe `|` and redirect `>` operators — I used both in the project
- Why `purge` is safer than `remove` in production cleanups
- `apt-mark hold` is a real production pattern — not just a lab exercise

**Things I need to revisit:**
- How apt resolves dependency conflicts (when two packages need different versions of the same library)
- What `dpkg --configure -a` does and when to use it
- PPA repositories — adding third-party package sources

---

## Files in This Directory

```
day12-package-management/
├── README.md                        ← This file
└── manually-installed-packages.txt  ← Package audit output from AWS instance
```

---

## Part of

[iampownkumar/devops-journey](https://github.com/iampownkumar/devops-journey) — 83-day public DevOps learning log.
