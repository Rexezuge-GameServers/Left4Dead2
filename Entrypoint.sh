#!/bin/bash

# Workaround for invalid platform error (see related GitHub issues)
# https://github.com/ValveSoftware/steam-for-linux/issues/11522
# https://github.com/Left4DevOps/l4d2-docker/pull/15/commits/ac2105ead52081b478b96ea9961e8474587bb522

# Shared SteamCMD arguments
STEAMCMD_COMMON_ARGS="+force_install_dir ../L4D2Content +login anonymous"

# Function: Run SteamCMD with platform override and optional validation
run_steamcmd_update() {
  local validate_flag=$1
  /SteamCMD/steamcmd.sh \
    $STEAMCMD_COMMON_ARGS \
    +@sSteamCmdForcePlatformType windows \
    +app_update 222860 ${validate_flag} \
    +@sSteamCmdForcePlatformType linux \
    +app_update 222860 ${validate_flag} \
    +quit \
    </dev/null
}

# Validate Game
if [ "$SRV_REPAIR_SERVER" = 1 ]; then
  run_steamcmd_update validate
fi

# Update Game (skip validate for performance)
if [ "$SRV_UPDATE_SERVER" = 1 ]; then
  run_steamcmd_update ""
fi

# Restore Default Server Config
if [ "$CFG_RESTORE_DEFAULT" = 1 ]; then
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
rate 20000
sv_minrate 5000
sv_maxrate 20000
sv_mincmdrate 20
sv_maxcmdrate 40
sv_minupdaterate 15
sv_maxupdaterate 30

// Security
sv_cheats 0
sv_lan 0
sv_allow_lobby_connect_only 0
sv_allow_wait_command 0

// Stability and Performance
sv_timeout 60
sv_maxplayers 8
sv_forcepreload 1
fps_max 60
EOF
fi

# Start Game Server
export LD_LIBRARY_PATH=/L4D2Content/bin:/L4D2Content/left4dead2/bin:$LD_LIBRARY_PATH:/SteamCMD/linux32:/SteamCMD/linux64
cd /L4D2Content
exec ./srcds_linux \
  -console \
  -game left4dead2 \
  -port "$SRV_PORT" \
  +map "$SRV_MAP" \
  +z_difficulty expert \
  $( [ "$SRV_SECURE_SERVER" = 1 ] && echo "-secure" || echo "-insecure" ) \
  -noipx \
  </dev/null 2>/dev/null
