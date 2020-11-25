ifndef _include_git_mk
_include_git_mk = 1

include makefiles/shared.mk

.PHONY: git-dirty git-hooks

git-dirty: ## Check for uncommited changes
	$(info $(_bullet) Checking for uncommited changes)
	git status --porcelain
	git diff --quiet --exit-code

git-hooks: ## Configure git hooks
	$(info $(_bullet) Configuring git hooks)
	git config core.hooksPath .githooks

endif