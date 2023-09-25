.DEFAULT_GOAL := help

.PHONY := help
# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## subcommand list and description.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY := nvim-build
nvim-build: ## building neovim head.
	@./scripts/nvim_build.sh

.PHONY := nvim-night
nvim-night: ## download neovim at version nightly build.
	@./scripts/nvim_night.sh

.PHONY := true-color
true-color: ## 24-bit-color.sh
	@curl -s \
	https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh \
	| bash
	@./scripts/termcolors

.PHONY := zsh-bench
zsh-bench: ## zsh bench mark with hyperfine used.
	@hyperfine -w 5 -r 50 'zsh -i -c exit'

.PHONY := nvim-bench
nvim-bench: ## neovim bench mark with vim-startuptime used.
	@vim-startuptime -vimpath nvim -count 100 | head -6

.PHONY := arch_iso
arch_iso: ## Download Arch Linux iso image at latest, and verification.
	@./scripts/arch_iso.sh

.PHONY := pkglist
pkglist: ## Update Arch Linux package list.
	@./scripts/update_pkglist.sh

.PHONY := path
path: ## List up for $PATH
	@printenv \
	| rg '^PATH' \
	| sed -e 's/PATH=//' \
	| sed -e 's/:/\n/g'

.PHONY := repolist
repolist: ## Update ghq management of repository list.
	@ghq list > ./document/repolist.txt

.PHONY := repoget
repoget: ## Get and update ghq management repositories.
	@cat ./document/repolist.txt | ghq get -p -u --parallel

.PHONY := work_repolist
work_repolist: ## Update ghq management of repository list.
	@./scripts/work_repolist.sh view

.PHONY := work_repoget
work_repoget: ## Get and update ghq management repositories.
	@./scripts/work_repolist.sh

.PHONY := init
init: ## expand config files.
	@mkdir -p ${HOME}/.local/bin
	@mkdir -p ${HOME}/.local/dotfiles
	@./scripts/rtx_install.sh
	@./scripts/get_modules.sh
	@ln -snvf ~/dotfiles/home/.??* ~/
	@ln -snvf ~/dotfiles/bin ~/
	@ln -snvf ~/dotfiles/config/* ~/.config/
