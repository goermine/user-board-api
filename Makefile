SHELL := /bin/bash
PROJECT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
## root folder accessible to all servers in swarm
SHARED_ROOT:= /mnt/beegfs

.PHONY: help install deploy

help: ## This help message

	@echo "Usage: make <commans>"
	@echo "Commands:"
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

install: ## Install application

	docker-compose -f ${PROJECT_DIR}/docker-compose.yml down -v --remove-orphans
	docker-compose -f ${PROJECT_DIR}/docker-compose.yml up -d --build
	docker-compose exec storehouse-api rake db:create
	docker-compose exec storehouse-api rake db:migrate

clean: #CleanUp applicaion 

	docker-compose -f ${PROJECT_DIR}/docker-compose.yml down
