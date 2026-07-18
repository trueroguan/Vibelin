#!/bin/sh
set -e
cd "$(dirname "$0")"
exec modular_abel/build.sh build "$@"
