# Left 4 Dead 2 Server Docker Image

## Source

[Github/Rexezuge/L4D2-Dedicated-Server-Docker](https://github.com/Rexezuge/L4D2-Dedicated-Server-Docker)

## Docker CMD

```docker
docker volume create SteamCMD_DATA
docker volume create L4D2Server_DATA
docker run --name L4D2-Server -d -p 27015:27015/udp -v L4D2Server_DATA:/L4D2Content -v SteamCMD_DATA:/SteamCMD rexezuge/l4d2-server
```

## Ports

_By default, L4D2 runs on port `27015`, but any port will work._

To change the port used inside the container change the `SRV_PORT` environment variable, then map the new ports instead.

## Hostname

This identifies your server in the server browser.  By default it is set to _"Community Left4Dead 2 World Server"_.  Change it by setting the `CFG_INFORMATION_HOSTNAME` environment variable.

## Addons

Move `.vpk` files to `/L4D2Content/left4dead2/addons`
