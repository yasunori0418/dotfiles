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

nixos-iso: ## nixos-rebuild build-image --image-variant iso-installer --flake .#iso
	@nixos-rebuild build-image --image-variant iso-installer --flake '.#iso'

## layat placement commands ##
# home mode の profile（home / desktop / nvim / claude / claude-settings / herdr-plugins）は
# home-manager の activation と同じ profile 名を共有する（home-manager/layat/entries.nix が
# 両経路の SSOT）。よって switch を挟まずに CLI から配置を反映できる。
# P=<profile> で 1 profile に絞る（例: make layat-apply P=claude）。未指定なら
# home mode の全 profile（--all --home-root。project mode の skills は含まない）。
LAYAT_TARGET = $(if $(P),$(P),--all --home-root)
define layat-require-profile
test -n "$(P)" || { echo "P=<profile> is required (e.g. make $@ P=claude)" >&2; exit 2; }
endef

layat-apply: ## layat apply [P=<profile>] (home mode placement without home-manager switch)
	@layat apply $(LAYAT_TARGET) --verbose

# recopy は ~/.claude/settings.json を Nix 生成の JSON に戻すので、
# 環境固有に注入した値（claude-settings-inject）はそのたびに消える。
# 消えた状態を残さないため recopy に続けて注入し直す。
# copy entry は claude-settings profile にしか無いので対象をそこに固定する。
# 実行前に何が変わるかは make claude-settings-diff で確認できる。
# 注入は $(MAKE) 経由ではなくスクリプトを直接呼ぶ。.ONESHELL の recipe に $(MAKE) が
# 含まれると GNU make は `make -n` でも recipe 全体を実行してしまい、recopy が走る。
layat-recopy: ## layat apply claude-settings --recopy (re-copy ~/.claude/settings.json, then inject)
	@layat apply claude-settings --recopy --verbose
	./scripts/claude-settings-inject.sh

layat-dryrun: ## layat apply [P=<profile>] --dryrun (preview placement, no side effects)
	@layat apply $(LAYAT_TARGET) --dryrun --verbose

layat-skills: ## layat apply skills (project mode placement into .claude/skills)
	@layat apply skills --verbose

layat-gitignore: ## layat gitignore --all (print project mode placement targets)
	@layat gitignore --all

layat-generations: ## layat list-generations P=<profile> (P is required)
	@$(layat-require-profile)
	layat list-generations $(P)

layat-rollback: ## layat rollback P=<profile> (P is required; roll back to the previous generation)
	@$(layat-require-profile)
	layat rollback $(P) --verbose

## Claude Code settings injection commands ##
# ~/.claude/settings.json へ環境固有の値を注入する。
# 注入する値はこの環境にしか存在しないため ~/.claude/inject/ に置き、
# このターゲットはそこにある *.json を settings.json へマージするだけ。
# home-manager の activation も同じスクリプトを呼ぶので、switch を挟まずに
# 注入だけやり直したいときはこれを叩けばよい。
claude-settings-inject: ## inject env-specific values into ~/.claude/settings.json (no-op if not set up)
	@./scripts/claude-settings-inject.sh

# make layat-recopy が ~/.claude/settings.json をどう書き換えるかを事前に確認する。
# Nix 生成 JSON + inject の断片を重ねた「recopy 後の姿」と現行をキーパス単位で比較し、
# TUI が書き戻して recopy で消える項目を洗い出す。差分があれば exit 1。
claude-settings-diff: ## preview key-level diff of ~/.claude/settings.json against `make layat-recopy` result
	@./scripts/claude-settings-diff.sh

## Claude Code MCP server commands ##
# layat が配置した ~/.claude/mcp-servers.json の定義を user スコープ（~/.claude.json）へ登録する。
# home-manager の activation も同じスクリプトを呼ぶので、switch を挟まずに
# `make layat-apply` で定義だけ差し替えたときはこれを続けて叩けば反映できる。
claude-mcp-register: ## register MCP servers from ~/.claude/mcp-servers.json into user scope
	@./scripts/claude-mcp-register.sh

## herdr plugin commands ##
# layat が配置した ~/.local/share/herdr-plugins/* を herdr のレジストリへ登録する。
# home-manager の activation も同じスクリプトを呼ぶので、switch を挟まずに
# `make layat-apply` で配置だけ差し替えたときはこれを続けて叩けば反映できる。
herdr-plugin-link: ## register placed herdr plugins into herdr's registry
	@./scripts/herdr-plugin-link.sh

## Environment Setup Tools ##
nix-install: ## Install nix.
	@curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
