NAME := inception

WORDPRESS_PATH := /home/$(USER)/data/wordpress
MARIADB_PATH := /home/$(USER)/data/mariadb
DOCKER_COMPOSE_PATH := srcs/docker-compose.yml

.PHONY: all
all: prepare build up

# Colors for help message
BLUE := \033[36m
NC := \033[0m

.PHONY: prepare
prepare:  ## prep folders
	@mkdir -p ${WORDPRESS_PATH}
	@mkdir -p ${MARIADB_PATH}
	@echo "Data directories created with correct permissions."

.PHONY: build
build:  ## build all containers
	@docker-compose -f ${DOCKER_COMPOSE_PATH} build
	@echo "Docker images built successfully."

.PHONY: up
up:  ## start all containers
	@docker-compose -f ${DOCKER_COMPOSE_PATH} up -d
	@echo "Services started in detached mode."

.PHONY: down
down:  ## stop containers
	@docker-compose -f srcs/docker-compose.yml down
	@echo "Services stopped."

.PHONY: clean
clean: down  ## stop and remove container and other data
	@docker system prune -af
	@echo "Environment cleaned."

.PHONY: re
re: clean all  ## make clean build

.PHONY: ps
ps:  ## get status
	@docker-compose -f ${DOCKER_COMPOSE_PATH} ps

.PHONY: logs
logs:  ## check logs
	@docker-compose -f ${DOCKER_COMPOSE_PATH} logs

.PHONY: help
help:  ## Get help
	@echo -e 'Usage: make ${BLUE}<target>${NC}'
	@echo -e 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${BLUE}%-15s${NC} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
