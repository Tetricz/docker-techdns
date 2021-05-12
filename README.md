# Technitium DNS Server
[Technitium](https://technitium.com/dns/)
## QUICKSTART
```
docker run -dit -v <your/directory>:/dns/config -p 53:53/tcp -p 53:53/udp -p 5380:5380 -p 67/67/udp --name techdns tetricz/techdns
```
or
```
docker run -dit -v <your/directory>:/dns/config --net=host --name techdns tetricz/techdns
```
I recommend running the network in host mode. Make sure you unbind or stop any programs using port 53 if you are to use network host.
## Building the image yourself
```
docker build image --build-arg SDK_VERSION=5.0-alpine3.13-amd64 --build-arg RUNTIME_VERSION=5.0-alpine3.13-amd64 --build-arg RID=linux-musl-x64 -t techdns:amd64 --no-cache  .
```
Using Buildx for multiple platforms
```
docker buildx build --build-arg SDK_VERSION=5.0 --build-arg RUNTIME_VERSION=5.0-alpine3.13-arm64v8 --build-arg RID=linux-musl-x64 --platform linux/arm64 -f "Dockerfile" -t tetricz/techdns:arm64 --no-cache --push .
docker buildx build --build-arg SDK_VERSION=5.0-buster-slim-amd64 --build-arg RUNTIME_VERSION=5.0-buster-slim-arm32v7 --build-arg RID=linux-arm --platform linux/arm/v7 -f "Dockerfile" -t tetricz/techdns:armv7 --no-cache --push .
```