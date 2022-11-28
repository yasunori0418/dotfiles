#!/usr/bin/env bash

## Check for existence of deno.
## No existence then install deno.
if [[ ! $(command -v deno) ]]; then
  # Deno installation for one line script. 
  # Exhibitor: https://deno.land/manual@v1.28.2/getting_started/installation
  curl -fsSL https://deno.land/x/install/install.sh | sh

  # Reload zshenv
  source ~/.zshenv

  echo "Run 'deno --version' and if you can run the command successfully, run the this script again. "

  exit
fi

################################################

# Cache directory of denops shared server.
denops_cache_path=${HOME}/.cache/denops
[[ ! -d ${denops_cache_path} ]] && mkdir -p ${denops_cache_path}

# Cache files of denops shared server.
denops_server_log=${denops_cache_path}/shared_server.log
denops_server_pid=${denops_cache_path}/shared_server.pid

## When not found denops plugin directory, download server files.
dl_server_files() {
  # Where to place files required for denops shared server.
  local dir_denops=${denops_cache_path}/server/@denops
  local dir_denops_private=${denops_cache_path}/server/@denops-private

  # Scripts needed for denops shared server.
  local -A denops_server_files=(
    ["${dir_denops}/denops.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops/denops.ts'
    ["${dir_denops}/mod.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops/mod.ts'
    ["${dir_denops_private}/cli.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/cli.ts'
    ["${dir_denops_private}/defs.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/defs.ts'
    ["${dir_denops_private}/service.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/service.ts'
    ["${dir_denops_private}/tracer.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/tracer.ts'
    ["${dir_denops_private}/tee.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/tee.ts'
    ["${dir_denops_private}/host/base.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/host/base.ts'
    ["${dir_denops_private}/host/invoker.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/host/invoker.ts'
    ["${dir_denops_private}/host/nvim.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/host/nvim.ts'
    ["${dir_denops_private}/host/vim.ts"]='https://raw.githubusercontent.com/vim-denops/denops.vim/main/denops/%40denops-private/host/vim.ts'
  )

  # Download for denops shared server needed scripts.
  for denops_server_file in ${!denops_server_files[@]}; do
    if [[ ! -f ${denops_server_file}  ]]; then
      curl --create-dirs -o ${denops_server_file} -L ${denops_server_files[${denops_server_file}]}
    fi
  done

  # Path of script for starting denops shared server.
  echo "${dir_denops_private}/cli.ts"
}

## Check if a process other than deno is running with the same PID.
# For when the PID file remains
has_started() {
  process=$(ps aux | rg $(cat ${denops_server_pid}) | rg deno)

  if [[ -z ${process} ]]; then
    rm ${denops_server_pid}
  fi
}

## Start denops shared server.
start_server() {
  has_started
  # Don't start multiple shared servers.
  if [[ -f ${denops_server_pid} ]]; then
    echo "Already started denops shared server."
    exit 1
  fi

  # Installated denops plugin by dein.vim.
  local denops_plugin_path=${HOME}/.cache/dein/repos/github.com/vim-denops/denops.vim

  if [[ -d ${denops_plugin_path} ]]; then
    local server_start_script_path="${denops_plugin_path}/denops/@denops-private/cli.ts"
  else
    local server_start_script_path=`dl_server_files`
  fi

  # Redirect stderr to $denops_server_log as stdout.
  deno run -A --no-check --unstable $server_start_script_path >${denops_server_log} 2>&1 &

  # Get pid of denops shared server.
  jobs -l | awk '{print $2}' > ${denops_server_pid}

  echo "Start denops shared server in"
  echo "Port: 127.0.0.1:32123, PID: `cat ${denops_server_pid}`."
  echo "Check ${denops_server_log} for denops shared server logs."
}

## Stop of already started denops shared server.
stop_server() {
  has_started
  if [[ -f ${denops_server_pid} ]]; then
    kill `cat ${denops_server_pid}`
    rm ${denops_server_pid}
    echo "Stoped denops shared server."
  else
    echo "Not found ${denops_server_pid}"
    echo "Started denops shared server?"
    exit 1
  fi
}

if [[ -n $1 ]]; then
  answer=$1
else
  echo "Starting denops shared server?"
  if [[ -f ${denops_server_pid} ]]; then
    echo "Shared server status: Started"
  else
    echo "Shared server status: Stoped"
  fi
  read -p "[Y|n|c] :>" answer
fi

case $answer in
  "" | "on" | "start" | [Yy]* )
    start_server
    ;;
  "off" | "stop" | [Nn]* )
    stop_server
    ;;
  "Cancel" | [Cc]* )
    echo "Aborted this script."
    exit 1
    ;;
  "--help" | "-h" )
    echo "help text"
    ;;
esac

# vim:ft=bash
