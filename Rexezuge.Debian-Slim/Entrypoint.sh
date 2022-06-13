#!/bin/bash

# Update Game
SteamCMD/steamcmd.sh +force_install_dir ../L4D2Content +login anonymous +app_update 222860 +quit

# Write Server Config
if [ "$CFG_FORCEOVERWRITE" = 1 ]
then
cat > L4D2Content/left4dead2/cfg/server.cfg << EOF
hostname "${CFG_HOSTNAME}"
motd_enabled 0
sv_logecho 1
sv_region ${CFG_REGION}
sv_steamgroup ${CFG_STEAMGROUP}
sv_gametypes "${CFG_GAMETYPE}"
sv_consistency ${CFG_CONSISTENCY}
sv_voiceenable ${CFG_VOICEENABLED}
EOF
fi

# Start Game
if [ "$SRV_SECURESERVER" = 1 ]
then
echo "Starting VAC Secured Server"
L4D2Content/srcds_run -console -game left4dead2 -port "$SRV_PORT" +maxplayers "$SRV_PLAYERS" +map "$SRV_MAP" -secure -noipx
else
echo "Starting Unsecured Server"
L4D2Content/srcds_run -console -game left4dead2 -port "$SRV_PORT" +maxplayers "$SRV_PLAYERS" +map "$SRV_MAP" -insecure -noipx
fi
