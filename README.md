## Technitium DNS Server
https://technitium.com/dns/
## docker-technitium-dns
QUICKSTART
```
docker run -v <your/directory>:/etc/dns/config -p 53:53/tcp -p 53:53/udp -p 5380:5380 -p 67/67/udp -d --name techdns tetricz/techdns
```
