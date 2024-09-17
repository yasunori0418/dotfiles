#!/usr/bin/env bash

set -euo pipefail

[[ ! $(command -v code) ]] && echo "Not installed Visual Studio Code!" && exit 1

timestamp=$(date +%Y%m%d%H%M%S)
readonly timestamp
declare -r VSCODE_CONF="${HOME}/dotfiles/vscode"
declare -r EXTENSIONS="${VSCODE_CONF}/extensions.txt"
declare -r OUT_LOG="${VSCODE_CONF}/logs/install_extensions-${timestamp}.out.log"
declare -r ERR_LOG="${VSCODE_CONF}/logs/install_extensions-${timestamp}.err.log"

echo "${timestamp} Execute : code --install-extension {extension_name} --force"
while IFS= read -r line; do
    echo "extension: ${line}"
    code --install-extension "${line}" --force \
        1>> "${OUT_LOG}" \
        2>> "${ERR_LOG}"
done < "${EXTENSIONS}"

echo "================================"
echo "Done VSCode install extensions."
echo "Exported install log files."
ls -l "${VSCODE_CONF}/logs"
echo "================================"
