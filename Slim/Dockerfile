FROM debian:11-slim

# Add Dependency
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl lib32gcc-s1 libc6-i386 \
    && apt clean

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
    && mkdir .SteamCMD \
    && tar -xzf steamcmd.tar.gz -C .SteamCMD \
    && rm steamcmd.tar.gz \
    && .SteamCMD/steamcmd.sh +quit

# Removed Unused Dependency
RUN apt autoremove --purge -y curl

# Install Left4Dead 2
RUN .SteamCMD/steamcmd.sh +force_install_dir ../.L4D2Content +login anonymous +app_update 222860 +quit

# Remove Existing Folder(s) for Volume Mounting
RUN rm -rf /.L4D2Content/left4dead2/addons \
    && rm -rf /.L4D2Content/left4dead2/ems

# Port Forwarding
#   Only Game Server Port is Open by Default
#   Uncomment the Following Line if You Want RCON
#   EXPOST 27015/tcp
EXPOSE 27015/udp

# Volume
VOLUME /.L4D2Content/left4dead2/addons \
       /.L4D2Content/left4dead2/ems

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
