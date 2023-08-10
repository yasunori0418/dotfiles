.DEFAULT_GOAL := help

.PHONY := help
# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## subcommand list and description.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# cloneしたら最初に実行すると幸せになれます…。
init: ## expand config files.
	@bash script/install.sh

nvim: ## building neovim head.
	@./script/nvim_make.sh
	@sudo ./script/nvim_install.sh
