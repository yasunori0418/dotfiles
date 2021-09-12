#!/bin/bash

yaskkserv2 \
    --google-japanese-input=notfound \
    --google-suggest \
    --google-cache-filename=/tmp/yaskkserv2.cache \
    --port 1178 \
    /tmp/dict.base.yaskkserv2
