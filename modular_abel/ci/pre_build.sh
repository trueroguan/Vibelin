#!/bin/sh
set -e
cd "$(dirname "$0")/../.."
modular_abel/prepare_map.sh
exec tools/bootstrap/javascript.sh modular_abel/tools/runtime_config.ts
