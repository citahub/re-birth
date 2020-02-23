.DEFAULT_GOAL:=help
SHELL = /bin/sh

# main receipts
.PHONY: deps build clean help
# receipts for Code Quality
.PHONY: code-quality lint-ruby-code format-ruby-code lint-shell-code format-shell-code
# receipts for Testing
.PHONY: test test-unit test-intergration
# receipts for Release
.PHONY: changelog changelog-check changelog-auto

.SILENT: help

##@ Helpers

help:  ## Display help message.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# run this command for first time
setup:
	docker-compose build
	docker-compose run --rm app bundle exec rake db:setup

# build images
build:
	docker-compose build

# run app daemon
up:
	@mkdir -p tmp/pids
	docker-compose up -d

# run app
start:
	@mkdir -p tmp/pids
	docker-compose up

# stop app
down:
	docker-compose down

# run after update repo
update:
	docker-compose build
	docker-compose run --rm app bundle exec rake db:migrate

# enter rails console
console:
	docker-compose run --rm app rails console

ps:
	docker-compose ps

##@ Release
changelog-check:
	# check local branch
	@git_tags_count=$(shell git log --oneline --decorate | grep "tag:" | wc -l | bc) ; \
		if [ $${git_tags_count} == 0 ]; then \
			echo "No git tags found on current branch, please follow these steps:" ;\
			echo "1. $$ git checkout master" ;\
			echo "2. $$ git checkout -b update-changelog" ;\
			echo "3. $$ git merge develop --no-edit" ;\
			echo "4. $$ make changelog" ;\
			echo "or just run $$ make changelog-auto" ;\
			exit 1 ;\
		fi

changelog: changelog-check ## Generate CHANGELOG.md from git logs.
	$(info How do I make a good changelog? https://keepachangelog.com)
	# auto install git-changelog
	@git-changelog -v || pip3 install git-changelog
	@OUTPUT=CHANGELOG.md ;\
		git-changelog --style basic --template "path:devtools/release/keepachangelog-template" -o $${OUTPUT} . ;\
		git diff $${OUTPUT} ;\
		open $${OUTPUT} ;\
		echo "Edit $${OUTPUT} to keep notable changes"

changelog-auto: ## Auto generate CHANGELOG.md
	$(info Generate CHANGELOG.md in one step)
	git checkout master
	if git show-ref --verify --quiet "refs/heads/update-changelog"; then \
		echo "Found update-changelog, auto delete it." ;\
		git branch -D update-changelog ;\
	fi
	git checkout -b update-changelog
	git merge develop --no-edit
	@$(MAKE) changelog
