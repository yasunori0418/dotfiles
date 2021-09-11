#!/bin/bash

yaskkserv2 \
    --no-deamonize \
    --google-japanese-input=notfound \
    --google-suggest \
    --google-cache-filename=/tmp/yaskkserv2.cache \
    /tmp/dictionary.yaskkserv2

