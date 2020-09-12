# tet-techdns
QUICKSTART
```
docker run -v <your/directory>:/etc/dns/config -p 53:53/tcp -p 53:53/udp -p 5380:5380 -d --name techdns tetricz/techdns
```
