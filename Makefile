.PHONY: all test clean
.DEFAULT_GOAL := help
MAKEFLAGS += --always-make
AQUA_INSTALLER_HASH := fb4b3b7d026e5aba1fc478c268e8fbd653e01404c8a8c6284fdba88ae62eda6a
RULE_AND_DESC_REGEX := ^[%a-zA-Z_-]+:.*?## .*$$
EXTRA_COMMENT_REGEX := ^## .* ##$$

# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## subcommand list and description.
	@grep -E -e $(RULE_AND_DESC_REGEX) -e $(EXTRA_COMMENT_REGEX) $(MAKEFILE_LIST) \
	| ./scripts/help.awk

help-fzf: ## Search for fzf and run the target rule
	@grep -E -e $(RULE_AND_DESC_REGEX) $(MAKEFILE_LIST) \
	| ./scripts/help.awk \
	| fzf --ansi \
	| cut -d ' ' -f1 \
	| xargs -I make {}

## Neovim Tools ##
nvim-build: ## building neovim head.
	@./scripts/nvim_build.sh

nvim-%: ## download neovim at version %(nightly|stable) build.
	@./scripts/nvim_dl.sh ${@:nvim-%=%}

nvim-bench: ## neovim bench mark with vim-startuptime used.
	-@vim-startuptime -vimpath nvim -count 100 | head -6

## Arch Linux System Package Management ##
arch_iso: ## Download Arch Linux iso image at latest, and verification.
	@./scripts/arch_iso.sh

pkglist: ## Update Arch Linux package list.
	@./scripts/update_pkglist.sh

## vi-sual studio code... ##
vscode-setup: ## install extensions and expand settings.json for mac or linux.
	@./scripts/vscode-setup.sh

vscode-ext: ## update installed vscode extensions list.
	@code --list-extensions > ${HOME}/dotfiles/vscode/extensions.txt
	@cat ${HOME}/dotfiles/vscode/extensions.txt

## Utility Commands ##
true-color: ## 24-bit-color.sh
	@curl -s \
	https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh \
	| bash
	@./scripts/termcolors

path: ## List up for $PATH
	@printenv \
	| rg '^PATH' \
	| sed -e 's/PATH=//' \
	| sed -e 's/:/\n/g'

zsh-bench: ## zsh bench mark with hyperfine used.
	@hyperfine -w 5 -r 100  'zsh -i -c exit'

repolist: ## Update ghq management of repository list.
	@ghq list > ./document/repolist.txt

repoget: ## Get and update ghq management repositories.
	@cat ./document/repolist.txt | ghq get -p -u --parallel

work_repolist: ## Update ghq management of repository list.
	@./scripts/work_repolist.sh view

work_repoget: ## Get and update ghq management repositories.
	@./scripts/work_repolist.sh

## Environment Setup Tools ##
aqua-install: ## Install aqua
	@curl -sSfLo /tmp/aqua-installer https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer
	@echo "$(AQUA_INSTALLER_HASH) /tmp/aqua-installer" | sha256sum -c
	@bash /tmp/aqua-installer

nix-install: ## Install nix.
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

symlink: ## expand symlinks
	@./scripts/expand_symlink.sh

mkdir: ## make direcotries of required
	@mkdir -p ${HOME}/.local/bin
	@mkdir -p ${HOME}/.local/dotfiles
	@mkdir -p ${HOME}/.config
	@mkdir -p ${HOME}/.cache

init: ## expand config files. ※WARNING: Execute when Initial setup only!!
	@make mkdir
	@make symlink
	@make aqua-install
	@./scripts/setup.sh
