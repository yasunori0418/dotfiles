#!/bin/bash

yaskkserv2 \
    --google-japanese-input notfound \
    --google-suggest \
    --google-cache-filename ~/.skk/yaskkserv2.dict/cache.dict \
    --port 1178 \
    ~/.skk/yaskkserv2.dict/base.dict
