# Day 15 — Writing Dockerfiles

> Built on 1 May 2026 as part of my DevOps learning journey.
> Created by Pownkumar A (Founder of Korelium)

## What I learned
- Dockerfile instructions: FROM, WORKDIR, COPY, EXPOSE, CMD
- Build an image from scratch
- Layer caching — why order matters
- Volume mounts for live development

## Project: Python HTTP Server

```
day15-dockerfiles
    ├── python-http-server
    │   ├── Dockerfile
    │   └── images
    │       ├── volume-mount-1.png
    │       └── volume-mount.png
    └── README.md
```

### Build
```bash
docker build -t new .
```

### Run (static)
```bash
docker run -p 8000:8000 new
```

### Run with volume mount (live reload)
```bash
docker run -p 8000:8000 -v $(pwd):/app new
```

## Key insight
Container is immutable — files added after `docker build` don't exist inside it.  
Use `-v` volume mount during development to avoid rebuilding on every change.
