#!/bin/sh
set -e
cd "$(dirname "$0")/.."
exec tools/bootstrap/javascript.sh modular_abel/tools/prepare_dun_world_map.ts
