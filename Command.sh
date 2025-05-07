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
