FROM alpine:3 AS builder

# Add File(s)
ADD Command.sh /.Command.sh

# Make Command Executable
RUN chmod +x /.Command.sh

FROM rexezugegameservers/left4dead2-base

COPY --from=builder /.Command.sh /.Command.sh

# Image Label(s)
LABEL UPSTREAM="https://github.com/Rexezuge-GameServers/Left4Dead2"

# Volume
VOLUME /SteamCMD /L4D2Content

# Environment(s)
ENV SRV_REPAIR_SERVER=0 \
    SRV_UPDATE_SERVER=1

# Set CMD
CMD ["/.Command.sh"]
