# Left 4 Dead 2 Server Docker Image

## Source
[Github](https://github.com/Rexezuge/L4D2-Dedicated-Server-Docker)

## Docker CMD
```docker
docker volume create SteamCMD_DATA
docker volume create L4D2Server_DATA
docker run -p 27015:27015/udp -v L4D2Server_DATA:/L4D2Content -v SteamCMD_DATA:/SteamCMD --name L4D2Server rexezuge/l4d2-server
```

## Ports
_By default, L4D2 runs on port `27015`, but any port between `27015-27020` will work._

To change the port used inside the container change the `PORT` environment variable, then map the new ports instead.

## Hostname
This identifies your server in the server browser.  By default it is set to "Left4DevOps L4D2".  Change it by setting the `HOSTNAME` environment variable.

## Region
To help hint to Steam where your server is located, set the `REGION` environment variable as one of the following numeric regions:

| Location        | REGION   |
| --------------- | -------- |
| East Coast USA  | 0        |
| West Coast USA  | 1        |
| South America   | 2        |
| Europe          | 3        |
| Asia            | 4        |
| Australia       | 5        |
| Middle East     | 6        |
| Africa          | 7        |
| World (Default) | 255      |

## Addons
Move `.vpk` files to `/L4D2Content/left4dead2/addons`
