# Left 4 Dead 2 Server Docker Image

## Source

[Github/Rexezuge/L4D2-Dedicated-Server-Docker](https://github.com/Rexezuge/L4D2-Dedicated-Server-Docker)

## Launch Server

```bash
sudo mkdir /L4D2Server_DATA
docker volume create SteamCMD_DATA
docker run --name L4D2-Server -d -p 27015:27015/udp -v /L4D2Server_DATA:/L4D2Content -v SteamCMD_DATA:/SteamCMD rexezuge/l4d2-server
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
