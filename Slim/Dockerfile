FROM debian:11-slim

# Add Dependency
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt upgrade -y \
    && apt install -y curl lib32gcc-s1 libc6-i386 \
    && apt clean

# Add Working User
RUN useradd steam
WORKDIR /home/steam
USER steam

# Extract SteamCMD
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz --output steamcmd.tar.gz \
    && mkdir .SteamCMD \
    && tar -xzf steamcmd.tar.gz -C .SteamCMD \
    && rm steamcmd.tar.gz \
    && .SteamCMD/steamcmd.sh +quit

# Removed Unused Dependency
RUN apt autoremove --purge -y curl

# Install Left4Dead 2
RUN .SteamCMD/steamcmd.sh +force_install_dir ./.L4D2Content +login anonymous +app_update 222860 +quit

# Bind Volume(s)
RUN rm -rf /home/$USER/l4d2/left4dead2/addons \
    && ln -s /addons /home/$USER/l4d2/left4dead2/addons \
    && rm -rf /home/$USER/l4d2/left4dead2/ems \
    && ln -s /ems /home/$USER/l4d2/left4dead2/ems

# Port Forwarding
EXPOSE 27015/udp

# Volume
VOLUME /addons /ems

# Environment(s)
ENV PORT=27015 \
    PLAYERS=8 \
    MAP="c14m1_junkyard" \
    REGION=255 \
    HOSTNAME="Left4DevOps L4D2" \
    STEAMGROUP=39122167

## Set Entrypoint
ADD entrypoint.sh .Entrypoint.sh
ENTRYPOINT ./.Entrypoint.sh
