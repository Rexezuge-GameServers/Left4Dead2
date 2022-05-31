# Left 4 Dead 2 Server Docker Image
:x: **Left4DevOps.AmazonLinux Is No Longer Being Developed**

:heavy_check_mark: **Rexezuge.Debian-Slim Is Actively Developing**

## Source
[Github](https://github.com/Rexezuge-Forks/L4D2-Dedicated-Server)

## Docker CMD
```docker
docker volume create L4D2Server_DATA
docker run -p 27015:27015/udp -v L4D2Server_DATA:/L4D2Content --name L4D2Server rexezuge/l4d2:<CommitID>
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
