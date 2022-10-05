#!/bin/sh
groupadd --gid 10000 formation
mkdir -p /documents/travail
useradd --home-dir /documents/travail --gid 10000 --uid 10000 --shell /bin/bash formation
chown -R formation:formation /documents/travail
chmod -R 755 /documents/travail
