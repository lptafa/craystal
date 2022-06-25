#!/usr/bin/env bash
set -xe

crystal build --release -Dpreview_mt ./src/main.cr
CRYSTAL_WORKERS=8 time ./main "$@"
