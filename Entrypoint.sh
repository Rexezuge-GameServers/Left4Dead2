#!/bin/bash

# ERROR! Failed to install app '222860' (Invalid platform)
# Temporary Workaround
# https://github.com/ValveSoftware/steam-for-linux/issues/11522
/SteamCMD/steamcmd.sh +force_install_dir ../L4D2Content +@sSteamCmdForcePlatformType windows
/SteamCMD/steamcmd.sh +force_install_dir ../L4D2Content +@sSteamCmdForcePlatformType linux

# Validate Game
if [ "$SRV_REPAIR_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +@sSteamCmdForcePlatformType linux \
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
  +@sSteamCmdForcePlatformType linux \
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
// Information
hostname "${CFG_INFORMATION_HOSTNAME}"
motd_enabled 0
sv_region ${CFG_INFORMATION_REGION}
sv_steamgroup ${CFG_INFORMATION_STEAM_GROUP}

// Settings
sv_gametypes "${CFG_SETTINGS_GAME_TYPE}"
sv_consistency ${CFG_SETTINGS_CONSISTENCY}
sv_voiceenable ${CFG_SETTINGS_VOICE_ENABLED}

// Logging
sv_logecho 1
sv_logfile ${CFG_LOGGING_TO_FILE}

// Network Tweaks
rate ${CFG_NETWORK_RATE}
sv_minrate ${CFG_NETWORK_MIN_RATE}
sv_maxrate ${CFG_NETWORK_MAX_RATE}
sv_mincmdrate ${CFG_NETWORK_MIN_CMD_RATE}
sv_maxcmdrate ${CFG_NETWORK_MAX_CMD_RATE}
EOF
fi

# Start Game
exec /L4D2Content/srcds_run \
  -console \
  -game left4dead2 \
  -port "$SRV_PORT" \
  +maxplayers "$SRV_PLAYERS" \
  +map "$SRV_MAP" \
  $( [ "$SRV_SECURE_SERVER" = 1 ] && echo "-secure" || echo "-insecure" ) \
  -noipx \
  </dev/null \
  2>/dev/null
