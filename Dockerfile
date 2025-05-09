FROM debian:12-slim AS downloader

RUN mkdir -p /tmp/SteamCMD/

RUN apt update \
 && apt install -y --no-install-recommends curl

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
 && tar -xzf steamcmd.tar.gz -C /tmp/SteamCMD/ \
 && rm steamcmd.tar.gz

RUN chown -R 27015:27015 /tmp/SteamCMD/

FROM alpine:3 AS builder

# Add File(s)
ADD Command.sh /.Command.sh

# Make Command Executable
RUN chmod +x /.Command.sh

FROM rexezugegameservers/left4dead2-base

COPY --from=builder /.Command.sh /.Command.sh

COPY --from=downloader /tmp/SteamCMD/ /SteamCMD/

# Image Label(s)
LABEL UPSTREAM="https://github.com/Rexezuge-GameServers/Left4Dead2"

# Volume
VOLUME /SteamCMD /L4D2Content

# Environment(s)
ENV SRV_REPAIR_SERVER=0 \
    SRV_UPDATE_SERVER=1

# Set CMD
CMD ["/.Command.sh"]
