#!/usr/bin/env bash

export ghq_root=${HOME}/work
declare -r gist_id=$(\
  gh gist list \
  | rg work_repolist \
  | awk -F ' ' '{print $1}' \
)

if [[ ${1} == 'view' ]]; then
  gh gist view ${gist_id}
else
  gh gist view ${gist_id} | ghq get -p -u --parallel
fi
