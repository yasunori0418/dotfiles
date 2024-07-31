#!/usr/bin/env bash

set -euo pipefail

timestamp=$(date +%Y%m%d%H%M%S)
readonly timestamp
declare -r VSCODE_CONF="${HOME}/dotfiles/vscode"
declare -r EXTENSIONS="${VSCODE_CONF}/extensions.txt"
declare -r OUT_LOG="${VSCODE_CONF}/logs/uninstall_extensions-${timestamp}.out.log"
declare -r ERR_LOG="${VSCODE_CONF}/logs/uninstall_extensions-${timestamp}.err.log"

declare -r LINUX="${HOME}/.config/Code/User"
declare -r MAC="${HOME}/Library/Application Support/Code/User"

echo "${timestamp} Execute : code --uninstall-extension {extension_name}"
code --list-extensions > "${EXTENSIONS}"

declare -r dump_file="/tmp/remove-extension"
while [[ $(code --list-extensions | wc -l) -gt 0 ]]; do
  code --list-extensions \
  | head -1 \
  | tee "${dump_file}" \
  | xargs -I{} code --uninstall-extension {} \
  1>> "${OUT_LOG}" \
  2>> "${ERR_LOG}"
  echo "uninstalled extension: $(cat ${dump_file})"
done

echo "================================"
echo "Done VSCode uninstall extensions."
echo "Exported uninstall log files."
ls -l "${VSCODE_CONF}/logs"
echo "================================"

if [[ $(uname -s) = 'Linux' ]]; then
  unlink "${LINUX}/settings.json"
  echo "unlinked: ${LINUX}/settings.json"
  ls -l "${LINUX}"
  exit 0
fi

if [[ $(uname -s) = 'Darwin' ]]; then
  unlink "${MAC}/settings.json"
  echo "unlinked: ${MAC}/settings.json"
  ls -l "${MAC}"
  exit 0
fi
