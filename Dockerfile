FROM debian:12-slim

# Volume Mounting Directory
RUN mkdir /SteamCMD \
 && mkdir /L4D2Content

# Add Dependency
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y --no-install-recommends curl lib32gcc-s1 libc6-i386

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
 && tar -xzf steamcmd.tar.gz -C SteamCMD \
 && rm steamcmd.tar.gz

# Removed Unused Dependency
RUN apt autoremove --purge -y curl \
 && apt clean \
 && apt autoremove --purge -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Add Files
ADD Entrypoint.sh /.Entrypoint.sh

# Make Entrypoint Executable
RUN chmod +x /.Entrypoint.sh

# Uninstall Package Manager
RUN apt install -y --no-install-recommends ca-certificates \
 && apt autoremove --purge apt --allow-remove-essential -y \
 && rm -rf /var/log/apt /etc/apt \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Setup User
RUN useradd --uid 27015 -m steam

# Grant Permission to User
RUN chown -R steam:steam /SteamCMD \
 && chown -R steam:steam /L4D2Content

# Change User
WORKDIR /home/steam
USER steam

# Softlink Steam Library
RUN mkdir ~/.steam \
 && mkdir ~/.steam/sdk32/ \
 && ln -s /SteamCMD/linux32/steamclient.so ~/.steam/sdk32/steamclient.so \
 && mkdir ~/.steam/sdk64/ \
 && ln -s /SteamCMD/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Remove Intermediate Layer
FROM scratch

COPY --from=0 / /

# Change User
USER steam

# Image Label(s)
LABEL UPSTREAM="https://github.com/Rexezuge/L4D2-Dedicated-Server-Docker"

# Port Forwarding
#   Only Game Server Port is Open by Default
#   Uncomment the Following Line if You Want RCON
#   EXPOSE 27015/tcp
EXPOSE 27015/udp

# Volume
VOLUME /SteamCMD /L4D2Content

# Environment(s)
ENV SRV_PORT=27015 \
    SRV_MAP="c14m1_junkyard" \
    SRV_SECURE_SERVER=1 \
    SRV_REPAIR_SERVER=0 \
    SRV_UPDATE_SERVER=1
ENV CFG_FORCE_OVERWRITE=1 \
    CFG_INFORMATION_HOSTNAME="Community Left4Dead 2 World Server" \
    CFG_INFORMATION_REGION=255 \
    CFG_INFORMATION_STEAM_GROUP=0 \
    CFG_SETTINGS_GAME_TYPE="coop,versus" \
    CFG_SETTINGS_CONSISTENCY=1 \
    CFG_SETTINGS_VOICE_ENABLED=1 \
    CFG_NETWORK_RATE=10000 \
    CFG_NETWORK_MIN_RATE=5000 \
    CFG_NETWORK_MAX_RATE=30000 \
    CFG_NETWORK_MIN_CMD_RATE=20 \
    CFG_NETWORK_MAX_CMD_RATE=33 \
    CFG_LOGGING_TO_FILE=0

# Set Entrypoint
ENTRYPOINT ["/bin/bash", "-c", "exec /.Entrypoint.sh"]
