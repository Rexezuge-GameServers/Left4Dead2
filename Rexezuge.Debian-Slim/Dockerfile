FROM debian:11-slim

# Add Dependency
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl lib32gcc-s1 libc6-i386 \
    && apt clean

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
    && mkdir SteamCMD \
    && tar -xzf steamcmd.tar.gz -C SteamCMD \
    && rm steamcmd.tar.gz \
    && SteamCMD/steamcmd.sh +quit

# Removed Unused Dependency
RUN apt autoremove --purge -y curl

# Softlink Steam Library
RUN mkdir ~/.steam/sdk32/ \
    && ln -s /SteamCMD/linux32/steamclient.so ~/.steam/sdk32/steamclient.so \
    && mkdir ~/.steam/sdk64/ \
    && ln -s /SteamCMD/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Volume Mounting Directory
RUN mkdir L4D2Content

# Port Forwarding
#   Only Game Server Port is Open by Default
#   Uncomment the Following Line if You Want RCON
#   EXPOST 27015/tcp
EXPOSE 27015/udp

# Volume
VOLUME /L4D2Content

# Environment(s)
ENV PORT=27015 \
    PLAYERS=8 \
    MAP="c14m1_junkyard" \
    REGION=255 \
    HOSTNAME="Community Left4Dead 2 Server" \
    STEAMGROUP=0

## Set Entrypoint
ADD Entrypoint.sh .Entrypoint.sh
ENTRYPOINT ./.Entrypoint.sh
