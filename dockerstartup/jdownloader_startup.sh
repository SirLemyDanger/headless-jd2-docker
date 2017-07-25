#!/bin/bash
### every exit != 0 fails the script
set -e

chown -R 1100:1100 /opt/JDownloader/cfg

exec "dockerstartup/vnc_startup $@"