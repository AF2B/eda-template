############################################################
#                 EDA TEMPLATE - MAKEFILE                  #
#                                                          #
#  Comandos utilitários para desenvolvimento local        #
#  Stack: Kafka + Kafka UI + Producer + Consumer          #
############################################################

# ===============================
# 🎨 ANSI COLORS
# ===============================

RESET=\033[0m
BOLD=\033[1m
GREEN=\033[32m
BLUE=\033[34m
YELLOW=\033[33m
RED=\033[31m
CYAN=\033[36m

# ===============================
# 📦 PROJECT CONFIG
# ===============================

COMPOSE=docker compose
PROJECT_NAME=eda-template

# ===============================
# 📚 HELP (AUTO-DOCUMENTED)
# ===============================

.PHONY: help
help:
	@echo ""
	@echo "$(BOLD)$(CYAN)EDA TEMPLATE - AVAILABLE COMMANDS$(RESET)"
	@echo ""
	@echo "$(GREEN)Infra$(RESET)"
	@echo "  make up              → Start entire stack"
	@echo "  make down            → Stop stack"
	@echo "  make rebuild         → Rebuild everything (no cache)"
	@echo ""
	@echo "$(GREEN)Services$(RESET)"
	@echo "  make logs            → Follow all logs"
	@echo "  make logs-producer   → Follow producer logs"
	@echo "  make logs-consumer   → Follow consumer logs"
	@echo ""
	@echo "$(GREEN)Testing$(RESET)"
	@echo "  make publish         → Publish demo event"
	@echo "  make topics          → List Kafka topics"
	@echo ""
	@echo "$(GREEN)Maintenance$(RESET)"
	@echo "  make clean           → Remove containers + volumes"
	@echo ""

# ===============================
# 🚀 INFRA COMMANDS
# ===============================

.PHONY: up
up:
	@echo "$(BLUE)Starting stack...$(RESET)"
	@$(COMPOSE) up -d
	@echo "$(GREEN)Stack running.$(RESET)"
	@echo "$(CYAN)Kafka UI → http://localhost:8084$(RESET)"

.PHONY: down
down:
	@echo "$(YELLOW)Stopping stack...$(RESET)"
	@$(COMPOSE) down

.PHONY: rebuild
rebuild:
	@echo "$(BLUE)Rebuilding all services (no cache)...$(RESET)"
	@$(COMPOSE) down -v
	@$(COMPOSE) build --no-cache
	@$(COMPOSE) up -d
	@echo "$(GREEN)Rebuild complete.$(RESET)"

# ===============================
# 📜 LOGGING
# ===============================

.PHONY: logs
logs:
	@$(COMPOSE) logs -f

.PHONY: logs-producer
logs-producer:
	@$(COMPOSE) logs -f producer

.PHONY: logs-consumer
logs-consumer:
	@$(COMPOSE) logs -f consumer

# ===============================
# 🧪 TESTING
# ===============================

.PHONY: publish
publish:
	@echo "$(BLUE)Publishing demo event...$(RESET)"
	@curl -X POST http://localhost:8080
	@echo ""
	@echo "$(GREEN)Event sent.$(RESET)"

.PHONY: topics
topics:
	@echo "$(BLUE)Listing Kafka topics...$(RESET)"
	@docker exec -it $$(docker ps --filter "name=kafka" --format "{{.Names}}") \
		kafka-topics --bootstrap-server localhost:9092 --list

# ===============================
# 🧹 CLEANUP
# ===============================

.PHONY: clean
clean:
	@echo "$(RED)Removing containers, volumes and networks...$(RESET)"
	@$(COMPOSE) down -v --remove-orphans
	@echo "$(GREEN)Environment cleaned.$(RESET)"