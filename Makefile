.DEFAULT_GOAL := help

.PHONY := help
# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## subcommand list and description.
	@grep -E \
	'^[a-zA-Z_-]+:.*?## .*$$' \
	$(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# cloneしたら最初に実行すると幸せになれます…。
init: ## expand config files.
	@bash ./scripts/install.sh

nvim: ## building neovim head.
	@./scripts/nvim_make.sh

true_color: ## 24-bit-color.sh
	@curl -s \
	https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh \
	| bash
	@./scripts/termcolors

arch_iso: ## Download Arch Linux iso image at latest, and verification.
	@./scripts/arch_iso.sh

rtx: ## Download rtx of Polyglot runtime manager.
	@./scripts/rtx_install.sh

pkglist: ## Update Arch Linux package list.
	@./scripts/update_pkglist.sh

path: ## List up for $PATH
	@printenv \
	| rg '^PATH' \
	| sed -e 's/PATH=//' \
	| sed -e 's/:/\n/g'
