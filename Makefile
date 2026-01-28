.PHONY: db-reset
db-reset:
	docker compose run --rm app bin/rails db:migrate:reset db:seed
