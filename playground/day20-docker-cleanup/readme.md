# Day 20 — Docker Cleanup & Storage

> Just a learning day. No project. No pressure.

## What I did today

Learned how Docker accumulates junk over time and how to clean it up properly.

## Commands I practiced

```bash
# See what's taking up disk space
docker system df

# Safe cleanup — removes stopped containers, dangling images, unused networks, build cache
docker system prune

# More aggressive — also removes unused images
docker system prune -a

# Remove specific images
docker rmi image-name
```

## Concepts covered

- **Multi-stage builds** — use a big environment to build, ship only the output
- **Alpine images** — tiny 5MB base OS instead of full Ubuntu/Debian
- **.dockerignore** — like .gitignore, stops junk and secrets entering the image
- **docker system prune** — Docker's version of `flutter clean`

## Key takeaway

Docker never auto-cleans itself. Left alone for weeks it quietly eats 20–40GB of disk.
Run `docker system df` regularly. Run `docker system prune` when it gets heavy.

---

*Day 20 of the DevOps journey. Exhausted. Called it here.*
