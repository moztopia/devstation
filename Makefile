# Variables
BACKEND_DIR = backend
FRONTEND_DIR = frontend

#
# All the targets need to be listed as phony otherwise make will not execute them
# if the target happens to match a filename in the current folder.
#
.PHONY: help ps fresh build start stop destroy tests tests-html migrate \
	migrate-fresh migrate-tests-fresh install-xdebug init create-env \
	migrate-fresh-seed

CONTAINER_PHP=php-8-3

help: ## Display this help.
	@echo "Usage: make \033[36m<target>\033[0m"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST) | sort

ps: ## Show containers.
	@docker compose ps

# fresh: stop destroy build start ## Destroy & recreate all containers.

# build: create-env ## Build all containers.
build: ## Build all containers.
	@docker compose build --no-cache

# start: create-env ## Start all containers.
start: ## Start all containers.
	@docker compose up --force-recreate -d

install:  ## Create database, install dependencies and starts your containers.
	@test -e $(BACKEND_DIR)/.env || cp $(BACKEND_DIR)/.env.example $(BACKEND_DIR)/.env
#   @echo "copying .env.example to .env"
#	@chmod ugo+rw .docker/mssql/mssqlsystem
#	@chmod ugo+rw .docker/mssql/mssqluser
	@$(MAKE) .env
	@$(MAKE) backend
	@$(MAKE) frontend
	@$(MAKE) start
#
# The following creates a file that matches (technically is) this make target.
# This will prevent you from accidentaly re-running install.
# If you want to run install again, you must first delete the file named "install".
#
	@touch install

.env: ## Create .env file for docker-compose.yml
	@echo "#" > .env
	@echo "# This file is generated by Makefile using" >> .env
	@echo "#    make .env" >> .env
	@echo "# You can edit this file but:" >> .env
	@echo "#    * it is ignored by git. We don't want it in source control" >> .env
	@echo "#    * better to delete it and run make .env to create it again" >> .env
	@echo "#" >> .env
	@echo "# We use it to get your User ID and Group ID" >> .env
	@echo "# and pass them to the docker containers so that they run as you." >> .env
	@echo "#" >> .env
	@echo "USER_ID=$(shell id -u)" >> .env
	@echo "GROUP_ID=$(shell id -g)" >> .env

.PHONY: backend
backend: # Update backend dependencies
	@cd $(BACKEND_DIR) && \
		composer install && \
		php artisan key:generate

# Update frontend dependencies
.PHONY: frontend
frontend:
	@echo "updating all npm dependencies..."
	@cd $(FRONTEND_DIR) && \
		npm install

# stop: create-env ## Stop all containers.
stop: ## Stop all containers.
	@docker compose down

# destroy: create-env stop ## Destroy all containers.
# 	@docker compose down
# 	@if [ "$(shell docker volume ls --filter name=${VOLUME_DATABASE} --format {{.Name}})" ]; then \
# 		docker volume rm ${VOLUME_DATABASE}; \
# 	fi

# 	@if [ "$(shell docker volume ls --filter name=${VOLUME_DATABASE_TESTING} --format {{.Name}})" ]; then \
# 		docker volume rm ${VOLUME_DATABASE_TESTING}; \
# 	fi

# tests: ## Run all tests.
# 	docker exec ${CONTAINER_PHP} ./vendor/bin/phpunit

# tests-html: ## Run tests + generate coverage.
# 	docker exec ${CONTAINER_PHP} php -d zend_extension=xdebug.so -d xdebug.mode=coverage ./vendor/bin/phpunit --coverage-html reports

migrate: ## Run migration files.
	docker exec ${CONTAINER_PHP} php artisan migrate

migrate-fresh: ## Clear database and run all migrations.
	docker exec ${CONTAINER_PHP} php artisan migrate:fresh

migrate-fresh-seed: ## Clear database and run all migrations and seeders.
	docker exec ${CONTAINER_PHP} php artisan migrate:fresh --seed

# migrate-tests-fresh: ## Clear database and run all migrations.
# 	docker exec ${CONTAINER_PHP} php artisan --env=testing migrate:fresh
