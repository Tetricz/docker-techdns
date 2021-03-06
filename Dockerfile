# Maintainer https://github.com/Tetricz
# https://hub.docker.com/_/microsoft-dotnet-sdk
# https://hub.docker.com/_/microsoft-dotnet-runtime/
ARG SDK_VERSION=5.0
ARG RUNTIME_VERSION=5.0

FROM alpine:latest as downloader
# https://github.com/TechnitiumSoftware/DnsServer
ARG TECHDNS_VERSION=master
RUN apk add --no-cache curl unzip \
 && curl -L https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/heads/master.zip -o techlibrary.zip \
 && unzip *library.zip \
 && curl -L https://github.com/TechnitiumSoftware/DnsServer/archive/refs/heads/${TECHDNS_VERSION}.zip -o techdns.zip \
 && unzip *dns.zip

FROM mcr.microsoft.com/dotnet/sdk:${SDK_VERSION} as builder
# https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#linux-rids
ARG RID=linux-x64
COPY --from=downloader /TechnitiumLibrary-master /TechnitiumLibrary-master
COPY --from=downloader DnsServer-* DnsServer-build
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.ByteTree --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.Database --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.IO --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.Net --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.Net.UPnP --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish TechnitiumLibrary-master/TechnitiumLibrary.Security.Cryptography --disable-parallel --configuration Release --output="/TechnitiumLibrary/bin" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none" \
 && dotnet publish DnsServer-build/DnsServerApp --disable-parallel --configuration Release --output="/dns" --self-contained --runtime ${RID} "-p:DebugSymbols=false;DebugType=none"

FROM mcr.microsoft.com/dotnet/runtime:${RUNTIME_VERSION}

COPY --from=builder /dns /dns
WORKDIR /dns
EXPOSE 53/udp 53/tcp 5380/tcp 67/udp

ENTRYPOINT [ "dotnet", "DnsServerApp.dll" ]