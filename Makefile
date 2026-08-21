RULE_REGEX := ^[a-zA-Z_][a-zA-Z0-9_-]+:
RULE_AND_DESC_REGEX := $(RULE_REGEX).*?## .*$$
EXTRA_COMMENT_REGEX := ^## .* ##$$
.ONESHELL:
.DEFAULT_GOAL := help
.PHONY: all test clean
.PHONY: $(shell grep -E $(RULE_REGEX) $(MAKEFILE_LIST) | cut -d: -f1)

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

nvim-update: ## DppUpdateAndClose
	@nvim -c DppUpdateAndClose

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

path: ## List up for $PATH
	@printenv \
	| rg '^PATH' \
	| sed -e 's/PATH=//' \
	| sed -e 's/:/\n/g'

zsh-bench: ## zsh bench mark with hyperfine used.
	@hyperfine -w 5 -r 100  'zsh -i -c exit'

## NixOS utility commands ##
nixos: ## nixos-rebuild switch --flake .
	@sudo nixos-rebuild switch --flake .

nix-home-%: ## nix run "nixpkgs#home-manager" -- switch --flake ".#"%(linux | macos)
	@nix run "nixpkgs#home-manager" -- -b hm_backup switch --flake ".#"${@:nix-home-%=%}

nix-gc: ## nix-collect-garbage -d
	@nix-collect-garbage -d

nix-darwin: ## nix run nix-darwin -- switch --flake .
	@nix run 'nix-darwin/master#darwin-rebuild' -- switch --flake .

nix-rebuild: ## nixos or nix-darwin rebuild switch
	@./scripts/nix-rebuild.sh

nixos-generate: ## nixos-generator
	@nix run 'nixpkgs#nixos-generators' -- --flake '.#iso' -f iso | xargs -I{} ln -svf {} ./

## nput placement commands ##
# nput.default（home mode）は home-manager の activation と同じ profile 名 `default`
# を共有する。よって switch を挟まずに CLI から配置を反映できる。
nput-apply: ## nput apply default (home mode placement without home-manager switch)
	@nput apply default --verbose

# recopy は ~/.claude/settings.json を Nix 生成の JSON に戻すので、
# 環境固有に注入した値（claude-settings-inject）はそのたびに消える。
# 消えた状態を残さないため recopy に続けて注入し直す。
nput-recopy: ## nput apply default --recopy (re-copy copy targets e.g. ~/.claude/settings.json)
	@nput apply default --recopy --verbose
	@$(MAKE) --no-print-directory claude-settings-inject

nput-dryrun: ## nput apply default --dryrun (preview placement, no side effects)
	@nput apply default --dryrun --verbose

nput-skills: ## nput apply skills (project mode placement into .claude/skills)
	@nput apply skills --verbose

nput-gitignore: ## nput gitignore --all (print project mode placement targets)
	@nput gitignore --all

nput-generations: ## nput list-generations default
	@nput list-generations default

nput-rollback: ## nput rollback default (roll back to the previous generation)
	@nput rollback default --verbose

## Claude Code settings injection commands ##
# ~/.claude/settings.json へ環境固有の値を注入する。
# 注入する値はこの環境にしか存在しないため ~/.claude/inject/ に置き、
# このターゲットはそこにある *.json を settings.json へマージするだけ。
# home-manager の activation も同じスクリプトを呼ぶので、switch を挟まずに
# 注入だけやり直したいときはこれを叩けばよい。
claude-settings-inject: ## inject env-specific values into ~/.claude/settings.json (no-op if not set up)
	@./scripts/claude-settings-inject.sh

## herdr plugin commands ##
# nput が配置した ~/.local/share/herdr-plugins/* を herdr のレジストリへ登録する。
# home-manager の activation も同じスクリプトを呼ぶので、switch を挟まずに
# `make nput-apply` で配置だけ差し替えたときはこれを続けて叩けば反映できる。
herdr-plugin-link: ## register placed herdr plugins into herdr's registry
	@./scripts/herdr-plugin-link.sh

## Environment Setup Tools ##
nix-install: ## Install nix.
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
