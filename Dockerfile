ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
FROM $REPO:3.1-buster-slim
LABEL maintainer="tomas@saiyans.com.ve"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && apt-get install -y --no-install-recommends \
        wget \
    && rm -rf /var/lib/apt/lists/*
    # Install .NET Core
RUN dotnet_version=3.1.5 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-x64.tar.gz \
    && dotnet_sha512='b88e110df7486266e3850d26617290cdee13b20dabc6fbe62bcac052d93cd7e76f787722a5beb15b06673577a47ba26943530cb14913569a25d9f55df029f306' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && wget https://download.technitium.com/dns/DnsServerPortable.tar.gz \
    && mkdir -p /etc/dns/ \
    && tar -zxf DnsServerPortable.tar.gz -C /etc/dns/ \
    && chmod u+x /etc/dns/start.sh \
    && rm DnsServerPortable.tar.gz 

VOLUME /etc/dns

EXPOSE 53 5380

WORKDIR /etc/dns

ENTRYPOINT ["dotnet", "DnsServerApp.dll"]
