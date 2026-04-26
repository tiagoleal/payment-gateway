.PHONY: help build up down restart logs shell console test rspec cucumber clean

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker images
	docker-compose build

up: ## Start development environment (web + worker + selenium)
	docker-compose up web worker

down: ## Stop all containers
	docker-compose down

restart: ## Restart containers
	docker-compose restart

logs: ## Show container logs
	docker-compose logs -f

logs-worker: ## Show worker logs (jobs)
	docker-compose logs -f worker

shell: ## Open a shell in the web container
	docker-compose run --rm web bash

console: ## Open Rails console
	docker-compose run --rm web bundle exec rails console

db-migrate: ## Run migrations
	docker-compose run --rm web bundle exec rails db:migrate

db-rollback: ## Rollback the last migration
	docker-compose run --rm web bundle exec rails db:rollback

db-seed: ## Run seeds
	docker-compose run --rm web bundle exec rails db:seed

populate-clients: ## Run clients rake task
	docker-compose run --rm web bundle exec rake clients:create COUNT=20

db-reset: ## Reset the database
	docker-compose run --rm web bundle exec rails db:reset

test: rspec ## Run all tests (RSpec)

rspec: ## Run RSpec tests
	docker-compose run --rm test

rspec-file: ## Run a specific RSpec file (use: make rspec-file FILE=spec/models/user_spec.rb)
	docker-compose run --rm test bundle exec rspec $(FILE)

cucumber: ## Run Cucumber tests
	docker-compose run --rm cucumber

cucumber-file: ## Run a specific feature (use: make cucumber-file FILE=features/billing.feature)
	docker-compose run --rm cucumber bundle exec cucumber $(FILE)

bundle-install: ## Install gems
	docker-compose run --rm web bundle install
	docker-compose build web

clean: ## Remove containers, volumes, and images
	docker-compose down -v
	docker system prune -f

vnc: ## Show information to access Selenium VNC
	@echo "Access http://localhost:7900 in your browser"
	@echo "Password: secret"

jobs-trigger: ## Manually trigger the billing job
	docker-compose exec web bundle exec rails runner "Billing::SchedulerJob.perform_now"

jobs-status: ## Check queue status
	docker-compose exec web bundle exec rails runner "puts 'Pending: ' + SolidQueue::Job.where(finished_at: nil).count.to_s; puts 'Finished: ' + SolidQueue::Job.where.not(finished_at: nil).count.to_s"
