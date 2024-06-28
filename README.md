**Team Fortress 2 Server Docker Image**
=====================================

Run a Team Fortress 2 server easily inside a Docker container, optimized for ARM64 (using box86).

**Supported tags**
-----------------

* `latest` - the most recent production-ready image, based on `sonroyaalmerol/steamcmd-arm64:root`

**Documentation**
----------------

### Ports
The container uses the following ports:
* `:27015 TCP/UDP` as the game transmission, pings and RCON port
* `:27005 UDP` as the client port

### Environment variables

* `TF2_ARGS`: Additional arguments to pass to the server.
* `TF2_CLIENTPORT`: The client port for the server.
* `TF2_IP`: The IP address for the server.
* `TF2_LAN`: Whether the server is LAN-only or not.
* `TF2_MAP`: The map for the server.
* `TF2_MAXPLAYERS`: The maximum number of players allowed to join the server.
* `TF2_PORT`: The port for the server.
* `TF2_SOURCETVPORT`: The Source TV port for the server.
* `TF2_TICKRATE`: The tick rate for the server.

### Directory structure
The following directories and files are important for the server:

```
📦 /home/steam
|__📁tf2-server // The server root (tf folder name using env)
|  |__📁tf
|  |  |__📁cfg
|  |  |  |__⚙️server.cfg
|  |  |__📁maps // Put your maps here
|__📃srcds_run // Script to start the server
|__📃srcds_run-arm64 // Script to start the server on ARM64
```

### Examples

This will start a simple server in a container named `tf2-server`:
```sh
docker run -d --name tf2-server \
  -p 27005:27005/udp \
  -p 27015:27015 \
  -p 27015:27015/udp \
  -e TF2_ARGS="" \
  -e TF2_CLIENTPORT=27005 \
  -e TF2_IP="" \
  -e TF2_LAN="0" \
  -e TF2_MAP="cp_badlands" \
  -e TF2_MAXPLAYERS="12" \
  -e TF2_PORT=27015 \
  -e TF2_SOURCETVPORT="27020" \
  -e TF2_TICKRATE="" \
  -v /home/ponfertato/Docker/tf2-server:/home/steam/tf2-server/tf \
  ponfertato/tf2:latest
```

...or Docker Compose:
```sh
version: '3'

services:
  tf2-server:
    container_name: tf2-server
    restart: unless-stopped
    image: ponfertato/tf2:latest
    tty: true
    stdin_open: true
    ports:
      - "27005:27005/udp"
      - "27015:27015"
      - "27015:27015/udp"
    environment:
      - TF2_ARGS=""
      - TF2_CLIENTPORT=27005
      - TF2_IP=""
      - TF2_LAN="0"
      - TF2_MAP="cp_badlands"
      - TF2_MAXPLAYERS="12"
      - TF2_PORT=27015
      - TF2_SOURCETVPORT="27020"
      - TF2_TICKRATE=""
    volumes:
      - ./tf2-server:/home/steam/tf2-server/tf
```

**Health Check**
----------------

This image contains a health check to continually ensure the server is online. That can be observed from the STATUS column of docker ps

```sh
CONTAINER ID        IMAGE                    COMMAND                 CREATED             STATUS                    PORTS                                                                                     NAMES
e9c073a4b262        ponfertato/tf2            "/home/steam/entry.sh"   21 minutes ago      Up 21 minutes (healthy)   0.0.0.0:27005->27005/udp, 0.0.0.0:27015->27015/tcp, 0.0.0.0:27015->27015/udp   distracted_cerf
```

**License**
----------

This image is under the [MIT license](LICENSE).
