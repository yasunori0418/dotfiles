RULE_REGEX := ^[a-zA-Z_][a-zA-Z0-9_-]+:
RULE_AND_DESC_REGEX := $(RULE_REGEX).*?## .*$$
EXTRA_COMMENT_REGEX := ^## .* ##$$
.ONESHELL:
.DEFAULT_GOAL := help
.PHONY: $(shell grep -E $(RULE_REGEX) $(MAKEFILE_LIST) | cut -d: -f1)

DOTFILES_ROOT := $(shell git -C $(dir $(firstword $(MAKEFILE_LIST))) rev-parse --show-toplevel 2>/dev/null)
HELP_AWK := $(DOTFILES_ROOT)/scripts/help.awk

help: ## subcommand list and description.
	@grep -E -e $(RULE_AND_DESC_REGEX) -e $(EXTRA_COMMENT_REGEX) $(MAKEFILE_LIST) \
	| $(HELP_AWK) | less -R

## Tests ##
test: ## Run all *.test.sh under scripts/*/tests/
	@failed=0
	total=0
	for tests_dir in scripts/*/tests; do
	  [ -d "$$tests_dir" ] || continue
	  for t in "$$tests_dir"/*.test.sh; do
	    [ -f "$$t" ] || continue
	    total=$$((total+1))
	    "$$t" || failed=$$((failed+1))
	  done
	done
	echo
	if [ $$failed -eq 0 ]; then
	  echo "All $$total test(s) passed."
	else
	  echo "$$failed of $$total test(s) failed."
	  exit 1
	fi

dry-run: ## cchook dry-run for the Stop event
	@echo '{}' | cchook -command dry-run -event Stop
