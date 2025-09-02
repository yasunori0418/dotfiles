#!/usr/bin/env bash

set -euo pipefail

# Read JSON input from stdin
input=$(cat)
readonly input

# Extract data from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
readonly current_dir
model_name=$(echo "$input" | jq -r '.model.display_name')
readonly model_name
session_id=$(echo "$input" | jq -r '.session_id')
readonly session_id
ccusage=$(echo "$input" | npx ccusage@latest statusline)
readonly ccusage

# Color definitions (using tput like your original bashrc)
FG_RED=$(tput setaf 1)
FG_BLUE=$(tput setaf 4)
FG_MAGENTA=$(tput setaf 5)
FG_WHITE=$(tput setaf 7)
RESET=$(tput sgr0)
BOLD=$(tput bold)

# Format current directory (replace HOME with ~)
formatted_dir="${current_dir//HOME/~}"
left_part="${FG_BLUE}${BOLD}${formatted_dir}${RESET}:${session_id}${FG_WHITE}${RESET}"

# Format user and hostname (right side info)
user_name="${FG_RED}$(whoami)${RESET}"
host_name="${FG_RED}$(hostname -s)${RESET}"
time_stamp="${FG_MAGENTA}$(date +"%Y-%m-%d_%T")${RESET}"
right_part="${user_name}@${host_name} ${time_stamp}"

# Combine all parts
echo "${left_part}${ccusage} | ${model_name} | ${right_part}"
