#!/bin/bash

# ERROR! Failed to install app '222860' (Invalid platform)
# Temporary Workaround
# https://github.com/ValveSoftware/steam-for-linux/issues/11522
# https://github.com/Left4DevOps/l4d2-docker/pull/15/commits/ac2105ead52081b478b96ea9961e8474587bb522

# Validate Game
if [ "$SRV_REPAIR_SERVER" = 1 ]
then
/SteamCMD/steamcmd.sh \
  +force_install_dir ../L4D2Content \
  +login anonymous \
  +@sSteamCmdForcePlatformType windows \
  +app_update 222860 validate\
  +@sSteamCmdForcePlatformType linux \
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
  +@sSteamCmdForcePlatformType windows \
  +app_update 222860 \
  +@sSteamCmdForcePlatformType linux \
  +app_update 222860 validate\
  +quit \
  </dev/null
fi

# Write Server Config
if [ "$CFG_RESTORE_DEFAULT" = 1 ]
then
cat > /L4D2Content/left4dead2/cfg/server.cfg << EOF
// Server Info
hostname "${CFG_INFORMATION_HOSTNAME}"
sv_steamgroup ${CFG_INFORMATION_STEAM_GROUP}
sv_region 255
motd_enabled 0

// Game Settings
sv_gametypes "${CFG_SETTINGS_GAME_TYPE}"
sv_consistency 0
sv_voiceenable 0
sv_pausable 0
director_no_human_zombies 1
sv_versus_swapteams 1

// Logging
sv_logecho 1
sv_logfile 0

// Network Performance
rate 30000
sv_minrate 10000
sv_maxrate 30000
sv_mincmdrate 30
sv_maxcmdrate 66
sv_minupdaterate 30
sv_maxupdaterate 66

// Security
sv_cheats 0
sv_lan 0
sv_allow_lobby_connect_only 0
sv_allow_wait_command 0

// Stability and Performance
sv_timeout 60
sv_maxplayers 8
sv_forcepreload 1
fps_max 0
EOF
fi

# Start Game
export LD_LIBRARY_PATH=/L4D2Content/bin:/L4D2Content/left4dead2/bin:$LD_LIBRARY_PATH:/SteamCMD/linux32:/SteamCMD/linux64
cd /L4D2Content
exec /L4D2Content/srcds_linux \
  -console \
  -game left4dead2 \
  -port "$SRV_PORT" \
  +map "$SRV_MAP" \
  +z_difficulty expert \
  $( [ "$SRV_SECURE_SERVER" = 1 ] && echo "-secure" || echo "-insecure" ) \
  -noipx \
  </dev/null \
  2>/dev/null
