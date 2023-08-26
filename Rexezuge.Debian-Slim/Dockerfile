FROM debian:12-slim

# Volume Mounting Directory
RUN mkdir SteamCMD \
 && mkdir L4D2Content

# Add Dependency
RUN dpkg --add-architecture i386 \
 && apt update \
 && apt upgrade -y \
 && apt install -y curl lib32gcc-s1 libc6-i386

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
 && tar -xzf steamcmd.tar.gz -C SteamCMD \
 && rm steamcmd.tar.gz

# Removed Unused Dependency
RUN apt autoremove --purge -y curl \
 && apt clean \
 && apt autoremove --purge -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Softlink Steam Library
RUN mkdir ~/.steam \
 && mkdir ~/.steam/sdk32/ \
 && ln -s /SteamCMD/linux32/steamclient.so ~/.steam/sdk32/steamclient.so \
 && mkdir ~/.steam/sdk64/ \
 && ln -s /SteamCMD/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Add Files
ADD Entrypoint.sh /.Entrypoint.sh

# Remove Intermediate Layer
FROM scratch
COPY --from=0 / /

# Make Entrypoint Executable
RUN chmod +x /.Entrypoint.sh

# Image Label(s)
LABEL VRESION="Rolling Release" \
      UPSTREAM="https://github.com/Rexezuge-Forks/L4D2-Dedicated-Server"

# Port Forwarding
#   Only Game Server Port is Open by Default
#   Uncomment the Following Line if You Want RCON
#   EXPOST 27015/tcp
EXPOSE 27015/udp

# Volume
VOLUME /SteamCMD /L4D2Content

# Environment(s)
ENV SRV_PORT=27015 \
    SRV_PLAYERS=8 \
    SRV_MAP="c14m1_junkyard" \
    SRV_SECURESERVER=1 \
    CFG_FORCEOVERWRITE=1 \
    CFG_HOSTNAME="Community Left4Dead 2 World Server" \
    CFG_REGION=255 \
    CFG_STEAMGROUP=0 \
    CFG_GAMETYPE="coop,versus" \
    CFG_CONSISTENCY=1 \
    CFG_VOICEENABLED=1

# Uninstall Package Manager
RUN apt autoremove --purge apt --allow-remove-essential -y \
 && rm -rf /var/log/apt /etc/apt

# Set Entrypoint
ENTRYPOINT ["/bin/bash", "-c", "/.Entrypoint.sh"]
