# Day 16 — Docker Volumes + Bind Mounts

> Built on 4 May 2026 as part of my DevOps learning journey.
> Created by Pownkumar A (Founder of Korelium)

## What I learned
- Named volumes vs bind mounts — when to use each
- Where MySQL actually stores data: `/var/lib/mysql`
- Named volume host path: `/var/lib/docker/volumes/<name>/_data`
- Bind mount syntax: `-v $(pwd)/mysqldata:/var/lib/mysql`
- Data persists across `docker stop` + `docker rm` + `docker run`
- Always use `-d` for databases, never `-it`
- Memory limit: `--memory=600m` prevents EC2 RAM freeze

## Commands practiced
```bash
docker run -d --name mysql-bind \
  -e MYSQL_ROOT_PASSWORD=iampown \
  -v $(pwd)/mysqldata:/var/lib/mysql \
  -p 3306:3306 --memory=600m mysql

docker volume ls
docker volume inspect mysql-data
docker stop mysql-bind && docker rm mysql-bind
```

## Proved
Inserted pownkumar + marudhu → rm container → restarted → data survived ✓

## Practice screenshots
See `images/` folder.
