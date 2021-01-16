## Technitium DNS Server
https://technitium.com/dns/
## docker-technitium-dns
QUICKSTART
```
docker run -dit -v <your/directory>:/etc/dns/config -p 53:53/tcp -p 53:53/udp -p 5380:5380 -p 67/67/udp --name techdns tetricz/techdns
```
or
```
docker run -dit -v <your/directory>:/etc/dns/config --net=host --name techdns tetricz/techdns
```
I recommend running the network in host mode. Make sure you unbind or stop any programs using port 53 if you are to use network host.