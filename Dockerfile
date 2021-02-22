ARG REPO=mcr.microsoft.com/dotnet/core/runtime-
ARG DOTNET_VERSION=5.0.3
FROM amd64/buildpack-deps:buster-curl as installer
ARG DOTNET_VERSION
LABEL maintainer="tomas@saiyans.com.ve"

# Retrieve .NET
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='263dbe260123c3d6d706ed8b5f4d510d9384216422e9af0d293df87ed98e84e1e0ffbf0c7dd543c40c5ccc95bd7cd006c8bbbe9f1cd1f060b1eaa2f7a60fea74' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -ozxf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz \
    && ln -s /dotnet/dotnet /usr/bin/dotnet \
    && curl -O https://download.technitium.com/dns/DnsServerPortable.tar.gz \
    && mkdir -p /etc/dns/ \
    && tar -zxf DnsServerPortable.tar.gz -C /etc/dns/ \
    && rm DnsServerPortable.tar.gz 

VOLUME /etc/dns

EXPOSE 53 5380

WORKDIR /etc/dns

ENTRYPOINT ["dotnet", "DnsServerApp.dll"]
