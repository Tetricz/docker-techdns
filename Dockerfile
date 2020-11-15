FROM alpine:3.12

LABEL maintainer="github.com/Tetricz" \
    technitium-dns-version="5.5"

ENV RUNTIME="dotnet-runtime-3.1.8-linux-musl-x64.tar.gz" \
 RUNTIMELINK="https://download.visualstudio.microsoft.com/download/pr/cd533aaa-9707-4188-8381-96a37e1102b8/9df9516fd0ebb7e324c5779d035a59a3/dotnet-runtime-3.1.8-linux-musl-x64.tar.gz"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt"

RUN apk --no-cache add libstdc++ libgcc libssl1.1 zlib libintl krb5-libs icu-libs curl && \
 wget -O /tmp/${RUNTIME} ${RUNTIMELINK} && \
 mkdir -p "/opt" && tar zxf /tmp/$RUNTIME -C "/opt" && \
 wget -O /tmp/DnsServerPortable.tar.gz https://download.technitium.com/dns/DnsServerPortable.tar.gz && \
 mkdir -p /etc/dns/ && tar -zxf /tmp/DnsServerPortable.tar.gz -C /etc/dns/ && rm -v /tmp/*

WORKDIR /etc/dns

EXPOSE 53/udp 53/tcp 5380/tcp 67/udp

HEALTHCHECK --interval=60s --timeout=15s --start-period=60s --retries=2 \
             CMD curl -LSs 'https://api.ipify.org'

ENTRYPOINT [ "./start.sh" ]