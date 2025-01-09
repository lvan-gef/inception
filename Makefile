NAME = inception

.PHONY: all
all: prepare build up

.PHONY: prepare
prepare:
	# @mkdir -p /home/$(USER)/data/wordpress
	# @mkdir -p /home/$(USER)/data/mariadb
	# @mkdir -p /Users/luxesound/data/wordpress
	# @mkdir -p /Users/luxesound/data/mariadb
	# @echo "Data directories created."
	mkdir -p /Users/luxesound/data/wordpress
	mkdir -p /Users/luxesound/data/mariadb
	# @sudo chown -R $(USER):$(USER) /home/$(id -un)/data
	# @sudo chmod -R 755 /Users/$(id -un)/data
	@echo "Data directories created with correct permissions."

.PHONY: build
build:
	@docker-compose -f srcs/docker-compose.yml build
	@echo "Docker images built successfully."

.PHONY: up
up:
	@docker-compose -f srcs/docker-compose.yml up -d
	@echo "Services started in detached mode."

.PHONY: down
down:
	@docker-compose -f srcs/docker-compose.yml down
	@echo "Services stopped."

.PHONY: clean
clean: down
	@docker system prune -af
	@sudo rm -rf /Users/luxesound/data
	@echo "Environment cleaned."

.PHONY: re
re: clean all

.PHONY: ps
ps:
	@docker-compose -f srcs/docker-compose.yml ps

.PHONY: logs
logs:
	@docker-compose -f srcs/docker-compose.yml logs
