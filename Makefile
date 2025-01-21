NAME = inception

.PHONY: all
all: prepare build up

# Colors for help message
BLUE := \033[36m
MARGENTA := \033[35m
NC := \033[0m

.PHONY: prepare
prepare:  ## prep folders
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	# mkdir -p /Users/luxesound/data/wordpress
	# mkdir -p /Users/luxesound/data/mariadb
	@echo "Data directories created with correct permissions."

.PHONY: build
build:  ## build all containers
	@docker-compose -f srcs/docker-compose.yml build
	@echo "Docker images built successfully."

.PHONY: up
up:  ## start all containers
	@docker-compose -f srcs/docker-compose.yml up -d
	@echo "Services started in detached mode."

.PHONY: down
down:  ## stop containers
	@docker-compose -f srcs/docker-compose.yml down
	@echo "Services stopped."

.PHONY: clean
clean: down  ## stop and remove container and other data
	@docker system prune -af
	# @rm -rf /home/$(USER)/luxesound/data
	@echo "Environment cleaned."

.PHONY: re
re: clean all  ## make clean build

.PHONY: ps
ps:  ## get status
	@docker-compose -f srcs/docker-compose.yml ps

.PHONY: logs
logs:  ## check logs
	@docker-compose -f srcs/docker-compose.yml logs

.PHONY: help
help:  ## Get help
	@echo -e 'Usage: make ${BLUE}<target>${NC} ${MARGENTA}<options>${NC}'
	@echo -e 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${BLUE}%-15s${NC} %s\n", $$1, $$2}' $(MAKEFILE_LIST)
