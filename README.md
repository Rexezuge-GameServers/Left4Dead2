# Left4Dead2

## Source

[Github/Rexezuge-GameServers/Left4Dead2](https://github.com/Rexezuge-GameServers/Left4Dead2)

## Launch Server

👉 Setup Persist Volumes

```bash
sudo mkdir /L4D2Server_DATA
sudo chown 27015:27015 /L4D2Server_DATA
docker volume create SteamCMD_DATA
```

✅ Launch Server

```
docker run -d \
    --name L4D2-Server \
    -p 27015:27015/udp \
    -v /L4D2Server_DATA:/L4D2Content \
    -v SteamCMD_DATA:/SteamCMD \
    --cap-drop=ALL \
    --log-driver=journald \
    rexezugegameservers/left4dead2
```

## Ports

_By default, L4D2 runs on port `27015`, but any port will work._

To change the port used inside the container change the `SRV_PORT` environment variable, then map the new ports instead.

## Hostname

This identifies your server in the server browser.  By default it is set to _"Community Left4Dead 2 World Server"_.  Change it by setting the `CFG_INFORMATION_HOSTNAME` environment variable.

## Addons

Move `.vpk` files to `/L4D2Content/left4dead2/addons`

### Automate with Rsync

📌 Only need to run this command once:

- On Server, goto `/L4D2Server_DATA`

```bash
sudo chown $USER:$USER /L4D2Server_DATA/left4dead2/addons
```

🌟 Run this every time:

- On Your Computer, goto `.../Steam/steamapps/common/Left 4 Dead 2/left4dead2/addons/workshop`

```bash
rsync -rvz --delete . <remote>:/L4D2Server_DATA/left4dead2/addons
```

## Tips for Clients

### Avoid Heap Memory Overload

1. Download DXVK: [https://github.com/doitsujin/dxvk](https://github.com/doitsujin/dxvk)
2. Install DXVK: Place the `d3d9.dll` and `dxgi.dll` files from the `x32` folder inside the archive into the game's root directory.

## Tips for Resource Constrained Servers

> Server with `0.25` vCPU + `1` GB RAM

### Limit Resource Usage

1. Reserve `512` MB RAM for Game Server
2. Limit CPU Time to `0.2`

### Reduce Network Overhead

1. Use `host` Network to Run Docker Container
