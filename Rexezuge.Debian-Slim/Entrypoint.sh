#!/bin/bash

# Validate Game
if [ "$SRV_REPAIR_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +force_install_dir ../L4D2Content \
  +login anonymous \
  +app_update 222860 validate \
  +quit \
  </dev/null
fi

# Update Game
if [ "$SRV_UPDATE_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +force_install_dir ../L4D2Content \
  +login anonymous \
  +app_update 222860 \
  +quit \
  </dev/null
fi

# Write Server Config
if [ "$CFG_FORCE_OVERWRITE" = 1 ]
then
cat > /L4D2Content/left4dead2/cfg/server.cfg << EOF
hostname "${CFG_HOSTNAME}"
motd_enabled 0
sv_logecho 1
sv_region ${CFG_REGION}
sv_steamgroup ${CFG_STEAM_GROUP}
sv_gametypes "${CFG_GAME_TYPE}"
sv_consistency ${CFG_CONSISTENCY}
sv_voiceenable ${CFG_VOICE_ENABLED}
EOF
fi

# Start Game
/L4D2Content/srcds_run \
  -console \
  -game left4dead2 \
  -port "$SRV_PORT" \
  +maxplayers "$SRV_PLAYERS" \
  +map "$SRV_MAP" \
  $( [ "$SRV_SECURE_SERVER" = 1 ] && echo "-secure" || echo "-insecure" ) \
  -noipx \
  </dev/null \
  2>/dev/null
