#!/usr/bin/env bash

set -euo pipefail

TMUX_PLUGIN_MANAGER_PATH=$(tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -d '=' -f2)
readonly TMUX_PLUGIN_MANAGER_PATH

if [[ ! -d ${TMUX_PLUGIN_MANAGER_PATH}/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm.git "${TMUX_PLUGIN_MANAGER_PATH}/tpm"
fi

"${TMUX_PLUGIN_MANAGER_PATH}/tpm/tpm" > /dev/null
"${TMUX_PLUGIN_MANAGER_PATH}/tpm/bin/install_plugins" > /dev/null
