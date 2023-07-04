.DEFAULT_GOAL := help

.PHONY := help
# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## makeコマンドのサブコマンドリストと、各コマンドの説明を表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## cloneしたら最初に実行すると幸せになれます…。
	@bash bin/install.sh
