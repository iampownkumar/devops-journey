# Day 17 — Docker Networking

> Built on 5 May 2026 as part of my DevOps learning journey.
> Created by Pownkumar A (Founder of Korelium)

## What I learned
- Bridge, host, and none network types
- Container-to-container communication using container names (Docker DNS)
- Difference between `EXPOSE` (documentation) and `-p` (actual port mapping)
- Why you must create a **custom network** — the default bridge has no DNS

## Projects completed

### Project 1 — Two containers talking by name
Created a custom network `devnet`, ran nginx as `server`, ran alpine as `client`, and used `curl http://server` and `ping server` inside the client — resolved purely by container name via Docker DNS.

```bash
docker network create devnet
docker run -d --name server --network devnet nginx
docker run -it --rm --name client --network devnet alpine sh
# inside client:
curl http://server   # works by name, no IP needed
ping server -c 3
```

### Project 2 — Flask API + Redis hit counter
Built a Flask app that counts page hits using Redis as the backend. Both containers on a custom network `appnet` — Redis is never exposed to the host, only reachable inside the network.

```bash
docker network create appnet
docker run -d --name redis --network appnet redis:alpine
docker build -t flaskapp .
docker run -d --name api --network appnet -p 5000:5000 flaskapp
curl http://localhost:5000   # Hit count: 1
```

**Key lesson:** start dependencies (Redis) before the app that needs them. Flask crashes on boot if Redis isn't reachable.

## Files

| File | Purpose |
|------|---------|
| `app.py` | Flask app — increments a Redis counter on every request |
| `Dockerfile` | Builds the flaskapp image from python:3.11-slim |

## Mistakes I made and fixed
- `--port` doesn't exist — always use `-p host:container`
- `docker network create --host` is wrong — `host` is used at runtime with `--network host`
- `Flask(_name_)` → must be `Flask(__name__)` (double underscores)
- `@app.routei` → typo, should be `@app.route`
- `def index();` → semicolon should be a colon `:`
- Starting the API before Redis caused a 500 error — order matters

## Concepts reference

| Network type | Container-to-container | Internet | Port mapping |
|---|---|---|---|
| bridge (custom) | Yes, by name | Yes (NAT) | `-p` required |
| host | Yes (shared stack) | Yes | No `-p` needed |
| none | No | No | N/A |
