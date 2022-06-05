#!/bin/bash

# Update Game
SteamCMD/steamcmd.sh +force_install_dir ../L4D2Content +login anonymous +app_update 222860 +quit

# Write Server Config
if [ "$FORCEOVERWRITE" = 1 ]
then
cat > L4D2Content/left4dead2/cfg/server.cfg << EOF
hostname "${HOSTNAME}"
motd_enabled 0
sv_region ${REGION}
sv_logecho 1
sv_steamgroup ${STEAMGROUP}
sv_gametypes "${GAMETYPE}"
sv_consistency ${CONSISTENCY}
EOF
fi

# Start Game
if [ "$SECURESERVER" = 1 ]
then
echo "Starting VAC Secured Server"
L4D2Content/srcds_run -console -game left4dead2 -port "$PORT" +maxplayers "$PLAYERS" +map "$MAP" -secure -noipx
else
echo "Starting Unsecured Server"
L4D2Content/srcds_run -console -game left4dead2 -port "$PORT" +maxplayers "$PLAYERS" +map "$MAP" -insecure -noipx
fi
