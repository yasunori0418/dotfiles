.PHONY: all test clean
.DEFAULT_GOAL := help
MAKEFLAGS += --always-make
RULE_AND_DESC_REGEX := ^[%a-zA-Z_-]+:.*?## .*$$
EXTRA_COMMENT_REGEX := ^## .* ##$$

# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## subcommand list and description.
	@grep -E -e $(RULE_AND_DESC_REGEX) -e $(EXTRA_COMMENT_REGEX) $(MAKEFILE_LIST) \
	| ./scripts/help.awk | less -R

help-fzf: ## Search for fzf and run the target rule
	@grep -E -e $(RULE_AND_DESC_REGEX) $(MAKEFILE_LIST) \
	| ./scripts/help.awk \
	| fzf --ansi \
	| cut -d ' ' -f1 \
	| xargs -I{} make {}

## Neovim Tools ##
nvim-bench: ## neovim bench mark with vim-startuptime used.
	-@vim-startuptime -vimpath nvim -count 100 | head -6

## Arch Linux System Package Management ##
arch_iso: ## Download Arch Linux iso image at latest, and verification.
	@./scripts/arch_iso.sh

## vi-sual studio code... ##
vscode-setup: ## install extensions and expand settings.json for mac or linux.
	@./scripts/vscode-setup.sh

vscode-ext: ## update installed vscode extensions list.
	@code --list-extensions | tee ${HOME}/dotfiles/vscode/extensions.txt

vscode-byebye: ## Uninstall VSCode extensions and unlink settings.json
	@./scripts/vscode-byebye.sh

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

## NixOS utility commands ##
nixos-%: ## nixos-rebuild switch --flake ".#"%(laptop | desktop | macx64OrbStack)
	@sudo nixos-rebuild switch --flake ".#"${@:nixos-%=%}

nix-home-%: ## nix run "nixpkgs#home-manager" -- switch --flake ".#"%(linux | macx64)
	@nix run "nixpkgs#home-manager" -- -b hm_backup switch --flake ".#"${@:nix-home-%=%}

nix-gc: ## nix-collect-garbage -d
	@nix-collect-garbage -d

## Environment Setup Tools ##
nix-install: ## Install nix.
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
