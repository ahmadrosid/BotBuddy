# Colors
COLOR_RESET = \033[0m
COLOR_BOLD = \033[1m
COLOR_GREEN = \033[32m
COLOR_YELLOW = \033[33m

# Targets
install:
	@echo "$(COLOR_BOLD)=== Putting the services down (if already running) ===$(COLOR_RESET)"
	docker compose down --remove-orphans

	@echo "$(COLOR_BOLD)=== Setting up Docker environment ===$(COLOR_RESET)"
    # Copy .env.example to .env for backend-server
    # Show warning before continue, and wait for 10 seconds
	@echo "$(COLOR_BOLD)=== This will overwrite your .env files, you still have some time to abort ===$(COLOR_RESET)"
	@sleep 5
	@echo "$(COLOR_BOLD)=== Copying .env files ===$(COLOR_RESET)"
	cp -n backend-server/.env.example backend-server/.env 2>/dev/null || true
	cp common.env llm-server/.env 2>/dev/null || true
	docker compose build #--no-cache
	docker compose up -d #--force-recreate
	@echo "$(COLOR_BOLD)=== Waiting for services to start (~20 seconds) ===$(COLOR_RESET)"
	@sleep 20

	@echo "$(COLOR_BOLD)=== Clearing backend server config cache ===$(COLOR_RESET)"
	docker compose exec backend-server php artisan cache:clear
	docker compose exec backend-server php artisan config:cache

	@echo "$(COLOR_BOLD)=== Run backend server migrations ===$(COLOR_RESET)"
	docker compose exec backend-server php artisan migrate --seed
	docker compose exec backend-server php artisan storage:link

	@echo "$(COLOR_BOLD)=== Running backward compatibility scripts ===$(COLOR_RESET)"
	docker compose exec backend-server php artisan prompt:fill

	docker compose run -d backend-server php artisan queue:work --timeout=200

	@echo "$(COLOR_BOLD)=== Installation completed ===$(COLOR_RESET)"
	@echo "$(COLOR_BOLD)=== 🔥🔥 You can now access the dashboard at -> http://localhost:8000 ===$(COLOR_RESET)"
	@echo "$(COLOR_BOLD)=== Enjoy! ===$(COLOR_RESET)"

run-worker:
	docker compose exec backend-server php artisan queue:work --timeout=200

db-setup:
	docker compose exec backend-server php artisan migrate:fresh --seed

down:
	docker compose down --remove-orphans

exec-backend-server:
	docker compose exec backend-server bash
.PHONY: install down