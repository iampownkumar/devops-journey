# Day 13 — Process Management + Monitoring

> Written by Pownkumar (Founder of Korelium ) · 28 April 2026
> Practiced on a **live AWS EC2 instance** (Ubuntu 22.04)
---

## What I learned today

### `ps` — Snapshot of processes

```bash
ps aux                        # all processes, all users
ps aux --sort=-%mem | head -5 # top 5 memory hogs
ps -ef                        # adds PPID (parent process) column
ps -el | grep sleep | sort    # see nice values live
ps -o pid,pgid,ppid,stat,cmd -p 45722  # custom columns for one PID
```

> Key insight: `ps -ef` shows the **parent-child chain** — I could trace my entire
> login: `sshd → sshd(priv) → sshd(ubuntu) → fish → my commands`

---

### `kill` — Sending signals

```bash
kill -TERM 45070    # SIGTERM (15) — polite, process can clean up
kill -STOP 45048    # pause a process (stays in memory, frozen)
kill -CONT 45048    # resume a stopped process
kill -9   45033     # SIGKILL — forced, no cleanup, last resort
kill -L             # list all 31 signals with numbers
```

**Signal cheat sheet I actually used:**

| Signal | Number | What it does |
|--------|--------|--------------|
| TERM   | 15     | Polite quit — process can clean up |
| KILL   | 9      | Forced kill — kernel does it, no escape |
| STOP   | 19     | Freeze/pause the process |
| CONT   | 18     | Resume a stopped process |
| HUP    | 1      | Reload config (nginx, sshd love this) |

> `kill -STOP` was new to me — you can freeze a process without killing it,
> then `kill -CONT` to unfreeze it. Useful for pausing a runaway job.

---

### `nice` and `renice` — Process priority

```bash
nice -n 10 sleep 999 &        # start with low priority (nice 10)
nice -n 15 sleep 999 &        # even lower
renice -n 19 -p 45033         # change running process by PID
renice -n 19 -g 45722         # change entire process group at once
sudo renice -n 15 -p 1326     # negative nice needs root
ps -el | grep sleep | sort    # NI column shows current nice value
```

> Nice values: **-20 = highest priority**, **+19 = lowest priority**
> Only root can set negative nice (give a process more CPU than default)
> I tried `renice -n -10` without sudo — got "Permission denied". Lesson learned.

---

### `pkill` — Kill by name

```bash
pkill -stop sleep             # STOP all processes named sleep
sudo pkill -stop sleep        # need sudo for root-owned ones
pkill -f "sleep 938"          # match full command string
```

> `pkill` failed on root's `sleep 60` without sudo — you can't send signals
> to another user's process. Permission model in action.

---

### Background jobs — `&`, `jobs`, `disown`

```bash
sleep 900 &                   # run in background, get PID
sleep 69 &                    # another one
jobs                          # see all background jobs
kill -stop 1326               # stop a specific job
kill -cont 1219 1326          # resume multiple at once
disown                        # detach job — survives shell exit
```

> The most real-world moment: I ran `disown` and my SSH session dropped
> (connection timed out). The job survived — that's exactly what disown does.
> The process kept running on the server even after I disconnected.

---

## What surprised me

- `kill -STOP` + `kill -CONT` — never knew you could pause/resume a process
- `renice -g` changes the entire **process group**, not just one PID
- `disown` actually worked — SSH dropped, but the process survived
- `kill -L` shows 31 signals. I thought there were only a few
- You don't have to memorize signal numbers — you can use the name directly:
  ```bash
  kill -9 45033       # old way — had to remember 9 = KILL
  kill -KILL 45033    # same thing, way more readable
  kill -TERM 45033    # same as kill -15
  kill -STOP 45033    # same as kill -19
  ```
  Today I stopped thinking in numbers and started thinking in names. Much clearer.

---

## Commands I'm confident in now

```bash
ps aux --sort=-%mem | head -5
ps -el | grep <name> | sort
kill -TERM <pid>
kill -STOP <pid> && kill -CONT <pid>
renice -n 19 -p <pid>
sudo renice -n -5 -p <pid>
pkill -f "process name"
sleep 999 & disown
```

---

*Day 13 of 90 — DevOps roadmap | Practiced on AWS EC2 Ubuntu*
