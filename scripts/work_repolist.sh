#!/usr/bin/env bash

export GHQ_ROOT=${HOME}/work
gist_id=$(\
        gh gist list \
        | rg work_repolist \
        | awk -F ' ' '{print $1}' \
    )
readonly gist_id

if [[ ${1} == 'view' ]]; then
    gh gist view "${gist_id}"
else
    gh gist view "${gist_id}" | ghq get -p -u --parallel
fi
