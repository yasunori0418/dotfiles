#!/usr/bin/env bash

set -euo pipefail

declare -r entries_dir="/boot/loader/entries"
declare -r nixos="/boot/EFI/nixos"

latest_loader_entry=$(find "${entries_dir}" -type f \
        | sed -r "s|${entries_dir}/nixos-generation-([0-9]+)\.conf|\1|" \
        | sort -nr \
        | head -1 \
    | xargs -I{} echo "${entries_dir}/nixos-generation-{}.conf")
readonly latest_loader_entry

printf "latest loader entry: %s\n\n" "${latest_loader_entry}"

keep_files=$(grep -e '^linux' -e '^initrd' "${latest_loader_entry}" | cut -d ' ' -f2 | sed 's/^/\/boot&/')
readonly keep_files

printf "Kernel and initrd to keep.\nList below: \n%s\n\n" "${keep_files}"

remove_files=$(find "${nixos}" -type f | grep -Fvxf <(echo "${keep_files}"))
readonly remove_files

printf "remove want files: \n%s\n\n" "${remove_files}"

[[ $(id -u) -ne 0 ]] && printf "Please use \"sudo\".\nCurrently does not super user.\n" && exit 1

save_dir="/trashed_kernel"
[[ ! -d "${save_dir}" ]] && mkdir "${save_dir}"

echo "${remove_files}" | xargs -I{} mv {} "${save_dir}/"
